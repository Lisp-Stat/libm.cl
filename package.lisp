;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2019 Symbolics Pte. Ltd. All rights reserved.

(uiop:define-package #:%libm-complex
    (:use)
  (:export #:cacos			; Complex double versions
	   #:casin
	   #:catan
	   #:ccos
	   #:csin
	   #:ctan
	   #:cacosh
	   #:casinh
	   #:catanh
	   #:ccosh
	   #:csinh
	   #:ctanh
	   #:cexp
	   #:clog
	   #:cabs
	   #:cpow
	   #:csqrt
	   #:carg
	   #:cimag
	   #:conj
	   #:cproj
	   #:creal)

  (:export #:cacosf 			; Float versions of C99 functions
	   #:casinf
	   #:catanf
	   #:ccosf
	   #:csinf
	   #:ctanf
	   #:cacoshf
	   #:casinhf
	   #:catanhf
	   #:ccoshf
	   #:csinhf
	   #:ctanhf
	   #:cexpf
	   #:clogf
	   #:cabsf
	   #:cpowf
	   #:csqrtf
	   #:cargf
	   #:cimagf
	   #:conjf
	   #:cprojf
	   #:crealf))

(uiop:define-package #:%libm		; direct bindings
    (:use)
    (:mix-reexport :%libm-complex)

  ;;; C90 functions, double versions
  (:export #:acos
	   #:asin
	   #:atan
	   #:atan2
	   #:cos
	   #:sin
	   #:tan

	   #:cosh
	   #:sinh
	   #:tanh

	   #:exp
	   #:frexp
	   #:ldexp
	   #:log
	   #:log10
	   #:modf

	   #:pow
	   #:sqrt

	   #:ceil
	   #:fabs
	   #:floor
	   #:fmod)


  ;;; C99 functions, double versions
  (:export #:acosh
	   #:asinh
	   #:atanh
	   #:cbrt
	   #:erf
	   #:erfc
	   #:exp2
	   #:expm1
	   #:fma
	   #:hypot
	   #:logb
	   #:isinf
	   #:isnan
	   #:lgamma
	   #:log1p
	   #:log2
	   #:logb
	   #:lrint
	   #:lround
	   #:nan
	   #:nextafter
	   #:remainder
	   #:remquo
	   #:rint

	   ;; BSD or XSI
	   #:j0
	   #:j1
	   #:jn
	   #:y0
	   #:y1
	   #:yn

	   ;; BSD or C99
	   #:copysign
	   #:fdim
	   #:fmax
	   #:fmin
	   #:nearbyint
	   #:round
	   #:scalbln
	   #:scalbn
	   #:tgamma
	   #:trunc

	   ;; BSD only
	   #:isnanf
	   #:lgamma-r
	   #:sincos)

  (:export ; single-float versions

	   #:acosf
	   #:asinf
	   #:atanf
	   #:atan2f
	   #:cosf
	   #:sinf
	   #:tanf

	   #:coshf
	   #:sinhf
	   #:tanhf

	   #:exp2f
	   #:expf
	   #:expm1f
	   #:frexpf
	   #:ilogbf
	   #:ldexpf
	   #:log10f
	   #:log1pf
	   #:log2f
	   #:logf
	   #:modff

	   #:powf
	   #:sqrtf

	   #:ceilf
	   #:fabsf
	   #:floorf
	   #:fmodf
	   #:roundf

	   #:erff
	   #:erfcf
	   #:hypotf
	   #:lgammaf
	   #:tgammaf

	   #:acoshf
	   #:asinhf
	   #:atanhf
	   #:cbrtf
	   #:logbf
	   #:copysignf
	   #:lrintf
	   #:lroundf
	   #:nanf
	   #:nearbyintf
	   #:nextafterf
	   #:remainderf
	   #:remquof
	   #:rintf
	   #:scalblnf
	   #:scalbnf
	   #:truncf

	   #:fdimf
	   #:fmaf
	   #:fmaxf
	   #:fminf

	   ;;
	   ;; float versions of BSD math library entry points
	   ;;
	   #:dremf
	   #:j0f
	   #:j1f
	   #:jnf
	   #:y0f
	   #:y1f
	   #:ynf


	   ;; Float versions of reentrant version of lgamma; passes signgam back by
	   ;; reference as the second argument; user must allocate space for signgam.
	   #:lgammaf-r

	   ;; Single sine/cosine function.
	   #:sincosf))


(uiop:define-package #:libm
    (:use)

  ;;; C90 functions
  (:export #:acos
	   #:asin
	   #:atan
	   #:atan2

	   #:cos
	   #:sin
	   #:tan

	   #:cosh
	   #:sinh
	   #:tanh

	   #:exp
	   #:exp2
	   #:log
	   #:log10
	   #:ldexp
	   #:pow
	   #:sqrt
	   #:ceil
	   #:abs
	   #:floor
	   #:fmod
	   #:round)

  ;;; C99 functions
  (:export #:acosh
	   #:asinh
	   #:atanh
	   #:cbrt
	   #:erf
	   #:erfc
	   #:expm1
	   #:fma
	   #:log1p
	   #:log2
	   #:logb
	   #:lgamma
	   #:remainder
	   #:j0
	   #:j1
	   #:jn
	   #:y0
	   #:y1
	   #:yn
	   #:copysign
	   #:nearbyint
	   #:round
	   #:tgamma
	   #:trunc))

