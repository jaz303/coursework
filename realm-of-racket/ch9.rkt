#lang racket

(for ([i '(1 2 3 4 5)])
  (display i))

(for/list ([i '(1 2 3 4 5)])
  (/ 1 i))

(for/fold ([sqrs 0])
  ([i '(1 2 3 4 5 6 7 8 9 10)])
  (+ (sqr i) sqrs))

(for/fold ([sqrs 0]
           [count 0])
  ([i '(1 2 3 4 5 6 7 8 9 10)])
  (values (+ (sqr i) sqrs)
          (if (> (sqr i) 50)
              (add1 count)
              count)))

(define-values (a b c) (values 'a 'b 'c))

(for/list ([i '(1 2 3 4 5)]
           #:when (odd? i))
  i)

(for/list ([i '(1 2 3 4 5)]
           [j '(6 7 8 9 10)]
           [k '(11 12 13 14 15)])
  (list i j k))

;
;(for*/list ([i '(1 2 3 4 5)]
;            [j '(6 7 8 9 10)]
;            [k '(11 12 13 14 15)])
;  (list i j k))

(for/list ([i (in-range 10)])
  (+ i i))