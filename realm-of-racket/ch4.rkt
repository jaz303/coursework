#lang racket

(define (foo)
  (if (= (+ 1 2) 3)
      'yes
      'no))

(define x 7)
(cond [(= x 7) 5]
      [(odd? x) 'odd-number]
      [else 'even-number])

(define (my-length a-list)
  (cond [(empty? a-list) 0]
        [else (add1 (my-length (rest a-list)))]))

(struct point (x y) #:transparent)


(require rackunit)
(check-equal? (add1 5) 6)
; check-equal?
; check-not-equal?
; check-true
; check-false
; check-not-false
; check-pred ... (check-pred number? 5)
; check-= ... (check-= 1 3 2)

(struct posn (x y))
(struct rectangle (width height))
(define (inside-of-rectangle? r p)
  (define x (posn-x p))
  (define y (posn-y p))
  (define width (rectangle-width r))
  (define height (rectangle-height r))
  (and (<= 0 x) (< x width) (<= 0 y) (< y height)))
