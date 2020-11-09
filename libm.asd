;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: CL-USER -*-
;;; Copyright (c) 2020 by Symbolics Pte. Ltd. All rights reserved.

(asdf:defsystem #:libm
  :description "Wrapper for the openlibm library"
  :version      (:read-file-form "version.sexp")
  :author "Steven Nunez <steve@symbolics.tech>"
  :license "MS-PL"
  :depends-on (#:cffi #:cffi-libffi)
  :serial t
  :components ((:file #:package)
	       (:file #:init)
	       (:file #:%constants)
	       (:file #:%complex)
               (:file #:%libm)		; C level bindings
	       (:file #:libm))		; User bindings
  :in-order-to ((test-op (test-op libm/tests))))

(asdf:defsystem #:libm/tests
  :description "Tests for basic math functions, openlibm as the reference"
  :version      (:read-file-form "version.sexp")
  :author "Steven Nunez <steve@symbolics.tech>"
  :license "Boost"
  :depends-on (#:libm
	       #:num-utils
	       #:random-state
	       #:fiveam)
  :serial t
  :components ((:file #:tpkgdcl)
	       (:file #:tests))
  :perform (asdf:test-op (o s)
			 (uiop:symbol-call :fiveam :run-all-tests)))


