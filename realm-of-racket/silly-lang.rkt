#lang racket

(define-syntax-rule
  (module-count-and-print f ...)
  (#%module-begin (count-and-print f) ...))

(define-syntax-rule
  (count-and-print f)
  (begin (count++ 'f) f))

(define-syntax-rule
  (interact-count-and-print . f)
  (count-and-print f))

(define count 0)
(define (count++ f)
  (set! count (+ count 1))
  (displayln `(evaluating form ,count : ,f)))

(provide
 (rename-out [module-count-and-print #%module-begin])
 (rename-out [interact-count-and-print #%top-interaction])
 (except-out (all-from-out racket)
             #%module-begin #%top-interaction))