;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2020 Symbolics Pte. Ltd. All rights reserved.

(uiop:define-package :libm-tests
  (:use #:cl #:libm #:fiveam #:num-utils.num= #:random-state)
  (:shadow #:abs
	   #:acos
	   #:asin
	   #:atan
	   #:cos
	   #:sin
	   #:tan
	   #:acosh
	   #:asinh
	   #:atanh
	   #:cosh
	   #:sinh
	   #:tanh
	   #:exp
	   #:log
	   #:sqrt
	   #:round
	   #:floor))

