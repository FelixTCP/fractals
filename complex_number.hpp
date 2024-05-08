#include <cmath>
#include <ostream>
class complex_number {
private:
  double real;
  double imag;

public:
  complex_number(double real) : real(real), imag(0.0) {}
  complex_number(double real, double imag) : real(real), imag(imag) {}

  double get_real() const;
  double get_imag() const;

  void set_real(double real);
  void set_imag(double imag);

  complex_number &operator+=(const complex_number &c);
  complex_number &operator-=(const complex_number &c);
  complex_number &operator*=(const complex_number &c);

  friend complex_number operator+(const complex_number &lhs,
                                  const complex_number &rhs);

  friend complex_number operator-(const complex_number &lhs,
                                  const complex_number &rhs);

  friend complex_number operator*(const complex_number &lhs,
                                  const complex_number &rhs);

  friend std::ostream &operator<<(std::ostream &stream,
                                  const complex_number &c);

  double abs(const complex_number &c);
};
