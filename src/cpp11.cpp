// Generated by cpp11: do not edit by hand
// clang-format off


#include "cpp11/declarations.hpp"
#include <R_ext/Visibility.h>

// code.cpp
void fun();
extern "C" SEXP _testpackageusingarrowcpp_fun() {
  BEGIN_CPP11
    fun();
    return R_NilValue;
  END_CPP11
}

extern "C" {
static const R_CallMethodDef CallEntries[] = {
    {"_testpackageusingarrowcpp_fun", (DL_FUNC) &_testpackageusingarrowcpp_fun, 0},
    {NULL, NULL, 0}
};
}

extern "C" attribute_visible void R_init_testpackageusingarrowcpp(DllInfo* dll){
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
