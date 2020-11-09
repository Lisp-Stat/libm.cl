;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: LIBM -*-
;;; Copyright (c) 2020 by Symbolics Pte. Ltd. All rights reserved.
(in-package #:%libm)

;;;
;;; Mathmatical constants from SVID
;;;

(cl:defconstant E	2.7182818284590452354d0)
(cl:defconstant LOG2E	1.4426950408889634074d0) ; log 2e
(cl:defconstant LOG10E	0.43429448190325182765d0) ; log 10e
(cl:defconstant LN2	0.69314718055994530942d0) ; log e2
(cl:defconstant LN10	2.30258509299404568402d0) ; log e10
(cl:defconstant PI	3.14159265358979323846d0) ; pi
(cl:defconstant PI_2	1.57079632679489661923d0) ; pi/2
(cl:defconstant PI_4	0.78539816339744830962d0) ; pi/4
(cl:defconstant 1_PI	0.31830988618379067154d0) ; 1/pi
(cl:defconstant 2_PI	0.63661977236758134308d0) ; 2/pi
(cl:defconstant 2_SQRTPI	1.12837916709551257390d0) ; 2/sqrt(pi)
(cl:defconstant SQRT2	1.41421356237309504880d0) ; sqrt(2)
(cl:defconstant SQRT1_2	0.70710678118654752440d0) ; 1/sqrt(2)
