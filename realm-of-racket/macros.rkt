#lang racket

(define-syntax-rule
  (my-and a b)
  (if a b #f))

(define-syntax-rule
  (my-or a b)
  (let ((tmp a))
    (if tmp tmp b)))

(define-syntax-rule
  (my-let ((name initial-value-exp) ...) body)
  ((lambda (name ...) body) initial-value-exp ...))