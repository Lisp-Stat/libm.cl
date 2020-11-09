;;; -*- Mode: LISP; Base: 10; Syntax: ANSI-Common-Lisp; Package: LIBM-TESTS -*-
;;; Copyright (c) 2020 by Symbolics Pte. Ltd. All rights reserved.
(in-package #:libm-tests)

(def-suite libm
    :description "Master suite of all LIBM tests")
(in-suite libm)

;;; Some tests require a lower tolerance for single-floats because the
;;; results differ by one digit in the last decimal. I suspect this is
;;; LIBM rounding. We set the *num=-tolerance* value individually to
;;; 1d-5 for these tests.
(setf *num=-tolerance* 1d-15); "Default tolerance for NUM=."

(defparameter *0-to-1-rand-doubles*   (loop with generator = (random-state:make-generator :mersenne-twister-32 123)
					    repeat 10
					    collect (random-state:random-float generator -1.0 1.0)))
(defparameter *0-to-1-positive-rand-doubles*   (loop with generator = (random-state:make-generator :mersenne-twister-32 123)
					    repeat 10
					    collect (random-state:random-float generator 0 1.0)))
(defparameter *0-to-1-rand-doubles-y* (loop with generator = (random-state:make-generator :mersenne-twister-32 321)
					    repeat 10
					    collect (random-state:random-float generator -1.0 1.0)))
(defparameter *0-to-1-rand-double-complex* (loop for x in *0-to-1-rand-doubles*
						 for y in *0-to-1-rand-doubles-y*
						 collect (complex x y)))

(defparameter *0-to-1-rand-singles*   (loop with generator = (random-state:make-generator :mersenne-twister-32 123)
					   repeat 10
					   collect (coerce (random-state:random-float generator -1.0 1.0) 'single-float)))
(defparameter *0-to-1-positive-rand-singles*   (loop with generator = (random-state:make-generator :mersenne-twister-32 123)
					   repeat 10
					   collect (coerce (random-state:random-float generator 0 1.0) 'single-float)))
(defparameter *0-to-1-rand-singles-y* (loop with generator = (random-state:make-generator :mersenne-twister-32 321)
					   repeat 10
					   collect (coerce (random-state:random-float generator -1.0 1.0) 'single-float)))
(defparameter *0-to-1-rand-single-complex* (loop for x in *0-to-1-rand-singles*
						 for y in *0-to-1-rand-singles-y*
						 collect (complex x y)))


;;; These functions are only defined between -1 < x < 1
(test acos
  (loop for x in *0-to-1-rand-doubles*
	:do (is (num= (libm:acos x) (cl:acos x)) "Failed acos for doubles when x = ~A" x))
  (loop for x in *0-to-1-rand-singles*
	:do (is (num= (libm:acos x) (cl:acos x)) "Failed acos for floats when x = ~A" x))
  (loop for x in *0-to-1-rand-double-complex*
  	:do (is (num= (libm:acos x) (cl:acos x))
  		"Failed acos for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:acos x) (cl:acos x)))
  (let ((*num=-tolerance* 1d-7)) ; CL returns one more digit than libm
    (loop for x in *0-to-1-rand-single-complex*
  	  :do (is (num= (libm:acos x) (cl:acos x))
  		  "Failed acos for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:acos x) (cl:acos x))))
  )

(test asin
  (loop for x in *0-to-1-rand-doubles*
	:do (is (num= (libm:asin x) (cl:asin x))
		"Failed asin for doubles when x = ~A. libm returned ~A, CL returned ~A" x (libm:asin x) (cl:asin x)))
  (let ((*num=-tolerance* 1d-6)) ; CL returns one more digit than libm
    (loop for x in *0-to-1-rand-singles*
	  :do (is (num= (libm:asin x) (cl:asin x))
		  "Failed asin for floats when x = ~A. libm returned ~A, CL returned ~A" x (libm:asin x) (cl:asin x))))
  (loop for x in *0-to-1-rand-double-complex*
	:do (is (num= (libm:asin x) (cl:asin x))
		"Failed asin for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:asin x) (cl:asin x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *0-to-1-rand-single-complex*
	  :do (is (num= (libm:asin x) (cl:asin x))
		  "Failed asin for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:asin x) (cl:asin x)))))

(test atan
  (loop for x in *0-to-1-rand-doubles*
	:do (is (num= (libm:atan x) (cl:atan x))
		"Failed atan for doubles when x = ~A. libm returned ~A, CL returned ~A" x (libm:atan x) (cl:atan x)))
  (loop for x in *0-to-1-rand-singles*
  	:do (is (num= (libm:atan x) (cl:atan x)) "Failed atan for floats"))
  (loop for x in *0-to-1-rand-doubles*
  	:do (loop for y in *0-to-1-rand-doubles-y*
      		  :do (is (num= (libm:atan x y) (cl:atan x y)) "Failed atan2 for doubles")))
  (loop for x in *0-to-1-rand-singles*
  	:do (loop for y in *0-to-1-rand-singles-y*
  		  :do (is (num= (libm:atan x y) (cl:atan x y)) "Failed atan2 for floats")))
  (loop for x in *0-to-1-rand-double-complex*
  	:do (is (num= (libm:atan x) (cl:atan x))
  		"Failed atan for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:acos x) (cl:acos x)))
  (let ((*num=-tolerance* 1d-7)) ; CL returns one more digit than libm
    (loop for x in *0-to-1-rand-single-complex*
  	  :do (is (num= (libm:atan x) (cl:atan x))
  		  "Failed atan for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:acos x) (cl:acos x)))))


;;; Most of these functions are defined across a large range, but the
;;; libm versions are prone to overflow, so we limit the test range of
;;; floats to 0-50. Even here the accuracy at large numbers differs,
;;; especially in single-float.
(defparameter *rand-doubles*   (loop with generator = (random-state:make-generator :mersenne-twister-32 1234)
				     repeat 10
				     collect (random-state:random-float generator -50.0 50.0)))
(defparameter *positive-rand-doubles* (loop with generator = (random-state:make-generator :mersenne-twister-32 4321)
					    repeat 10
					    collect (random-state:random-float generator 0.0 50.0)))
(defparameter *rand-doubles-y* (loop with generator = (random-state:make-generator :mersenne-twister-32 2341)
				     repeat 10
				     collect (random-state:random-float generator -50.0 50.0)))
(defparameter *positive-rand-doubles-y* (loop with generator = (random-state:make-generator :mersenne-twister-32 3412)
					      repeat 10
					      collect (random-state:random-float generator 0.0 50.0)))
(defparameter *rand-double-complex* (loop for x in *rand-doubles*
					  for y in *rand-doubles-y*
					  collect (complex x y)))
(defparameter *positive-rand-double-complex* (loop for x in *positive-rand-doubles*
						   for y in *positive-rand-doubles-y*
						   collect (complex x y)))

;;; single-float random numbers
(defparameter *rand-singles*   (loop with generator = (random-state:make-generator :mersenne-twister-32 1234)
					   repeat 10
					   collect (coerce (random-state:random-float generator -50.0 50.0) 'single-float)))
(defparameter *positive-rand-singles* (loop with generator = (random-state:make-generator :mersenne-twister-32 3412)
					    repeat 10
					    collect (coerce (random-state:random-float generator 0.0 50.0) 'single-float)))
(defparameter *rand-singles-y* (loop with generator = (random-state:make-generator :mersenne-twister-32 2341)
					   repeat 10
					   collect (coerce (random-state:random-float generator -50.0 50.0) 'single-float)))
(defparameter *positive-rand-singles-y* (loop with generator = (random-state:make-generator :mersenne-twister-32 4321)
					    repeat 10
					    collect (coerce (random-state:random-float generator 0.0 50.0) 'single-float)))
(defparameter *rand-single-complex* (loop for x in *rand-singles*
						 for y in *rand-singles-y*
						 collect (complex x y)))
(defparameter *positive-rand-single-complex* (loop for x in *positive-rand-singles*
						   for y in *positive-rand-singles-y*
						   collect (complex x y)))

;;; C90 functions

(test cos
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:cos x) (cl:cos x)) "Failed cos for doubles"))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:cos x) (cl:cos x)) "Failed cos for floats"))
  (loop for x in *0-to-1-rand-double-complex* :do
    (is (num= (libm:cos x) (cl:cos x))
	"Failed cos for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:cos x) (cl:cos x)))
  (let ((*num=-tolerance* 1d-6))
    (loop for x in *0-to-1-rand-single-complex* :do
      (is (num= (libm:cos x) (cl:cos x))
	  "Failed cos for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:cos x) (cl:cos x)))))

(test sin
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:sin x) (cl:sin x)) "Failed sin for doubles"))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:sin x) (cl:sin x)) "Failed sin for floats"))
  (loop for x in *0-to-1-rand-double-complex* :do
    (is (num= (libm:sin x) (cl:sin x))
	"Failed sin for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:sin x) (cl:sin x)))
  (let ((*num=-tolerance* 1d-6))
    (loop for x in *0-to-1-rand-single-complex* :do
      (is (num= (libm:sin x) (cl:sin x))
	  "Failed sin for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:sin x) (cl:sin x)))))

(test tan
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:tan x) (cl:tan x)) "Failed tan for doubles"))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:tan x) (cl:tan x)) "Failed tan for floats"))
  (loop for x in *0-to-1-rand-double-complex* :do
    (is (num= (libm:tan x) (cl:tan x))
	"Failed tan for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:tan x) (cl:tan x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *0-to-1-rand-single-complex* :do
      (is (num= (libm:tan x) (cl:tan x))
	  "Failed tan for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:tan x) (cl:tan x)))))

(test cosh
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:cosh x) (cl:cosh x)) "Failed cosh for doubles"))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:cosh x) (cl:cosh x)) "Failed cosh for floats"))
  (loop for x in *0-to-1-rand-double-complex* :do
    (is (num= (libm:cosh x) (cl:cosh x))
	"Failed cosh for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:cosh x) (cl:cosh x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *0-to-1-rand-single-complex* :do
      (is (num= (libm:cosh x) (cl:cosh x))
	  "Failed cosh for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:cosh x) (cl:cosh x)))))

(test sinh
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:sinh x) (cl:sinh x)) "Failed sinh for doubles"))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:sinh x) (cl:sinh x)) "Failed sinh for floats"))
  (loop for x in *0-to-1-rand-double-complex* :do
    (is (num= (libm:sinh x) (cl:sinh x))
	"Failed sinh for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:sinh x) (cl:sinh x)))
  (let ((*num=-tolerance* 1d-6))
    (loop for x in *0-to-1-rand-single-complex* :do
      (is (num= (libm:sinh x) (cl:sinh x))
	  "Failed sinh for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:sinh x) (cl:sinh x)))))

(test tanh
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:tanh x) (cl:tanh x)) "Failed tanh for doubles"))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:tanh x) (cl:tanh x)) "Failed tanh for floats"))
  (loop for x in *0-to-1-rand-double-complex* :do
    (is (num= (libm:tanh x) (cl:tanh x))
	"Failed tanh for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:tanh x) (cl:tanh x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *0-to-1-rand-single-complex* :do
      (is (num= (libm:tanh x) (cl:tanh x))
	  "Failed tanh for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:tanh x) (cl:tanh x)))))

(test exp
  "EXP returns _e_ raised to the power _number_, where _e_ is the base of the natural logarithms"
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:exp x) (cl:exp x)) "Failed exp for doubles"))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:exp x) (cl:exp x)) "Failed exp for floats"))
  (loop for x in *rand-double-complex* :do
    (is (num= (libm:exp x) (cl:exp x))
	"Failed exp for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:exp x) (cl:exp x)))
  (let ((*num=-tolerance* 1d-6))
    (loop for x in *rand-single-complex* :do
      (is (num= (libm:exp x) (cl:exp x))
	  "Failed exp for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:exp x) (cl:exp x)))))

(test exp2
  "EXP2 returns 2 raised to the power _number_"
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:exp2 x) (cl:expt 2 x))
	"Failed expt2 for doubles, LIBM value ~F is not equal to CL value ~F" (libm:exp2 x)(cl:expt 2 x)))
  (let ((*num=-tolerance* 1d-5)) ; LIBM seems to round here
    (loop for x in *rand-singles* :do
      (is (num= (libm:exp2 x) (cl:expt 2 x))
	  "Failed expt2 for floats, LIBM value ~F is not equal to CL value ~F" (libm:exp2 x)(cl:expt 2 x)))))


;;; LOG test fails in libm when using negative values, however calling the functions
;;; directly works, e.g.
;;; (mapc #'libm:log LIBM-TESTS::*RAND-DOUBLES*)
;;; (mapc #'libm:log LIBM-TESTS::*RAND-FLOATS*)
;;; (mapc #'libm:log LIBM-TESTS::*0-to-1-RAND-DOUBLE-COMPLEX*)
;;; (mapc #'libm:log LIBM-TESTS::*0-to-1-RAND-SINGLE-COMPLEX*)
;;; (mapc #'libm:log LIBM-TESTS::*RAND-DOUBLE-COMPLEX)*
;;; (mapc #'libm:log LIBM-TESTS::*RAND-SINGLE-COMPLEX*)
;;; All work. Perhaps something with FIVEAM ?

(test log
  "LOG returns the natural logarithm of x"
  (loop for x in *positive-rand-doubles* :do
    (is (num= (libm:log x) (cl:log x))
	"Failed log for doubles when x = ~A. libm returned ~A, CL returned ~A" x (libm:log x) (cl:log x)))
  (loop for x in *positive-rand-singles* :do
    (is (num= (libm:log x) (cl:log x)) "Failed log for floats"))
  (loop for x in *positive-rand-double-complex*	:do
    (is (num= (libm:log x) (cl:log x))
	"Failed log for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:log x) (cl:log x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *positive-rand-single-complex* :do
      (is (num= (libm:log x) (cl:log x))
	  "Failed log for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:log x) (cl:log x)))))

(test log10 ; log10 also has problems in the test suite
  (loop for x in *positive-rand-doubles* :do
    (is (num= (libm:log10 x) (cl:log x 10))
	"Failed log10 for doubles when x = ~A. libm returned ~A, CL returned ~A" x (libm:log10 x) (cl:log x 10)))
  (loop for x in *positive-rand-singles* :do
    (is (num= (libm:log10 x) (cl:log x 10))
	"Failed log10 for singles when x = ~A. libm returned ~A, CL returned ~A" x (libm:log10 x) (cl:log x 10))))


;; POW isn't as useful as CL:EXPT. Compare the documentation of the
;; two for details.
(test pow
  "Returns _base_ raised to the power _exponent_. The same as CL:EXPT"
  (loop for x in *positive-rand-doubles* :do
    (loop for y in *positive-rand-doubles-y* :do
      (is (num= (libm:pow x y) (cl:expt x y))
	  "Failed pow for doubles when x = ~A, Y= ~A. libm returned ~A, CL returned ~A" x y (libm:pow x y) (cl:expt x y))))
  (loop for x in *positive-rand-singles* :do
    (loop for y in *positive-rand-singles-y* :do
      (is (num= (libm:exp x) (cl:exp x))
	  "Failed pow for singles when x = ~A, Y= ~A. libm returned ~A, CL returned ~A" x y (libm:pow x y) (cl:expt x y))))
  (loop for x in *positive-rand-double-complex*	:do
    (is (num= (libm:exp x) (cl:exp x))
	"Failed exp for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:exp x) (cl:exp x)))
  (let ((*num=-tolerance* 1d-6))
    (loop for x in *positive-rand-single-complex* :do
      (is (num= (libm:exp x) (cl:exp x))
	  "Failed exp for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:exp x) (cl:exp x)))))

;; libm doesn't handle negative square roots for non-complex numbers; use positive values
(test sqrt
  "Returns the square root of x"
  (loop for x in *positive-rand-doubles* :do
    (is (num= (libm:sqrt x) (cl:sqrt x))
	"Failed sqrt for doubles when x = ~A. libm returned ~A, CL returned ~A" x (libm:sqrt x) (cl:sqrt x)))
  (loop for x in *positive-rand-singles* :do
    (is (num= (libm:sqrt x) (cl:sqrt x))
	"Failed sqrt for singles when x = ~A. libm returned ~A, CL returned ~A" x (libm:sqrt x) (cl:sqrt x)))
  (loop for x in *rand-double-complex* :do
    (is (num= (libm:sqrt x) (cl:sqrt x))
	"Failed sqrt for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:sqrt x) (cl:sqrt x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *rand-single-complex* :do
      (is (num= (libm:sqrt x) (cl:sqrt x))
	  "Failed sqrt for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:sqrt x) (cl:sqrt x)))))

(test abs
  "ABS computes absolute value of a number"
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:abs x) (cl:abs x))
	"Failed sqrt for doubles when x = ~A. libm returned ~A, CL returned ~A" x (libm:abs x) (cl:abs x)))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:abs x) (cl:abs x))
	"Failed sqrt for singles when x = ~A. libm returned ~A, CL returned ~A" x (libm:abs x) (cl:abs x)))
  (loop for x in *rand-double-complex* :do
    (is (num= (libm:abs x) (cl:abs x))
	"Failed sqrt for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:abs x) (cl:abs x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *rand-single-complex* :do
      (is (num= (libm:abs x) (cl:abs x))
	  "Failed sqrt for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:abs x) (cl:abs x)))))

(test floor
  (loop for x in *rand-doubles* :do
    (is (num= (libm:floor x) (cl:floor x))
	"Failed floor for doubles when x = ~A. libm returned ~A, CL returned ~A" x (libm:floor x) (cl:floor x)))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:floor x) (cl:floor x))
	"Failed floor for singles when x = ~A. libm returned ~A, CL returned ~A" x (libm:floor x) (cl:floor x))))

;;; C99 functions

#| These tests are in the SPECIALFUNCTIONS library where they are implemented in lisp
(test erf
      (loop for x in *rand-doubles*
	 :do (is (num= (libm:erf x) (cl:erf x)) "Failed erf for doubles"))
      (loop for x in *rand-singles*
	 :do (is (num= (libm:erf x) (cl:erf x)) "Failed erf for floats")))

(test erfc
      (loop for x in *rand-doubles*
	 :do (is (num= (libm:erfc x) (cl:erfc x)) "Failed erfc for doubles"))
      (loop for x in *rand-singles*
	 :do (is (num= (libm:erfc x) (cl:erfc x)) "Failed erfc for floats")))|#

;; There's something in libm acosh that fails with FLOATING-POINT-INVALID-OPERATION
#+nil
(test acosh
  (loop for x in *0-to-1-positive-rand-doubles*	:do
    (is (num= (libm:acosh x) (cl:acosh x)) "Failed acosh for doubles"))
  (loop for x in *0-to-1-positive-rand-singles*	:do
    (is (num= (libm:acosh x) (cl:acosh x)) "Failed acosh for floats"))
  (loop for x in *0-to-1-rand-double-complex* :do
    (is (num= (libm:acosh x) (cl:acosh x))
	"Failed acosh for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:acosh x) (cl:acosh x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *0-to-1-rand-single-complex* :do
      (is (num= (libm:acosh x) (cl:acosh x))
	  "Failed acosh for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:acosh x) (cl:acosh x)))))

(test asinh
  (loop for x in *rand-doubles*	:do
    (is (num= (libm:asinh x) (cl:asinh x)) "Failed asinh for doubles"))
  (loop for x in *rand-singles*	:do
    (is (num= (libm:asinh x) (cl:asinh x)) "Failed asinh for floats"))
  (loop for x in *rand-double-complex* :do
    (is (num= (libm:asinh x) (cl:asinh x))
	"Failed asinh for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:asinh x) (cl:asinh x)))
  (let ((*num=-tolerance* 1d-6))
    (loop for x in *rand-single-complex* :do
      (is (num= (libm:asinh x) (cl:asinh x))
	  "Failed asinh for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:asinh x) (cl:asinh x)))))

(test atanh
  (loop for x in *0-to-1-positive-rand-doubles*	:do
    (is (num= (libm:atanh x) (cl:atanh x)) "Failed atanh for doubles"))
  (loop for x in *0-to-1-positive-rand-singles*	:do
    (is (num= (libm:atanh x) (cl:atanh x)) "Failed atanh for floats"))
  (loop for x in *0-to-1-rand-double-complex* :do
    (is (num= (libm:atanh x) (cl:atanh x))
	"Failed atanh for complex double when x = ~A. libm returned ~A, CL returned ~A" x (libm:atanh x) (cl:atanh x)))
  (let ((*num=-tolerance* 1d-7))
    (loop for x in *0-to-1-rand-single-complex* :do
      (is (num= (libm:atanh x) (cl:atanh x))
	  "Failed atanh for complex float when x = ~A. libm returned ~A, CL returned ~A" x (libm:atanh x) (cl:atanh x)))))

(test cbrt
  (loop for x in *positive-rand-doubles* :do
    (is (num= (libm:cbrt x) (cl:expt x 1/3))
	"Failed cbrt for doubles, LIBM value ~F is not equal to CL value ~F" (libm:cbrt x)(cl:expt x 1/3)))
  (let ((*num=-tolerance* 1d-5)) ; LIBM seems to round here
    (loop for x in *positive-rand-singles* :do
      (is (num= (libm:cbrt x) (cl:expt x 1/3))
	  "Failed cbrt for floats, LIBM value ~F is not equal to CL value ~F" (libm:cbrt x)(cl:expt x 1/3)))))

(test expm1
  "Returns e raised to the power x minus one. For small values of x, expm1 may be more accurate than exp(x)-1"
  (loop for x in *0-to-1-rand-doubles* :do
    (is (num= (libm:expm1 x) (cl:1- (cl:exp x)))
	"Failed expm1 for doubles, LIBM value ~F is not equal to CL value ~F" (libm:expm1 x)(cl:1- (cl:exp x))))
  (let ((*num=-tolerance* 1d-7)) ; LIBM seems to round here
    (loop for x in *0-to-1-rand-singles* :do
      (is (num= (libm:expm1 x) (cl:1- (cl:exp x )))
	  "Failed expm1 for floats, LIBM value ~F is not equal to CL value ~F" (libm:expm1 x)(cl:1- (cl:exp x))))))

(test fma
  "Returns x*y+z without losing precision in any intermediate result."
  (let ((*num=-tolerance* 1d-14))
    (loop for x in *rand-doubles* :do
      (loop for y in *rand-doubles-y* :do
	(loop for z in *positive-rand-doubles* :do
	  (is (num= (libm:fma x y z) (cl:+ (cl:* x y) z))
	      "FMA failed for doubles when x = ~A, Y= ~A, Z= ~A. libm returned ~A, CL returned ~A" x y z (libm:fma x y z) (cl:+ (cl:* x y) z))))))
  (let ((*num=-tolerance* 1d-4))
    (loop for x in *rand-singles* :do
      (loop for y in *rand-singles-y* :do
	(loop for z in *positive-rand-singles* :do
	  (is (num= (libm:fma x y z) (cl:+ (cl:* x y) z))
	      "FMA failed for singles when x = ~A, Y= ~A, Z= ~A. libm returned ~A, CL returned ~A" x y z (libm:fma x y z) (cl:+ (cl:* x y) z)))))))

;;; NOTE: CL has no hypot implementation. If it did, it would go here

;;; NOTE: The following deal with the hardware representation of
;;; floating point and do not have a lisp equivalents, so no tests:
;;; ilogb, isinf, isnan

;;; NOTE: lgamma not tested

;;; Utility functions for logs.
;;; We should probably move these into lisp-stat as convenience or
;;; utility functions
(defun ln (n)
  "Natural logarithm."
  (cl:log n (cl:exp 1d0)))

(defun lnf (n)
  "Natural logarithm, no double contagion."
  (cl:log n (cl:exp 1.0)))

(defun log1+ (x)
  "Compute (log (+ 1 x)) stably even when X is near zero."
  (cl:let ((u (+ 1 x)))
    (cl:if (cl:= u 1)
        x
        (/ (cl:* x (ln u))
           (cl:- u 1)))))

(defun log1f+ (x)
  "Compute (log (+ 1 x)) stably even when X is near zero, single floats"
  (cl:let ((u (+ 1 x)))
    (cl:if (cl:= u 1)
        x
        (/ (cl:* x (lnf u))
           (cl:- u 1)))))

(defun lb (n)
  "Binary logarithm."
  (cl:log n 2.0d0))

(defun lbf (n)
  "Binary logarithm, single float"
  (cl:log n 2.0))

(defun lg (n)
  "Decimal logarithm."
  (cl:log n 10.0d0))

(defun lgf (n)
  "Decimal logarithm, single float"
  (cl:log n 10.0))

(test log1p
  (loop for x in *0-to-1-rand-doubles* :do
    (is (num= (libm:log1p x) (log1+ x))
	"LOG1P failed for doubles, LIBM value ~F is not equal to CL value ~F" (libm:log1p x)(log1+ x)))
  (let ((*num=-tolerance* 1d-5))
    (loop for x in *0-to-1-rand-singles* :do
      (is (num= (libm:log1p x) (log1f+ x))
	  "LOG1P failed for floats, LIBM value ~F is not equal to CL value ~F" (libm:log1p x)(log1f+ x)))))

(test log2 ; CL may be able to do negatives
  (loop for x in *positive-rand-doubles* :do
    (is (num= (libm:log2 x) (lb x))
	"LOG2 failed for doubles, LIBM value ~F is not equal to CL value ~F" (libm:log2 x)(lb x)))
  (let ((*num=-tolerance* 1d-5))
    (loop for x in *positive-rand-singles* :do
      (is (num= (libm:log2 x) (lbf x))
	  "LOG2 failed for floats, LIBM value ~F is not equal to CL value ~F" (libm:log2 x)(lbf x)))))

;;; This test only works for positive values of x, though it is
;;; supposed to work for negative numbers too. I don't think the CL
;;; translation in the test is correct.
#+nil
(test logb ; Equal to log2 for positive values of x
      (loop for x in *rand-doubles*
	 :do (is (num= (libm:logb x) (cl:log x 2))
		 "Failed logb for doubles, LIBM value ~F is not equal to CL value ~F" (libm:logb x)(cl:log x 2)))
      (loop for x in *rand-singles*
	 :do (is (num= (libm:logb x) (cl:log x 2))
		 "Failed logb for floats, LIBM value ~F is not equal to CL value ~F" (libm:logb x)(cl:log x 2))))


;;; Not tested lrint, lround, nan, nextafter

;;; Need CL implementation for test
#+nil
(test nextafter
  (loop for x in *rand-doubles* :do
    (loop for y in *rand-doubles-y* :do
      (is (num= (libm:nextafter x y) (nextafter x y))
	  "NEXTAFTER failed for doubles, LIBM value ~F is not equal to CL value ~F" (libm:nextafter x y)(nextafter x y))))
  (loop for x in *rand-singles* :do
    (loop for y in *rand-singles-y* :do
      (is (num= (libm:nextafter x y) (nextafter x y))
	  "NEXTAFTER failed for floats, LIBM value ~F is not equal to CL value ~F" (libm:nextafter x y)(nextafter x y)))))

(defun cl-remainder (x y)
  "Returns the floating-point remainder of x/y (rounded towards zero):

remainder = x - n * y

Where n is the result of: x/y, rounded toward the nearest
integral value (with halfway cases rounded toward the even number)"
  (let ((n (cl:round (/ x y))))
    (- x (* n y))))

(test remainder
  (loop for x in *rand-doubles* :do
    (loop for y in *rand-doubles-y* :do
      (is (num= (libm:remainder x y) (remainder x y))
	  "REMAINDER failed for doubles, LIBM value ~F is not equal to CL value ~F" (libm:remainder x y)(cl-remainder x y))))
  (loop for x in *rand-singles* :do
    (loop for y in *rand-singles-y* :do
      (is (num= (libm:remainder x y) (remainder x y))
	  "REMAINDER failed for floats, LIBM value ~F is not equal to CL value ~F" (libm:remainder x y)(cl-remainder x y)))))

(test copysign ; this is similar to CL:FLOAT-SIGN
  (is (num= (libm:copysign 15.125D0 -2.75D0) (cl:float-sign -2.75D0 15.125D0))
      "Failed to copysign for doubles, LIBM value ~F is not equal to CL value ~F" (libm:copysign 15.125D0 -2.75D0) (cl:float-sign 15.125D0 -2.75D0))
  (is (num= (libm:copysign -15.125D0 -2.75D0) (cl:float-sign -2.75D0 -15.125D0))
      "Failed to copysign for doubles, LIBM value ~F is not equal to CL value ~F" (libm:copysign 15.125D0 -2.75D0) (cl:float-sign 15.125D0 -2.75D0))
    (is (num= (libm:copysign -15.125D0 2.75D0) (cl:float-sign 2.75D0 -15.125D0))
      "Failed to copysign for doubles, LIBM value ~F is not equal to CL value ~F" (libm:copysign 15.125D0 -2.75D0) (cl:float-sign 15.125D0 -2.75D0))
  (is (num= (libm:copysign 15.125D0 2.75D0) (cl:float-sign 2.75D0 15.125D0))
      "Failed to copysign for doubles, LIBM value ~F is not equal to CL value ~F" (libm:copysign 15.125D0 -2.75D0) (cl:float-sign 15.125D0 -2.75D0))
  (is (num= (libm:copysign 15.125 -2.75) (cl:float-sign -2.75 15.125))
      "Failed to copysign for doubles, LIBM value ~F is not equal to CL value ~F" (libm:copysign 15.125 -2.75) (cl:float-sign 15.125 -2.75))
  (is (num= (libm:copysign -15.125 -2.75) (cl:float-sign -2.75 -15.125))
      "Failed to copysign for doubles, LIBM value ~F is not equal to CL value ~F" (libm:copysign 15.125 -2.75) (cl:float-sign 15.125 -2.75))
    (is (num= (libm:copysign -15.125 2.75) (cl:float-sign 2.75 -15.125))
      "Failed to copysign for doubles, LIBM value ~F is not equal to CL value ~F" (libm:copysign 15.125 -2.75) (cl:float-sign 15.125 -2.75))
  (is (num= (libm:copysign 15.125 2.75) (cl:float-sign 2.75 15.125))
      "Failed to copysign for doubles, LIBM value ~F is not equal to CL value ~F" (libm:copysign 15.125 -2.75) (cl:float-sign 15.125 -2.75)))

(test nearbyint
  (loop for x in *rand-doubles* :do
    (is (num= (libm:nearbyint x) (cl:fround x))
	"Failed nearbyint for doubles, LIBM value ~F is not equal to CL value ~F" (libm:nearbyint x)(cl:fround x)))
  (loop for x in *rand-singles* :do
    (is (num= (libm:nearbyint x) (cl:fround x))
	"Failed nearbyint for floats, LIBM value ~F is not equal to CL value ~F" (libm:nearbyint x)(cl:fround x))))

