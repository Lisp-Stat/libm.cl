;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: %LIBM -*-
;;; Copyright (c) 2020 by Symbolics Pte. Ltd. All rights reserved.
(cl:in-package #:%libm-complex)

;;; Complex numbers require libffi. This is easily available on
;;; FreeBSD or Mac, but less so on MS Windows. That's why this is a
;;; separate system and package, so that it can be loaded
;;; independently. See below for the Python guys view on libffi:
;;;     https://cffi.readthedocs.io/en/latest/installation.html#platform-specific-instructions

;;; Double complex definitions
(cffi:defcstruct (complex-double-c :class complex-double-type)
      (dat :double :count 2))

(cl:defmethod cffi:translate-into-foreign-memory ((value cl:complex) (type complex-double-type) p)
  (cffi:with-foreign-slots ((dat) p (:struct complex-double-c))
    (cl:setf (cffi:mem-aref dat :double 0) (cl:realpart value)
	     (cffi:mem-aref dat :double 1) (cl:imagpart value))))

(cl:defmethod cffi:translate-from-foreign (p (type complex-double-type))
  (cffi:with-foreign-slots ((dat) p (:struct complex-double-c))
    (cl:complex (cffi:mem-aref dat :double 0)
		(cffi:mem-aref dat :double 1))))


;;; Float complex definitions
(cffi:defcstruct (complex-float-c :class complex-float-type)
      (dat :float :count 2))

(cl:defmethod cffi:translate-into-foreign-memory ((value cl:complex) (type complex-float-type) p)
  (cffi:with-foreign-slots ((dat) p (:struct complex-float-c))
    (cl:setf (cffi:mem-aref dat :float 0) (cl:realpart value)
	     (cffi:mem-aref dat :float 1) (cl:imagpart value))))

(cl:defmethod cffi:translate-from-foreign (p (type complex-float-type))
  (cffi:with-foreign-slots ((dat) p (:struct complex-float-c))
    (cl:complex (cffi:mem-aref dat :float 0)
		(cffi:mem-aref dat :float 1))))

;;;
;;; Double versions of C99 functions
;;;

;; double complex cacos(double complex);
(cffi:defcfun "cacos" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex casin(double complex);
(cffi:defcfun "casin" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex catan(double complex);
(cffi:defcfun "catan" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex ccos(double complex);
(cffi:defcfun "ccos" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex csin(double complex);
(cffi:defcfun "csin" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex ctan(double complex);
(cffi:defcfun "ctan" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex cacosh(double complex);
(cffi:defcfun "cacosh" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex casinh(double complex);
(cffi:defcfun "casinh" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex catanh(double complex);
(cffi:defcfun "catanh" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex ccosh(double complex);
(cffi:defcfun "ccosh" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex csinh(double complex);
(cffi:defcfun "csinh" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex ctanh(double complex);
(cffi:defcfun "ctanh" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex cexp(double complex);
(cffi:defcfun "cexp" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex clog(double complex);
(cffi:defcfun "clog" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double cabs(double complex);
(cffi:defcfun "cabs" :double (c (:struct complex-double-c)))

;; double complex cpow(double complex, double complex);
(cffi:defcfun "cpow" (:struct complex-double-c)
  (c1 (:struct complex-double-c))
  (c2 (:struct complex-double-c)))

;; double complex csqrt(double complex);
(cffi:defcfun "csqrt" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double carg(double complex);
(cffi:defcfun "carg" :double (c (:struct complex-double-c)))

;; double cimag(double complex);
(cffi:defcfun "cimag" :double (c (:struct complex-double-c)))

;; double complex conj(double complex);
(cffi:defcfun "conj" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double complex cproj(double complex);
(cffi:defcfun "cproj" (:struct complex-double-c) (c (:struct complex-double-c)))

;; double creal(double complex);
(cffi:defcfun "creal" :double (c (:struct complex-double-c)))



;;;
;;; Float versions of C99 functions
;;;

;; float complex cacosf(float complex);
(cffi:defcfun "cacosf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex casinf(float complex);
(cffi:defcfun "casinf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex catanf(float complex);
(cffi:defcfun "catanf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex ccosf(float complex);
(cffi:defcfun "ccosf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex csinf(float complex);
(cffi:defcfun "csinf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex ctanf(float complex);
(cffi:defcfun "ctanf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex cacoshf(float complex);
(cffi:defcfun "cacoshf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex casinhf(float complex);
(cffi:defcfun "casinhf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex catanhf(float complex);
(cffi:defcfun "catanhf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex ccoshf(float complex);
(cffi:defcfun "ccoshf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex csinhf(float complex);
(cffi:defcfun "csinhf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex ctanhf(float complex);
(cffi:defcfun "ctanhf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex cexpf(float complex);
(cffi:defcfun "cexpf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex clogf(float complex);
(cffi:defcfun "clogf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float cabsf(float complex);
(cffi:defcfun "cabsf" :float (c (:struct complex-float-c)))

;; float complex cpowf(float complex, float complex);
(cffi:defcfun "cpowf" (:struct complex-float-c)
  (c1 (:struct complex-float-c))
  (c2 (:struct complex-float-c)))

;; float complex csqrtf(float complex);
(cffi:defcfun "csqrtf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float cargf(float complex);
(cffi:defcfun "cargf" :float (c (:struct complex-float-c)))

;; float cimagf(float complex);
(cffi:defcfun "cimagf" :float (c (:struct complex-float-c)))

;; float complex conjf(float complex);
(cffi:defcfun "conjf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float complex cprojf(float complex);
(cffi:defcfun "cprojf" (:struct complex-float-c) (c (:struct complex-float-c)))

;; float crealf(float complex);
(cffi:defcfun "crealf" :float (c (:struct complex-float-c)))
