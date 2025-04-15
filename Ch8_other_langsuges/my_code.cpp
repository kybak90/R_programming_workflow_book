#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double multiply(double x, double y)
{
  return x * y;
}

// [[Rcpp::export]]
int add(int x, int y)
{
  Rcout << "x = " << x << ", y = " << y << std::endl;
  return x + y;
}