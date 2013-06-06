#lang R5RS

(define (square x) (* x x))

(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))

(define (abs2 x)
  (if (< x 0)
      (- x)
      x))

; Exercise 1.2
(define (equation)
  (/ (+ 5 (+ 4 (- 2 (- 3 (+ 6 (/ 4 5))))))
   (* 3 (- 6 2) (- 2 7))))

; Exercise 1.3
(define (sum-of-squares a b)
  (+ (* a a) (* b b)))

(define (larger x y)
  (if (> x y) x y))

(define (sum-of-largest-squares a b c)
  (if (= a (larger a b))
      (sum-of-squares a (larger b c))
      (sum-of-squares b (larger a c))))

; Exercise 1.4
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; Helpers for the following...

(define (average x y)
  (/ (+ x y) 2))

(define (average3 x y z)
  (/ (+ x y z) 3))

; Exercise 1.7

(define (sqrt x)
  (sqrt-iter 1.0 2.0 x))

(define (sqrt-iter guess last-guess x)
  (if (good-enough? guess last-guess)
      guess
      (sqrt-iter (improve guess x)
                 guess
                 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good-enough? guess1 guess2)
  (< (abs (- guess1 guess2)) (* guess1 0.001)))

; Exercise 1.8

(define (cube-root x)
  (cube-root-iter 1.0 2.0 x))

(define (cube-root-iter guess last-guess x)
  (if (good-enough? guess last-guess)
      guess
      (cube-root-iter (cube-root-improve guess x)
                      guess
                      x)))

(define (cube-root-improve guess x)
  (/ (+ (/ x (* guess guess)) (* 2 guess)) 3))

; Messing about

(define (make-root-finder initial-guess initial-last-guess improver)
  (lambda (x)
    (define (good-enough? guess last-guess)
      (< (abs (- guess last-guess)) (* guess 0.001)))
    (define (iter guess last-guess)
      (if (good-enough? guess last-guess)
          guess
          (iter (improver guess x)
                guess)))
    (iter initial-guess initial-last-guess)))

(define sqrt2 (make-root-finder 1.0 2.0 (lambda (guess target)
                                          (average guess (/ target guess)))))

(define cubert2 (make-root-finder 1.0 2.0 (lambda (guess target)
                                            (average3 (/ target (square guess)) guess guess))))
