#include "color.hpp"
#include "complex_number.hpp"
#include <png++/image.hpp>
#include <png++/rgb_pixel.hpp>
#include <string>
#include <string_view>
#include <chrono>

complex_number &mandel(complex_number &z, const complex_number &c) {
  return z * z += c;
}
complex_number &cubic(complex_number &z, const complex_number &c) {
  return z * z * z += c;
}

int steps(complex_number c, int max_iter, std::string_view flag) {
  complex_number z = 0;
  int i = 0;
  while (i < max_iter) {
    if (flag == "-c")
      z = cubic(z, c);
    else
      z = mandel(z, c);

    if (abs(z.get_real()) > 2 || abs(z.get_imag()) > 2)
      return i;
    ++i;
  }
  return i;
}

int main(int argc, char **argv) {

  auto start = std::chrono::high_resolution_clock::now();

  int width = atoi(argv[1]);
  int height = atoi(argv[2]);
  std::string filename = std::string(argv[3]);
  png::image<png::rgb_pixel> image(width, height);

  double anker_x = atof(argv[4]);
  double anker_y = atof(argv[6]);
  double max_x = atof(argv[5]);
  double max_y = atof(argv[7]);
  int max_iter = argc >= 9 ? atoi(argv[8]) : 1000;

  double step_x = (max_x - anker_x) / width;
  double step_y = -(anker_y - max_y) / height;


#pragma omp parallel for
  for (int h = 0; h < height; ++h) {
    complex_number current = complex_number(anker_x, anker_y + h * step_y);
    for (int w = 0; w < width; ++w) {
      std::string_view flag = argc >= 10 ? std::string_view(argv[9]) : "";
      int s = steps(current, max_iter, flag);
      if (s != max_iter)
        image.set_pixel(w, h, color_map(s % max_iter, max_iter));
      current += step_x;
    }
  }

  image.write(filename);

  auto end = std::chrono::high_resolution_clock::now();
  std::chrono::duration<double> diff = end - start;
  std::cout << "Time to generate frame: " << diff.count() << " seconds" << std::endl;

  return 0;
}
