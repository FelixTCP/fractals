#include "complex_number.hpp"
#include <ostream>

double complex_number::get_real() const { return this->real; }
double complex_number::get_imag() const { return this->imag; }

void complex_number::set_real(double real) { this->real = real; }
void complex_number::set_imag(double imag) { this->imag = imag; }

complex_number &complex_number::operator+=(const complex_number &c) {
  this->real += c.real;
  this->imag += c.imag;
  return *this;
};

complex_number &complex_number::operator-=(const complex_number &c) {
  this->real -= c.real;
  this->imag -= c.imag;
  return *this;
}

complex_number &complex_number::operator*=(const complex_number &c) {
  double r = this->real;
  double i = this->imag;
  this->real = r * c.real - i * c.imag;
  this->imag = r * c.imag + i * c.real;
  return *this;
}

complex_number operator+(const complex_number &lhs, const complex_number &rhs) {
  complex_number c = lhs;
  c += rhs;
  return c;
}

complex_number operator-(const complex_number &lhs, const complex_number &rhs) {
  complex_number c = lhs;
  c -= rhs;
  return c;
}

complex_number operator*(const complex_number &lhs, const complex_number &rhs) {
  complex_number c = lhs;
  c *= rhs;
  return c;
}

std::ostream &operator<<(std::ostream &stream, const complex_number &c) {
  stream << c.get_real() << (c.get_imag() >= 0 ? "+" : "") << c.get_imag()
         << "i" << std::endl;
  return stream;
}

double complex_number::abs(const complex_number &c) {
  return std::hypot(c.get_real(), c.get_imag());
}
