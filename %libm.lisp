;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: LIBM -*-
;;; Copyright (c) 2020 by Symbolics Pte. Ltd. All rights reserved.
(cl:in-package #:%libm)

;;; The purpose of this library is, similar to Julia, to have a good
;;; libm for the Common Lisp statistics programming that works
;;; consistently across compilers and operating systems.

;;; Although this isn't as powerful as the CL numeric tower, floating
;;; point is all that Python and Julia have, so it makes interop a bit
;;; easier. It's also good for testing CL version of special and
;;; statistical functions.

;;; This library was wrapped by hand from the openlibm_math.h header
;;; file.


;;;
;;; ANSI / POSIX
;;;

;; double	acos(double);
(cffi:defcfun "acos" :double (x :double))

;; double	asin(double);
(cffi:defcfun "asin" :double (x :double))

;; double	atan(double);
(cffi:defcfun "atan" :double (x :double))

;; double	atan2(double, double);
(cffi:defcfun "atan2" :double (x :double) (y :double))

;; double	cos(double);
(cffi:defcfun "cos" :double (x :double))

;; double	sin(double);
(cffi:defcfun "sin" :double (x :double))

;; double	tan(double);
(cffi:defcfun "tan" :double (x :double))



;;; Hyperbolic functions

;; double	cosh(double);
(cffi:defcfun "cosh" :double (x :double))

;; double	sinh(double);
(cffi:defcfun "sinh" :double (x :double))

;; double	tanh(double);
(cffi:defcfun "tanh" :double (x :double))



;;; Exponential functions

;; double	exp(double);
(cffi:defcfun "exp" :double (x :double))

;; double	frexp(double, int *);	/* fundamentally !__pure2 */
(cffi:defcfun "frexp" :double
  "Splits a real number into a mantissa and exponent"
  (x :double) (p :pointer :int))

;; double	ldexp(double, int);
(cffi:defcfun "ldexp" :double
  "returns the result of multiplying the floating-point number x by 2 raised to the power exp"
  (x :double) (exp :int))

;; double	log(double);
(cffi:defcfun "log" :double (x :double))

;; double	log10(double);
(cffi:defcfun "log10" :double (x :double))

;; double	modf(double, double *);	/* fundamentally !__pure2 */
(cffi:defcfun "modf" :double (x :double) (p (:pointer :double)))

#|;; Some quick tests for the functions using pointers
(cl:defvar *pti* (cffi:foreign-alloc :int)) ; *pti* -> pointer to int
(%libm::frexp 123.45d0 *pti*) ; -> 0.964453
(cffi:mem-aref *pti* :int) ; -> 7

(%libm::ldexp 7.0d0 -4) ; ->0.4375

(cl:defvar *ptd* (cffi:foreign-alloc :double)) ; *ptd* -> pointer to double
(%libm::modf 123.45d0 *ptd*) ;  -> 0.45d0
(cffi:mem-aref *ptd* :double) ; -> 123.0d0
|#


;; double	pow(double, double);
(cffi:defcfun "pow" :double (x :double)(y :double))

;; double	sqrt(double);
(cffi:defcfun "sqrt" :double (x :double))

;; double	ceil(double);
(cffi:defcfun "ceil" :double (x :double))

;; double	fabs(double) __pure2;
(cffi:defcfun "fabs" :double (x :double))

;; double	floor(double);
(cffi:defcfun "floor" :double (x :double))

;; double	fmod(double, double);
(cffi:defcfun "fmod" :double (x :double)(y :double))




;;
;; These functions are not in C90.
;;

;; double	acosh(double);
(cffi:defcfun "acosh" :double (x :double))

;; double	asinh(double);
(cffi:defcfun "asinh" :double (x :double))

;; double	atanh(double);
(cffi:defcfun "atanh" :double (x :double))

;; double	cbrt(double);
(cffi:defcfun "cbrt" :double
  "Calculates the cube root of a number"
  (x :double))

;; double	erf(double);
(cffi:defcfun "erf" :double (x :double))

;; double	erfc(double);
(cffi:defcfun "erfc" :double (x :double))

;; double	exp2(double);
(cffi:defcfun "exp2" :double (x :double))

;; double	expm1(double);
(cffi:defcfun "expm1" :double
  "Calculates the natural exponential of a number, minus one"
  (x :double))

;; double	fma(double, double, double);
(cffi:defcfun "fma" :double
  "Multiplies two numbers and adds a third number to their product"
  (x :double)
  (y :double)
  (z :double))

;; double	hypot(double, double);
(cffi:defcfun "hypot" :double
  "Calculates a hypotenuse by the Pythagorean formula"
  (x :double)
  (y :double))

;; int	ilogb(double) __pure2;
(cffi:defcfun "ilogb" :int
  "Returns the exponent of a floating-point number as an integer"
  (x :double))

;; int	(isinf)(double) __pure2;
(cffi:defcfun "isinf" :int
  "Returns non-zero if the given floating point value is an infinity"
  (x :double))

;; int	(isnan)(double) __pure2;
(cffi:defcfun "isnan" :int
  "Returns non-zero if the given floating point value is a NaN"
  (x :double))

;; double	lgamma(double);
(cffi:defcfun "lgamma" :double (x :double))

;; long long llrint(double);
;; long long llround(double);

;; double	log1p(double);
(cffi:defcfun "log1p" :double
  "Calculates the logarithm of one plus a number"
  (x :double))

;; double	log2(double);
(cffi:defcfun "log2" :double
  "Calculates the logarithm to base 2 of a number"
  (x :double))

;; double	logb(double);
(cffi:defcfun "logb" :double
  "Obtains the exponent of a floating-point number"
  (x :double))

;; long	lrint(double);
(cffi:defcfun "lrint" :long
  "Rounds a floating-point number to an integer"
  (x :double))

;; long	lround(double);
(cffi:defcfun "lround" :long
  "Rounds a floating-point number to an integer"
  (x :double))

;; double	nan(const char *) __pure2;
(cffi:defcfun "nan" :double
  "Converts the implementation-defined character string arg into the corresponding quiet NaN value"
  (p (:pointer :char))) ; This needs testing

;; double	nextafter(double, double);
(cffi:defcfun "nextafter" :double
  "Returns the next value to the first argument x, removed from it in the direction toward the value of y"
  (x :double)
  (y :double))

;; double	remainder(double, double);
(cffi:defcfun "remainder" :double
  "Calculates the remainder of a floating-point division"
  (x :double)
  (y :double))

;; double	remquo(double, double, int *);
(cffi:defcfun "remquo" :double
  "Calculates the integer quotient and the remainder of a floating-point division"
  (x :double)
  (y :double)
  (i (:pointer :int)))

;; double	rint(double);
(cffi:defcfun "rint" :double
  "Rounds a floating-point number to an integer value"
  (x :double))


;;; Special Functions

;; double	j0(double);
(cffi:defcfun "j0" :double
  "Returns the Bessel function of the first kind of order 0 of x."
  (x :double))

;; double	j1(double);
(cffi:defcfun "j1" :double
  "Returns the Bessel function of the first kind of order 1 of x."
  (x :double))

;; double	jn(int, double);
(cffi:defcfun "jn" :double
  "Returns the Bessel function of the first kind of order n of x."
  (n :int)
  (x :double))

;; double	y0(double);
(cffi:defcfun "y0" :double
  "Returns the Bessel function of the second kind of order 0 of x."
  (x :double))

;; double	y1(double);
(cffi:defcfun "y1" :double
  "Returns the Bessel function of the second kind of order 0 of x."
  (x :double))

;; double	yn(int, double);
(cffi:defcfun "yn" :double
  "Returns the Bessel function of the second kind of order n of x."
  (n :int)
  (x :double))


;; double	copysign(double, double) __pure2;
(cffi:defcfun "copysign" :double
  "Makes the sign of the first argument match that of the second"
  (x :double)
  (y :double))

;; double	fdim(double, double);
(cffi:defcfun "fdim" :double
  "Returns (- x y) or 0, whichever is greater"
  (x :double)
  (y :double))

;; double	fmax(double, double) __pure2;
(cffi:defcfun "fmax" :double
  "Determines the greater of two double floating-point numbers"
  (x :double)
  (y :double))

;; double	fmin(double, double) __pure2;
(cffi:defcfun "fmin" :double
  "Determines the lesser of two double floating-point numbers"
  (x :double)
  (y :double))

;; double	nearbyint(double);
(cffi:defcfun "nearbyint" :double
  "Rounds a floating-point number to an integer value"
  (x :double))

;; double	round(double);
(cffi:defcfun "round" :double
  "Rounds a floating-point number to an integer value"
  (x :double))

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

;; double	tgamma(double);
(cffi:defcfun "tgamma" :double
  "Computes the gamma value of x"
  (x :double))

;; double	trunc(double);
(cffi:defcfun "trunc" :double
  "Rounds a floating-point number toward 0 to an integer value"
  (x :double))



;;
;; BSD math library entry points
;;

(cffi:defcfun isnanf :int
  "Return a nonzero value if x is a NaN value, and 0 otherwise. Obsolete."
  (x :float))

;; Reentrant version of lgamma; passes signgam back by reference as the
;; second argument; user must allocate space for signgam.
;; double	lgamma_r(double, int *);
(cffi:defcfun "lgamma_r" :double
  "Reentrant version of lgamma"
  (x :double)
  (i (:pointer :int)))

;; Single sine/cosine function.  User must allocate space for s and c
;; void	sincos(double, double *, double *);
(cffi:defcfun "sincos" :double
  "Calculate sin and cos simultaneously"
  (x :double)
  (s (:pointer :double))  ; pointer to sine
  (c (:pointer :double))) ; pointer to cosine


;;
;; Float versions of ANSI/POSIX functions
;;

;; float	acosf(float);
(cffi:defcfun "acosf" :float
  "Calculates the inverse cosine of a number"
  (x :float))

;; float	asinf(float);
(cffi:defcfun "asinf" :float (x :float))

;; float	atanf(float);
(cffi:defcfun "atanf" :float (x :float))

;; float	atan2f(float, float);
(cffi:defcfun "atan2f" :float (x :float) (y :float))

;; float	cosf(float);
(cffi:defcfun "cosf" :float (x :float))

;; float	sinf(float);
(cffi:defcfun "sinf" :float (x :float))

;; float	tanf(float);
(cffi:defcfun "tanf" :float (x :float))



;;; Hyperbolic functions

;; float	coshf(float);
(cffi:defcfun "coshf" :float (x :float))

;; float	sinhf(float);
(cffi:defcfun "sinhf" :float (x :float))

;; float	tanhf(float);
(cffi:defcfun "tanhf" :float (x :float))

;; float	frexpf(float, int *);	/* fundamentally !__pure2 */
(cffi:defcfun "frexpf" :float
  "Splits a real number into a mantissa and exponent"
  (x :float) (p :pointer :int))

;; int	ilogbf(float) __pure2;
(cffi:defcfun "ilogbf" :int
  "Returns the exponent of a floating-point number as an integer"
  (x :float))

;; float	log1pf(float);
(cffi:defcfun "log1pf" :float
  "Calculates the logarithm of one plus a number"
  (x :float))

;; float	log2f(float);
(cffi:defcfun "log2f" :float
  "Calculates the logarithm to base 2 of a number"
  (x :float))



;;; Exponential functions

;; float	exp2f(float);
(cffi:defcfun "exp2f" :float (x :float))

;; float	expf(float);
(cffi:defcfun "expf" :float (x :float))

;; float	expm1f(float);
(cffi:defcfun "expm1f" :float
  "Returns e raised to the power x minus one."
  (x :float))

;; float	ldexpf(float, int);
(cffi:defcfun "ldexpf" :float
  "returns the result of multiplying the floating-point number x by 2 raised to the power exp"
  (x :float)
  (exp :int))

;; float	logf(float);
(cffi:defcfun "logf" :float (x :float))

;; float	log10f(float);
(cffi:defcfun "log10f" :float (x :float))

;; float	modff(float, float *);	/* fundamentally !__pure2 */
(cffi:defcfun "modff" :float (x :float) (p (:pointer :float)))

;; float	powf(float, float);
(cffi:defcfun "powf" :float (x :float)(y :float))

;; float	sqrtf(float);
(cffi:defcfun "sqrtf" :float (x :float))

;; float	ceilf(float);
(cffi:defcfun "ceilf" :float (x :float))

;; float	fabsf(float) __pure2;
(cffi:defcfun "fabsf" :float (x :float))

;; float	floorf(float);
(cffi:defcfun "floorf" :float (x :float))

;; float	fmodf(float, float);
(cffi:defcfun "fmodf" :float (x :float)(y :float))

;; float	roundf(float);
(cffi:defcfun "roundf" :float (x :float))

;; float	erff(float);
(cffi:defcfun "erff" :float (x :float))

;; float	erfcf(float);
(cffi:defcfun "erfcf" :float (x :float))

;; float	hypotf(float, float);
(cffi:defcfun "hypotf" :float
  "Calculates a hypotenuse by the Pythagorean formula"
  (x :float)
  (y :float))

;; float	lgammaf(float);
(cffi:defcfun "lgammaf" :float (x :float))

;; float	tgammaf(float);
(cffi:defcfun "tgammaf" :float (x :float))

;; float	acoshf(float);
(cffi:defcfun "acoshf" :float (x :float))

;; float	asinhf(float);
(cffi:defcfun "asinhf" :float (x :float))

;; float	atanhf(float);
(cffi:defcfun "atanhf" :float (x :float))

;; float	cbrtf(float);
(cffi:defcfun "cbrtf" :float (x :float))

;; float	logbf(float);
(cffi:defcfun "logbf" :float (x :float))

;; float	copysignf(float, float) __pure2;
(cffi:defcfun "copysignf" :float
  "Makes the sign of the first argument match that of the second"
  (x :float)
  (y :float))

;; long long llrintf(float);
;; long long llroundf(float);

;; long	lrintf(float);
(cffi:defcfun "lrintf" :long
  "Rounds a floating-point number to an integer"
  (x :float))

;; long	lroundf(float);
(cffi:defcfun "lroundf" :long
  "Rounds a floating-point number to an integer"
  (x :float))

;; float	nanf(const char *) __pure2;
(cffi:defcfun "nanf" :float
  "Converts the implementation-defined character string arg into the corresponding quiet NaN value"
  (p (:pointer :char))) ; This needs testing

;; float	nearbyintf(float);
(cffi:defcfun "nearbyintf" :float
  "Rounds a floating-point number to an integer value"
  (x :float))

;; float	nextafterf(float, float);
(cffi:defcfun "nextafterf" :float
  "Returns the next value to the first argument x, removed from it in the direction toward the value of y"
  (x :float)
  (y :float))

;; float	remainderf(float, float);
(cffi:defcfun "remainderf" :float
  "Calculates the remainder of a floating-point division"
  (x :float)
  (y :float))

;; float	remquof(float, float, int *);
(cffi:defcfun "remquof" :float
  "Calculates the integer quotient and the remainder of a floating-point division"
  (x :float)
  (y :float)
  (i (:pointer :int)))

;; float	rintf(float);
(cffi:defcfun "rintf" :float
  "Rounds a floating-point number to an integer value"
  (x :float))

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

;; float	truncf(float);
(cffi:defcfun "truncf" :double
  "Rounds a floating-point number toward 0 to an integer value"
  (x :float))

;; float	fmaf(float, float, float);
(cffi:defcfun "fmaf" :float
  "Multiplies two numbers and adds a third number to their product"
  (x :float)
  (y :float)
  (z :float))

;; float	fdimf(float, float);
(cffi:defcfun "fdimf" :float
  "Returns (- x y) or 0, whichever is greater"
  (x :float)
  (y :float))

;; float	fmaxf(float, float) __pure2;
(cffi:defcfun "fmaxf" :float
  "Determines the greater of two float floating-point numbers"
  (x :float)
  (y :float))

;; float	fminf(float, float) __pure2;
(cffi:defcfun "fminf" :float
  "Determines the lesser of two float floating-point numbers"
  (x :float)
  (y :float))


;;
;; float versions of BSD math library entry points
;;

;; float	dremf(float, float);
(cffi:defcfun "dremf" :float
  "Calculates the remainder of a floating-point division. Obsolete synonym for remainderf"
  (x :float)
  (y :float))



;;; Special Functions

;; float	j0f(float);
(cffi:defcfun "j0f" :float
  "Returns the Bessel function of the first kind of order 0 of x."
  (x :float))

;; float	j1f(float);
(cffi:defcfun "j1f" :float
  "Returns the Bessel function of the first kind of order 1 of x."
  (x :float))

;; float	jnf(int, float);
(cffi:defcfun "jnf" :float
  "Returns the Bessel function of the first kind of order n of x."
  (n :int)
  (x :float))

;; float	y0f(float);
(cffi:defcfun "y0f" :float
  "Returns the Bessel function of the second kind of order 0 of x."
  (x :float))

;; float	y1f(float);
(cffi:defcfun "y1f" :float
  "Returns the Bessel function of the second kind of order 0 of x."
  (x :float))

;; float	ynf(int, float);
(cffi:defcfun "ynf" :float
  "Returns the Bessel function of the second kind of order n of x."
  (n :int)
  (x :float))



;; Reentrant version of lgamma; passes signgam back by reference as the
;; second argument; user must allocate space for signgam.
;; float	lgammaf_r(float, int *);
(cffi:defcfun "lgammaf_r" :float
  "Reentrant version of lgamma"
  (x :float)
  (i (:pointer :int)))

;; Single sine/cosine function.  User must allocate space for s and c
;; void	sincosf(float, float *, float *);
(cffi:defcfun "sincofs" :float
  "Calculate sin and cos simultaneously"
  (x :float)
  (s (:pointer :float))  ; pointer to sine
  (c (:pointer :float))) ; pointer to cosine




;;
;; long double versions of ISO/POSIX math functions
;; long double not available in current CL implementations
;;

;; long double	acoshl(long double);
;; long double	acosl(long double);
;; long double	asinhl(long double);
;; long double	asinl(long double);
;; long double	atan2l(long double, long double);
;; long double	atanhl(long double);
;; long double	atanl(long double);
;; long double	cbrtl(long double);
;; long double	ceill(long double);
;; long double	copysignl(long double, long double) __pure2;
;; long double	coshl(long double);
;; long double	cosl(long double);
;; long double	erfcl(long double);
;; long double	erfl(long double);
;; long double	exp2l(long double);
;; long double	expl(long double);
;; long double	expm1l(long double);
;; long double	fabsl(long double) __pure2;
;; long double	fdiml(long double, long double);
;; long double	floorl(long double);
;; long double	fmal(long double, long double, long double);
;; long double	fmaxl(long double, long double) __pure2;
;; long double	fminl(long double, long double) __pure2;
;; long double	fmodl(long double, long double);
;; long double	frexpl(long double value, int *); /* fundamentally !__pure2 */
;; long double	hypotl(long double, long double);
;; int		ilogbl(long double) __pure2;
;; long double	ldexpl(long double, int);
;; long double	lgammal(long double);
;; long long	llrintl(long double);
;; long long	llroundl(long double);
;; long double	log10l(long double);
;; long double	log1pl(long double);
;; long double	log2l(long double);
;; long double	logbl(long double);
;; long double	logl(long double);
;; long		lrintl(long double);
;; long		lroundl(long double);
;; long double	modfl(long double, long double *); /* fundamentally !__pure2 */
;; long double	nanl(const char *) __pure2;
;; long double	nearbyintl(long double);
;; long double	nextafterl(long double, long double);
;; double		nexttoward(double, long double);
;; float		nexttowardf(float, long double);
;; long double	nexttowardl(long double, long double);
;; long double	powl(long double, long double);
;; long double	remainderl(long double, long double);
;; long double	remquol(long double, long double, int *);
;; long double	rintl(long double);
;; long double	roundl(long double);
;; long double	scalblnl(long double, long);
;; long double	scalbnl(long double, int);
;; long double	sinhl(long double);
;; long double	sinl(long double);
;; long double	sqrtl(long double);
;; long double	tanhl(long double);
;; long double	tanl(long double);
;; long double	tgammal(long double);
;; long double	truncl(long double);


;; Reentrant version of lgammal.
;; long double	lgammal_r(long double, int *);

;;
;; long double sine/cosine function.
;;
;; void	sincosl(long double, long double *, long double *);
