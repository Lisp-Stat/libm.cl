;;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: %LIBM -*-
;;;; Copyright (c) 2019, 2020 by Symbolics Pte. Ltd. All rights reserved.
(in-package #:%libm)

;;; Note: The %libm package imports no CL symbols to avoid conflicts
;;; with the math function names, so we have to qualify all symbols
;;; here.

(cffi:define-foreign-library libm
  (:windows (:or "libopenlibm"
             #.(cl:merge-pathnames "libopenlibm.dll" cl:*compile-file-pathname*)))
  (t (:default "libopenlibm")))
(cffi:load-foreign-library 'libm)

