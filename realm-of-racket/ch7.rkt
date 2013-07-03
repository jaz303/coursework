#lang racket

(define (my-map func lst)
  (cond [(empty? lst) empty]
        [else (cons (func (first lst)) (my-map func (rest lst)))]))

(define (my-filter pred? lst)
  (cond [(empty? lst) empty]
        [(pred? (first lst)) (cons (first lst) (my-filter pred? (rest lst)))]
        [else (my-filter pred? (rest lst))]))

(define (my-any pred? lst)
  (cond [(empty? lst) #f]
        [(pred? (first lst)) #t]
        [else (my-any pred? (rest lst))]))

(define (my-all pred? lst)
  (cond [(empty? lst) #t]
        [(pred? (first lst)) (my-all pred? (rest lst))]
        [else #f]))

(define (my-foldr f base lst)
  (cond [(empty? lst) base]
        [else (f (first lst) (my-foldr f base (rest lst)))]))

(define (my-build-list n f)
  (define (builder k)
    (cond [(= n k) empty]
          [else (cons (f k) (builder (add1 k)))]))
  (builder 0))

(define (sum lon) (apply + lon))

(define (d/dx fun)
  (define eps (/ 1 100000))
  (lambda (x)
    (/ (- (fun (+ x eps)) (fun (- x eps))) 2 eps)))
