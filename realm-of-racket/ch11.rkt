#lang racket

(define (make-lazy+ i)
  (lambda ()
    (apply + (build-list (* 500 i) values))))

(define long-big-list (build-list 5000 make-lazy+))

(define (compute-every-1000th l)
  (for/list ([thunk l]
             [i (in-naturals)]
             #:when (zero? (remainder i 1000)))
    (thunk)))

(define (memoize fun)
  (define hidden #f)
  (define run? #f)
  (lambda ()
    (cond [run? hidden]
          [else (set! hidden (fun))
                (set! run? #t)
                hidden])))

