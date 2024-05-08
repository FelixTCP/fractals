#include "color.hpp"
#include <string>
#include <iostream>
#include <chrono>
#include <fstream>

__global__ 
void draw_pixel(const double real_anker,
                const double imag_anker,
                const double real_step,
                const double imag_step,
                int *result,
                const int max_iter,
                const int width,
                const int height,
                const long long already_calculated_pixels){
  const int index = threadIdx.x + blockIdx.x * blockDim.x + already_calculated_pixels;

  if (index >= width * height)
    return;

  const double real = real_anker + real_step * (index % width);
  const double imag = imag_anker - imag_step * (index / height);
  
  int i = 0;
  double z_real = 0; 
  double z_imag = 0;
  double z_real_new = 0;
  double z_imag_new = 0;
  
  while (i < max_iter){
    z_real_new = z_real * z_real - z_imag * z_imag + real;
    z_imag_new = z_real * z_imag + z_imag * z_real + imag;

    if (z_real_new > 2 || z_real_new < -2 ||
        z_imag_new > 2 || z_imag_new < -2)
      break;

    z_real = z_real_new;
    z_imag = z_imag_new;
    i++;
  }
  result[index] = i;
}

int main(int argc, char **argv){
  auto start = std::chrono::high_resolution_clock::now();

  const int width = atoi(argv[1]);
  const int height = atoi(argv[2]);
  const std::string filename = std::string(argv[3]);
  png::image<png::rgb_pixel> image(width, height);

  const double anker_real = atof(argv[4]);
  const double max_real = atof(argv[5]);
  const double anker_imag = atof(argv[6]);
  const double min_imag = atof(argv[7]);
  const int max_iter = argc >= 9 ? atoi(argv[8]) : 2000;

  const long long pixels = width * height;

  int *result;
  result = (int *)malloc(pixels * sizeof(int));

  if (!result){auto end = std::chrono::high_resolution_clock::now();

    // Calculate the difference in seconds
    auto duration = std::chrono::duration_cast<std::chrono::seconds>(end - start);
    std::cerr << "Failed to allocate memory on the host." << std::endl;
    return -1;
  }

  const double step_real = (max_real - anker_real) / width;
  const double step_imag = (anker_imag - min_imag) / height;

  int *d_result;
  cudaMalloc(&d_result, pixels * sizeof(int));

  int blockSize, gridSize;
  cudaOccupancyMaxPotentialBlockSize(&blockSize, &gridSize, draw_pixel, 0, 0);

  // TODO strided loop 
  // TODO use fast maths flag??
  // TODO https://developer.nvidia.com/blog/cuda-pro-tip-write-flexible-kernels-grid-stride-loops/
  long long already_calculated_pixels = 0;
  
  cudaEvent_t start_kernel, stop_kernel;
  float time_kernel;
  cudaEventCreate(&start_kernel);
  cudaEventCreate(&stop_kernel);
  cudaDeviceSynchronize();
  cudaEventRecord(start_kernel, 0);
  while (already_calculated_pixels < pixels){
    draw_pixel<<<gridSize, blockSize>>>(anker_real,
                                        anker_imag,
                                        step_real,
                                        step_imag,
                                        d_result,
                                        max_iter,
                                        width,
                                        height,
                                        already_calculated_pixels);
    already_calculated_pixels += gridSize * blockSize - 1;
  }
  cudaDeviceSynchronize();

  // Calculate the difference in milliseconds and save it to kernel_time_i
  cudaEventRecord(stop_kernel, 0);
  cudaEventSynchronize(stop_kernel);
  cudaEventElapsedTime(&time_kernel, start_kernel, stop_kernel);
  cudaEventDestroy(start_kernel);
  cudaEventDestroy(stop_kernel);
  std::ofstream out("kernel_time", std::ios::app);
  out << time_kernel << "\n";
  out.close();

  cudaMemcpy(result, d_result, pixels * sizeof(int), cudaMemcpyDeviceToHost);
  cudaFree(d_result);

  for (int i = 0; i < pixels; ++i){
    if (result[i] == max_iter)
      continue;
    image.set_pixel(i % width, i / height, color_map(result[i] % (max_iter / 2), max_iter / 2));
  }

  image.write(filename);

  if (argc >= 10 && std::string(argv[9]) == "-t"){
    auto diff = std::chrono::high_resolution_clock::now() - start;
    std::cout << "Time to generate frame: " << diff.count() << " seconds" << std::endl;
  }

  return 0;
}
