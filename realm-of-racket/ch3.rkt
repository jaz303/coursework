#lang racket

(struct person (name age city) #:transparent)

(define jason (person 'Jason 32 'Balfron))
(define joe (person 'Joe 24 'Edinburgh))

(define people (list jason joe))
