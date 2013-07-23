#lang racket

(require racket/promise)

(define foo (delay (delay (+ 1 2))))
(define bar (force foo))

bar

(define baz (lazy (lazy bar)))
(define bleem (force baz))

bleem