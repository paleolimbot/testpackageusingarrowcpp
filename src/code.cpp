
#include <cpp11.hpp>
using namespace cpp11;

#include "arrow/api.h"

[[cpp11::register]]
void fun() {
  arrow::FloatScalar scalar(5.4);
}
