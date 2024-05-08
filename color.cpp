#include <cmath>
#include <png++/png.hpp>

using namespace png;

// Kann als magisch angenommen werden.
// Bei Interesse: https://de.wikipedia.org/wiki/HSV-Farbraum
rgb_pixel color_map(float n, float max) {
  float val = max - n;
  float h = 240.0 * val / max;

  h = 360 * n / max;

  float r, g, b;
  float s = 0.9;
  float v = 0.8;

  int hi = floor(h / 60.0);
  float f = (h / 60.0) - hi;
  float p = v * (1 - s);
  float q = v * (1 - s * f);
  float t = v * (1 - s * (1 - f));

  switch(hi){
    case 0:
    case 6:
        r = v;
        g = t;
        b = p;
        break;
    case 1:
        r = q;
        g = v;
        b = p;
        break;
    case 2:
        r = p;
        g = v;
        b = t;
        break;
    case 3:
        r = p;
        g = q;
        b = v;
        break;
    case 4:
        r = t;
        g = p;
        b = v;
        break;
    default:
        r = v;
        g = p;
        b = q;
        break;

  }

  return rgb_pixel(r * 255, g * 255, b * 255);
}
