;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: LIBM -*-
;;; Copyright (c) 2020 by Symbolics Pte. Ltd. All rights reserved.
(cl:in-package #:libm)

;;; CL style wrappers for openlibm functions.

(cl:defmacro define-cmplx-function (libmfun)
  "Make LIBMFUN behave like a CL equivalent for functions in the complex domain"
  (cl:let* ((g (cl:gensym))
   	    (fun (cl:string-upcase libmfun))
  	    (double-sym       (cl:intern fun "%LIBM"))
  	    (float-sym        (cl:intern (cl:concatenate 'cl:string     fun "F") "%LIBM"))
  	    (dbl-complex-sym  (cl:intern (cl:concatenate 'cl:string "C" fun)     "%LIBM"))
  	    (flt-complex-sym  (cl:intern (cl:concatenate 'cl:string "C" fun "F") "%LIBM")))
    `(cl:defun ,(cl:intern fun) (,g)
       (cl:etypecase ,g
       	 (cl:double-float (,double-sym ,g))
       	 (cl:single-float (,float-sym  ,g))
	 (cl:complex (cl:etypecase (cl:realpart ,g)
	 	       (cl:double-float (,dbl-complex-sym  ,g))
	 	       (cl:single-float (,flt-complex-sym   ,g))
	 	       (cl:rational (cl:error "libm complex numbers cannot be composed of rationals"))))))))

(cl:defmacro define-function (libmfun)
  "Make LIBMFUN behave like a CL equivalent"
  (cl:let* ((g (cl:gensym))
   	    (fun (cl:string-upcase libmfun))
  	    (double-sym       (cl:intern fun "%LIBM"))
  	    (float-sym        (cl:intern (cl:concatenate 'cl:string     fun "F") "%LIBM"))
	   )
    `(cl:defun ,(cl:intern fun) (,g)
       (cl:etypecase ,g
       	 (cl:double-float (,double-sym ,g))
       	 (cl:single-float (,float-sym  ,g))
	 (cl:complex (cl:error "function is not defined in the complex domain in libm"))))))



;;;
;;; ANSI / POSIX
;;;

(define-cmplx-function "acos")
(define-cmplx-function "asin")

(cl:defun atan (x cl:&optional y) ; define here because CL has optional arguments
  "Return arcsine of x"
  (cl:etypecase x
    (cl:double-float (cl:if y (%libm:atan2  x y) (%libm:atan  x)))
    (cl:single-float (cl:if y (%libm:atan2f x y) (%libm:atanf x)))
    (cl:complex (cl:typecase (cl:realpart x)
		  (cl:double-float (%libm:catan  x))
		  (cl:single-float (%libm:catanf x))
		  (cl:rational (cl:error "libm complex numbers cannot be composed of rationals"))))))

(define-cmplx-function "cos")
(define-cmplx-function "sin")
(define-cmplx-function "tan")

;;; Hyperbolic functions

(define-cmplx-function "cosh")
(define-cmplx-function "sinh")
(define-cmplx-function "tanh")

(define-cmplx-function "exp")			;Returns _e_ raised to the power _number_, where _e_ is the base of the natural logarithms
(define-function "exp2")			;Returns 2 raised to the power _number_"

;; Not in test suite; no direct CL equivalent
(cl:defun frexp (x exp)
  "Splits a real number into a mantissa and exponent"
  (cl:etypecase x
    (cl:double-float (%libm:frexp  x exp))
    (cl:single-float (%libm:frexpf x exp))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))

;; Not in test suite; no direct CL equivalent
(cl:defun ldexp (x exp)
  "Returns the result of multiplying _x_ (the significand) by 2 raised to the power of _exp_ (the exponent)."
  (cl:etypecase x
    (cl:double-float (%libm:ldexp  x exp))
    (cl:single-float (%libm:ldexpf x exp))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))

(define-cmplx-function "log")			;Returns the natural logarithm of x
(define-function "log10")			;Returns the common (base-10) logarithm of x.

(cl:defun modf (x y)
  "Decomposes a number into integer and fractional parts"
  (cl:etypecase x
    (cl:double-float (%libm:modf x y))
    (cl:single-float (%libm:modf x y))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))

(cl:defun pow (base exp)
  "Returns _base_ raised to the power _exponent_. The same as CL:EXPT"
  (cl:etypecase base
    (cl:double-float (%libm:pow base exp))
    (cl:single-float (%libm:powf base exp))
    (cl:complex (cl:typecase (cl:realpart base)
		  (cl:double-float (%libm:cpow  base exp))
		  (cl:single-float (%libm:cpowf base exp))
		  (cl:rational (cl:error "libm complex numbers cannot be composed of rationals"))))))

(define-cmplx-function "sqrt")
(define-function "ceil")

(cl:defun abs (x) ; libm has inconsistent naming of this function
  "Computes absolute value of a number"
  (cl:etypecase x
    (cl:double-float (%libm:fabs  x))
    (cl:single-float (%libm:fabsf x))
    (cl:complex (cl:typecase (cl:realpart x)
		  (cl:double-float (%libm:cabs  x))
		  (cl:single-float (%libm:cabsf x))
		  (cl:rational (cl:error "libm complex numbers cannot be composed of rationals"))))))

(define-function "floor")		;returns the nearest integer not greater than the given value

(cl:defun fmod (numerator denominator) ; floating point modulus
  "Returns the floating-point remainder of numer/denom (rounded towards zero)"
  (cl:etypecase numerator
    (cl:double-float (%libm:modf  numerator denominator))
    (cl:single-float (%libm:fmodf numerator denominator))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))



;;; Functions defined in C99

(define-cmplx-function "acosh")
(define-cmplx-function "asinh")
(define-cmplx-function "atanh")

(define-function "cbrt") 		; Returns the cubic root of x
(define-function "expm1") 		; Returns e raised to the power x minus one.
					; For small values of x, expm1 may be more accurate than exp(x)-1

(define-function "erf")
(define-function "erfc")

(cl:defun fma (x y z)
  "Returns x*y+z without losing precision in any intermediate result."
  (cl:etypecase x
    (cl:double-float (%libm:fma  x y z))
    (cl:single-float (%libm:fmaf x y z))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))

(cl:defun hypot (x y)
  "Returns the _hypotenuse_ of a _right-angled triangle_ whose legs are x and y."
  (cl:etypecase x
    (cl:double-float (%libm:hypot  x y))
    (cl:single-float (%libm:hypotf x y))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))


;;; These deal with the hardware representation of floating point and
;;; do not have a lisp equivalents
(define-function "ilogb")		;Returns the integral part of the logarithm of |x|, using FLT_RADIX as base for the logarithm."
;;(define-function "isinf")		;Returns non-zero if the given floating point value is an infinity
(define-function "isnan")		;Returns non-zero if the given floating point value is a NaN

(define-function "lgamma")		;Returns the _natural logarithm_ of the absolute value of the gamma function of x.
(define-function "log1p")		;Returns the _natural logarithm_ of one plus x."
(define-function "log2")		;Returns the _binary_ (base-2) _logarithm_ of x."
(define-function "logb")		;Returns the logarithm base 2 of |x|, rounded down to an integer"

#|
;;; These do not have an exact analog in CL. They differ in the return
;;; types. Not a good candidate for access at this level.

;; long	lrint(double);
(cffi:defcfun "lrint" :long
  "Returns the _hypotenuse_ of a _right-angled triangle_ whose legs are x and y."
  (x :double))

;; long	lround(double);
(cffi:defcfun "lround" :long
  "Rounds a floating-point number to an integer"
  (x :double))

;; double	rint(double);
(cffi:defcfun "rint" :double
  "Rounds a floating-point number to an integer value"
  (x :double))
|#

#| Avoid anything that requires CFFI memory management at this level
;; double	nan(const char *) __pure2;
(cffi:defcfun "nan" :double
  "Converts the implementation-defined character string arg into the corresponding quiet NaN value"
  (p (:pointer :char))) ; This needs testing
|#

(cl:defun nextafter (x y)
  "Returns the next representable value after _x_ in the direction of _y_"
  (cl:etypecase x
    (cl:double-float (%libm:nextafter  x y))
    (cl:single-float (%libm:nextafterf x y))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))

(cl:defun remainder (x y)
  "Returns the floating-point remainder of x/y (rounded towards zero):

remainder = x - n * y

Where n is the result of: x/y, rounded toward the nearest
integral value (with halfway cases rounded toward the even number)"
  (cl:etypecase x
    (cl:double-float (%libm:remainder  x y))
    (cl:single-float (%libm:remainderf x y))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))


#| Avoid anything that requires CFFI memory management at this level
;; double	remquo(double, double, int *);
(cffi:defcfun "remquo" :double
  "Calculates the integer quotient and the remainder of a floating-point division"
  (x :double)
  (y :double)
  (i (:pointer :int)))
|#


;;; Bessel functions
;;; See: http://www.netlib.org/math/docpdf/ch02-04.pdf

(define-function "j0")			;Returns the order-zero Bessel function of the first kind
(define-function "j1")			;Returns the order-one Bessel function of the first kind

(cl:defun jn (n x)
  "Returns the order-n Bessel function of the first kind."
  (cl:etypecase x
    (cl:double-float (%libm:jn  n x))
    (cl:single-float (%libm:jnf n x))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))


(define-function "y0")			;Returns the order-zero Bessel function of the second kindn
(define-function "y1")			;Returns the order-one Bessel function of the second kind

(cl:defun yn (n x)
  "Returns the order-n Bessel function of the second kind."
  (cl:etypecase x
    (cl:double-float (%libm:yn n x))
    (cl:single-float (%libm:ynf n x))
    (cl:complex (cl:error "complex yn not wrapped yet"))))



;;; Back to numerical functions

(cl:defun copysign (x y)
  "Returns the next representable value after _x_ in the direction of _y_"
  (cl:etypecase x
    (cl:double-float (%libm:copysign  x y))
    (cl:single-float (%libm:copysignf x y))
    (cl:complex (cl:error "function is not defined in the complex domain in libm"))))

(cl:defun fdim (x y)
  "Returns the positive difference between x and y."
  (cl:etypecase x
    (cl:double-float (%libm:fdim  x y))
    (cl:single-float (%libm:fdimf x y))
    (cl:complex (cl:error "complex fdim not wrapped yet"))))

(cl:defun fmax (x y)
  "Returns the larger of its arguments: either x or y."
  (cl:etypecase x
    (cl:double-float (%libm:fmax  x y))
    (cl:single-float (%libm:fmaxf x y))
    (cl:complex (cl:error "complex fmax not wrapped yet"))))

(cl:defun fmin (x y)
  "Returns the smaller of its arguments: either x or y.

If one of the arguments in a NaN, the other is returned."
  (cl:etypecase x
    (cl:double-float (%libm:fmin x y))
    (cl:single-float (%libm:fminf x y))
    (cl:complex (cl:error "complex fmin not wrapped yet"))))

(define-function "nearbyint")		;Rounds x to an integral value, using the rounding direction specified by fegetround
(define-function "round")		;Returns the integral value that is nearest to x, with halfway cases rounded away from zero


#|
;;; There isn't any distinction between a long integer and a short
;;; integer in CL, so these don't make sense to expose at this
;;; level. At some level CFFI-LIBFFI must make this distinction; once
;;; known this could be wrapped, if desired.

;; double	scalbln(double, long);
(cffi:defcfun "scalbln" :double
  "Multiplies a floating-point number by a power of the floating-point radix"
  (x :double)
  (n :long))

;; double	scalbn(double, int);
(cffi:defcfun "scalbn" :double
  "Multiplies a floating-point number by a power of the floating-point radix"
  (x :double)
  (n :int))

;; float	scalblnf(float, long);
(cffi:defcfun "scalblnf" :float
  "Multiplies a floating-point number by a power of the floating-point radix"
  (x :float)
  (n :long))

;; float	scalbnf(float, int);
(cffi:defcfun "scalbnf" :float
  "Multiplies a floating-point number by a power of the floating-point radix"
  (x :float)
  (n :int))
|#

(cl:defun tgamma (x)
  "Returns the gamma function of x."
  (cl:etypecase x
    (cl:double-float (%libm:tgamma  x))
    (cl:single-float (%libm:tgammaf x))
    (cl:complex (cl:error "complex tgamma not wrapped yet"))))

(cl:defun trunc (x) ; CL:FTRUNCTE
  "Rounds x toward zero, returning the nearest integral value that is not larger in magnitude than x."
  (cl:etypecase x
    (cl:double-float (%libm:trunc  x))
    (cl:single-float (%libm:truncf x))
    (cl:complex (cl:error "complex trunc not wrapped yet"))))
