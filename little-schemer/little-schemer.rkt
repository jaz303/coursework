(begin
  (define atom?
    (lambda (x)
      (and
       (not (pair? x))
       (not (null? x)))))

  (define lat?
    (lambda (l)
      (cond
        ((null? l) #t)
        ((atom? (car l)) (lat? (cdr l)))
        (else #f))))
  
  (define member?
    (lambda (atom list)
      (cond
        ((null? list) #f)
        ((eq? atom (car list)) #t)
        (else (member? atom (cdr list))))))

  (define rember
    (lambda (a lat)
      (cond
        ((null? lat) '())
        ((eq? a (car lat)) (cdr lat))
        (else (cons (car lat) (rember a (cdr lat)))))))
  
  (define firsts
    (lambda (ls)
      (cond
        ((null? ls) '())
        (else (cons
               (caar ls)
               (firsts (cdr ls)))))))
  
  (define insertR
    (lambda (new old lat)
      (cond
        ((null? lat) '())
        ((eq? (car lat) old) (cons old (cons new (cdr lat))))
        (else (cons (car lat) (insertR new old (cdr lat)))))))
  
  (define insertL
    (lambda (new old lat)
      (cond
        ((null? lat) '())
        (else (cond
                ((eq? (car lat) old) (cons new lat))
                (else (cons (car lat) (insertL new old (cdr lat)))))))))

  
  (define subst
    (lambda (new old lat)
      (cond
        ((null? lat) '())
        (else (cond
                ((eq? (car lat) old) (cons new (cdr lat)))
                (else (cons (car lat) (subst new old (cdr lat)))))))))
  
  
  (define subst2
    (lambda (new o1 o2 lat)
      (cond
        ((null? lat) '())
        (else (cond
                ((or
                  (eq? (car lat) o1)
                  (eq? (car lat) o2))
                 (cons new (cdr lat)))
                (else
                 (cons
                  (car lat)
                  (subst2 new o1 o2 (cdr lat)))))))))

  (define multirember
    (lambda (a lat)
      (cond
        ((null? lat) '())
        (else (cond
                ((eq? a (car lat)) (multirember a (cdr lat)))
                (else (cons (car lat) (multirember a (cdr lat)))))))))
  
  (define multiinsertR
    (lambda (new old lat)
      (cond
        ((null? lat) '())
        (else (cond
                ((eq? old (car lat)) (cons old (cons new (multiinsertR new old (cdr lat)))))
                (else (cons (car lat) (multiinsertR new old (cdr lat)))))))))
      
  
  (define multisubst
    (lambda (new old lat)
      (cond
        ((null? lat) '())
        ((eq? (car lat) old) (cons
                              new
                              (multisubst new old (cdr lat))))
        (else (cons
               (car lat)
               (multisubst new old (cdr lat)))))))
  
  (define add1
    (lambda (n) (+ n 1)))
  
  (define sub1
    (lambda (n) (- n 1)))
  
  (define o+
    (lambda (n m)
      (cond
        ((zero? m) n)
        (else (add1 (o+ n (sub1 m)))))))
  
  (define o-
    (lambda (n m)
      (cond
        ((zero? m) n)
        (else (sub1 (o- n (sub1 m)))))))
  
  (define addtup
    (lambda (tup)
      (cond
        ((null? tup) 0)
        (else (o+ (car tup) (addtup (cdr tup)))))))
 
  (define o*
    (lambda (n m)
      (cond
        ((zero? m) 0)
        (else (o+ n (o* n (sub1 m)))))))
  
  
  (define tup+
    (lambda (tup1 tup2)
      (cond
        ((and (null? tup1) (null? tup2)) '())
        ((null? tup1) tup2)
        ((null? tup2) tup1)
        (else (cons (o+ (car tup1) (car tup2)) (tup+ (cdr tup1) (cdr tup2)))))))
 
  (define gt?
    (lambda (n m)
      (cond
        ((zero? n) #f)
        ((zero? m) #t)
        (else (gt? (sub1 n) (sub1 m))))))
  

  (define lt?
    (lambda (n m)
      (cond
        ((zero? m) #f)
        ((zero? n) #t)
        (else (lt? (sub1 n) (sub1 m))))))
  
  (define o/
    (lambda (n m)
      (cond
        ((lt? n m) 0)
        (else (add1 (o/ (o- n m) m))))))
  
  (define len
    (lambda (lat)
      (cond
        ((null? lat) 0)
        (else (add1 (len (cdr lat)))))))
  
  
  (define pick
    (lambda (n lat)
      (cond
        ((= 1 n) (car lat))
        (else (pick (sub1 n) (cdr lat))))))
  
  (define rempick
    (lambda (n lat)
      (cond
        ((one? n) (cdr lat))
        (else (cons (car lat) (rempick (sub1 n) (cdr lat)))))))
  
  (define no-nums
    (lambda (lat)
      (cond
        ((null? lat) '())
        (else (cond
                ((number? (car lat)) (no-nums (cdr lat)))
                (else (cons (car lat) (no-nums (cdr lat)))))))))
  
  (define all-nums
    (lambda (lat)
      (cond
        ((null? lat) '())
        (else (cond
                ((number? (car lat)) (cons (car lat) (all-nums (cdr lat))))
                (else (all-nums (cdr lat))))))))
  
  (define eqan?
    (lambda (a1 a2)
      (cond
        ((and (number? a1) (number? a2)) (= a1 a2))
        ((or (number? a1) (number? a2)) #f)
        (else (eq? a1 a2)))))
  
  (define occur
    (lambda (a lat)
      (cond
        ((null? lat) 0)
        (else (cond
                ((eqan? a (car lat)) (add1 (occur a (cdr lat))))
                (else (occur a (cdr lat))))))))
  
  (define one?
    (lambda (n)
      (= n 1)))
  
  ; Chapter 5
  
  (define rember*
    (lambda (a l)
    (cond
      ((null? l) '())
      (else (cond
              ((pair? (car l)) (cons (rember* a (car l)) (rember* a (cdr l))))
              (else (cond
                      ((eq? a (car l)) (rember* a (cdr l)))
                      (else (cons (car l) (rember* a (cdr l)))))))))))
  
  (define insertR*
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((atom? (car l)) (cond
                           ((eq? (car l) old) (cons old (cons new (insertR* new old (cdr l)))))
                           (else (cons (car l) (insertR* new old (cdr l))))
                           ))
        (else (cons (insertR* new old (car l)) (insertR* new old (cdr l)))))))
  
  (define occur*
    (lambda (a l)
      (cond
        ((null? l) 0)
        ((atom? (car l)) (cond
                           ((eq? (car l) a) (add1 (occur* a (cdr l))))
                           (else (occur* a (cdr l)))))
        (else (+ (occur* a (car l)) (occur* a (cdr l)))))))
 
  (define subst*
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((atom? (car l)) (cond
                           ((eq? (car l) old) (cons new (subst* new old (cdr l))))
                           (else (cons (car l) (subst* new old (cdr l))))))
        (else (cons (subst* new old (car l)) (subst* new old (cdr l)))))))
                         
  (define insertL*
    (lambda (new old l)
      (cond
        ((null? l) '())
        ((atom? (car l)) (cond
                           ((eq? (car l) old) (cons new (cons old (insertL* new old (cdr l)))))
                           (else (cons (car l) (insertL* new old (cdr l))))))
        (else (cons (insertL* new old (car l)) (insertL* new old (cdr l)))))))
  
  (define member*
    (lambda (a l)
      (cond
        ((null? l) #f)
        ((atom? (car l)) (cond
                           ((eq? (car l) a) #t)
                           (else (member* a (cdr l)))))
        (else (or (member* a (car l)) (member* a (cdr l)))))))
  
  (define lefmost
    (lambda (l)
      (cond
        ((atom? (car l)) (car l))
        (else (leftmost (car l))))))

  (define _equal?
    (lambda (s1 s2)
      (cond
        ((and (atom? s1) (atom? s2)) (eqan? s1 s2))
        ((or (atom? s1) (atom? s2)) #f)
        (else (eqlist? s1 s2)))))
  
  (define eqlist?
    (lambda (l1 l2)
      (cond
        ((and (null? l1) (null? l2)) #t)
        ((or (null? l1) (null? l2)) #f)
        (else (and (_equal? (car l1) (car l2)) (eqlist? (cdr l1) (cdr l2)))))))
  
  ; Chapter 6
  
  (define numbered?
    (lambda (aexp)
      (cond
        ((atom? aexp) (number? aexp))
        ((eq? (cadr aexp) '+) (and (numbered? (car aexp)) (numbered? (caddr aexp))))
        ((eq? (cadr aexp) '*) (and (numbered? (car aexp)) (numbered? (caddr aexp))))
        ((eq? (cadr aexp) '-) (and (numbered? (car aexp)) (numbered? (caddr aexp)))))))
        
  (define value
    (lambda (nexp)
      (cond
        ((atom? nexp) nexp)
        ((eq? (cadr nexp) '+) (+ (value (car nexp)) (value (caddr nexp))))
        ((eq? (cadr nexp) '*) (* (value (car nexp)) (value (caddr nexp))))
        ((eq? (cadr nexp) '-) (- (value (car nexp)) (value (caddr nexp))))
        (else #f))))
  
  (define sero? (lambda (n) (null? n)))
  
  (define edd1
    (lambda (n)
      (cons '() n)))
  
  (define zub1
    (lambda (n)
      (cdr n)))
  
  (define wtfadd
    (lambda (n m)
      (cond
        ((sero? m) n)
        (else (wtfadd (edd1 n) (zub1 m))))))
  
  ; Chapter 7
  
  (define set?
    (lambda (lat)
      (cond
        ((null? lat) #t)
        ((member? (car lat) (cdr lat)) #f)
        (else (set? (cdr lat))))))
  
  ;(define makeset
  ;  (lambda (lat)
  ;    (cond
  ;      ((null? lat) '())
  ;      ((member? (car lat) (cdr lat)) (makeset (cdr lat)))
  ;      (else (cons (car lat) (makeset (cdr lat)))))))
  
  (define makeset
    (lambda (lat)
      (cond
        ((null? lat) '())
        (else (cons (car lat) (makeset (multirember (car lat) (cdr lat))))))))
  
  ;(define subset?
  ;  (lambda (set1 set2)
  ;    (cond
  ;      ((null? set1) #t)
  ;      ((member? (car set1) set2) (subset? (cdr set1) set2))
  ;      (else #f))))
  
  (define subset?
    (lambda (set1 set2)
      (cond
        ((null? set1) #t)
        (else (and (member? (car set1) set2) (subset? (cdr set1) set2))))))
  
  (define eqset?
    (lambda (set1 set2)
      (and (subset? set1 set2) (subset? set2 set1))))
  
  (define intersect?
    (lambda (set1 set2)
      (cond
        ((null? set1) #f)
        (else (or (member? (car set1) set2) (intersect? (cdr set1) set2))))))
  
  (define intersect
    (lambda (set1 set2)
      (cond
        ((null? set1) '())
        ((member? (car set1) set2) (cons (car set1) (intersect (cdr set1) set2)))
        (else (intersect (cdr set1) set2)))))
  
  (define union
    (lambda (set1 set2)
      (cond
        ((null? set1) set2)
        ((member? (car set1) set2) (union (cdr set1) set2))
        (else (cons (car set1) (union (cdr set1) set2))))))
  
  (define intersectall
    (lambda (l-set)
      (cond
        ((null? (cdr l-set)) (car l-set))
        (else (intersect (car l-set) (intersectall (cdr l-set)))))))
         
  (define a-pair?
    (lambda (x)
      (cond
        ((atom? x) #f)
        ((null? x) #f)
        ((null? (cdr x)) #f)
        ((null? (cddr x)) #t)
        (else #f))))
  
  (define first (lambda (p) (car p)))
  (define second (lambda (p) (car (cdr p))))
  (define third (lambda (p) (caddr p)))
  
  (define build (lambda (s1 s2) (cons s1 (cons s2 '()))))
  
  (define fun?
    (lambda (rel)
      (set? (firsts rel))))
  
  (define revpair
    (lambda (pair)
      (build (second pair) (first pair))))
  
  (define revrel
    (lambda (rel)
      (cond
        ((null? rel) '())
        (else (cons (revpair (car rel)) (revrel (cdr rel)))))))
  
  (define fullfun?
    (lambda (rel)
      (and (set? (firsts rel)) (set? (firsts (revrel rel))))))

  ; 8 - Lambda The Ultimate
  
;  (define rember-f
;    (lambda (test? a l)
;      (cond
;        ((null? l) '())
;        ((test? a (car l)) (cdr l))
;        (else (cons (car l) (rember-f test? a (cdr l)))))))
  
  (define eq?-c
    (lambda (a)
      (lambda (x)
        (eq? a x))))
  
  (define rember-f
    (lambda (test?)
      (lambda (a l)
        (cond
          ((null? l) '())
          ((test? a (car l)) (cdr l))
          (else (cons (car l) ((rember-f test?) a (cdr l))))))))
  
  (define insertL-f
    (lambda (test?)
      (lambda (new old l)
        (cond
          ((null? l) '())
          ((test? old (car l)) (cons new l))
          (else (cons (car l) ((insertL-f test?) new old (cdr l))))))))
  
  (define insertR-f
    (lambda (test?)
      (lambda (new old l)
        (cond
          ((null? l) '())
          ((test? old (car l)) (cons (car l) (cons new (cdr l))))
          (else (cons (car l) ((insertR-f test?) new old (cdr l))))))))
  
  (define seqL
    (lambda (new old l)
      (cons new (cons old l))))
  
  (define seqR
    (lambda (new old l)
      (cons old (cons new l))))
  
  (define insert-g
    (lambda (seq)
      (lambda (new old l)
        (cond
          ((null? l) '())
          ((eq? old (car l)) (seq new old (cdr l)))
          (else (cons (car l) ((insert-g seq) new old (cdr l))))))))
  
  (define insertL (insert-g seqL))
  (define insertR (insert-g seqR))
  
  (define seqS
    (lambda (new old l)
      (cons new l)))
  
  (define subst (insert-g seqS))
  
  (define atom-to-function
    (lambda (x)
      (cond
        ((eq? x '+) o+)
        ((eq? x '*) o*)
        (else o/))))
  
  (define operator
    (lambda (l)
      (atom-to-function (car l))))
  
  (define value
    (lambda (nexp)
      (cond
        ((atom? nexp) nexp)
        (else ((operator nexp) (value (cadr nexp)) (value (caddr nexp)))))))
  
  (define multirember-f
    (lambda (test?)
      (lambda (a lat)
        (cond
          ((null? lat) '())
          ((test? (car lat) a) ((multirember-f test?) a (cdr lat)))
          (else (cons (car lat) ((multirember-f test?) a (cdr lat))))))))
  
  (define multirember-eq? (multirember-f eq?))
  
  (define eq?-tuna (eq?-c 'tuna))
  
  (define multiremberT
    (lambda (test? lat)
      (cond
        ((null? lat) '())
        ((test? (car lat)) (multiremberT test? (cdr lat)))
        (else (cons (car lat) (multiremberT test? (cdr lat)))))))
  
  (define a-friend
    (lambda (x y)
      (null? y)))
  
  (define partition
    (lambda (test? lat col)
      (cond
        ((null? lat) (col '() '()))
        ((test? (car lat))
         (partition test? (cdr lat)
                    (lambda (matching non-matching)
                      (col (cons (car lat) matching) non-matching))))
        (else
         (partition test? (cdr lat)
                    (lambda (matching non-matching)
                      (col matching (cons (car lat) non-matching))))))))
  
  (define is-tuna?
    (lambda (a)
      (eq? a 'tuna)))
  
  (define multiinsertLR&co
    (lambda (new oldL oldR lat col)
      (cond
        ((null? lat) (col '() 0 0))
        ((eq? oldL (car lat))
         (multiinsertLR&co new oldL oldR (cdr lat)
                           (lambda (newlat countL countR)
                             (col (cons new (cons oldL newlat)) (add1 countL) countR))))
        ((eq? oldR (car lat))
         (multiinsertLR&co new oldL oldR (cdr lat)
                           (lambda (newlat countL countR)
                             (col (cons oldR (cons new newlat)) countL (add1 countR)))))
        (else (multiinsertLR&co new oldL oldR
                                (lambda (newlat countL countR)
                                  (col (cons (car lat) newlat) countL countR)))))))
  
  (define evens-only*&co
    (lambda (l col)
      (cond
        ((null? l) (col '() 1 0))
        ((atom? (car l))
         (cond
           ((even? (car l))
            (evens-only*&co (cdr l)
                            (lambda (newl evens-product odds-sum)
                              (col (cons (car l) newl) (* evens-product (car l)) odds-sum))))
           (else
            (evens-only*&co (cdr l)
                            (lambda (newl p s)
                              (col newl p (+ (car l) s)))))))
        (else
         (evens-only*&co (car l)
                         (lambda (al ap as)
                           (evens-only*&co (cdr l)
                                           (lambda (newl p s)
                                             (col (cons al newl) (* p ap) (+ s as))))))))))
  
  ; Chapter 9 - ...and Again, and Again, and Again,....
  
  (define keep-looking
    (lambda (a sorn lat)
      (cond
        ((number? sorn) (keep-looking a (pick sorn lat) lat))
        (else (eq? sorn a)))))
  
  (define eternity
    (lambda (x)
      (eternity x)))
  
  (define shift
    (lambda (pair)
      (build (first (first pair))
             (build (second (first pair))
                    (second pair)))))
  
  (define align
    (lambda (pora)
      (cond
        ((atom? pora) pora)
        ((a-pair? (first pora))
         (align (shift pora)))
        (else (build (first pora) (align (second pora)))))))
  
  ((lambda (mk-length)
     (mk-length eternity))
   (lambda (length)
     (lambda (l)
       (cond
         ((null? l) 0)
         (else (add1 (length (cdr l))))))))
  
 
  ; Chapter 10
  
  (define new-entry build)
  
  (define lookup-in-entry-help
    (lambda (name names values entry-f)
      (cond
        ((null? names) (entry-f name))
        ((eq? (car names) name) (car values))
        (else
         (lookup-in-entry-help name (cdr names) (cdr values) entry-f)))))
  
  (define lookup-in-entry
    (lambda (name entry entry-f)
      (lookup-in-entry-help name (first entry) (second entry) entry-f)))
  
  (define extend-table cons)
  
  (define lookup-in-table
    (lambda (name table table-f)
      (cond
        ((null? table) (table-f name))
        (else
         (lookup-in-entry name (car table)
                                (lambda (name2)
                                  (lookup-in-table name2 (cdr table) table-f)))))))
  
  (define expression-to-action
    (lambda (e)
      (cond
        ((atom? e) (atom-to-action e))
        (else (list-to-action e)))))
  
  (define atom-to-action
    (lambda (a)
      (cond
        ((number? a) *const)
        ((eq? a #t) *const)
        ((eq? a #f) *const)
        ((eq? a 'cons) *const)
        ((eq? a 'car) *const)
        ((eq? a 'cdr) *const)
        ((eq? a 'atom?) *const)
        ((eq? a 'null?) *const)
        ((eq? a 'eq?) *const)
        ((eq? a 'zero?) *const)
        ((eq? a 'add1) *const)
        ((eq? a 'sub1) *const)
        ((eq? a 'number) *const)
        (else *identifier))))
  
  (define list-to-action
    (lambda (l)
      (cond
        ((atom? (car l))
         (cond
           ((eq? 'quote (car e)) *quote)
           ((eq? 'lambda (car e)) *lambda)
           ((eq? 'cond (car e)) *cond)
           (else *application)))
        (else *application))))
  
  (define value
    (lambda (e)
      (meaning e '())))
  
  (define meaning
    (lambda (e table)
      ((expression-to-action e) e table)))
  
  (define *const
    (lambda (e table)
      (cond
        ((number? e) e)
        ((eq? e #t) #t)
        ((eq? e #f) #f)
        (else (build 'primitive e)))))
  
  (define *quote
    (lambda (e table)
      (text-of e)))
  
  (define text-of second)
  
  (define *identifier
    (lambda (e table)
      (lookup-in-table e table initial-table)))
  
  (define initial-table
    (lambda (name)
      (car '())))
  
  (define *lambda
    (lambda (e table)
      (build 'non-primitive (cons table (cdr e)))))
  
  (define table-of first)
  (define formals-of second)
  (define body-of third)
  
  (define evcon
    (lambda (lines table)
      (cond
        ((else? (question-of (car lines))) (meaning (answer-of (car lines)) table))
        ((meaning (question-of (car lines)) table) (meaning (answer-of (car lines)) table))
        (else (evcon (cdr lines) table)))))
  
  (define else?
    (lambda (x)
      (cond
        ((atom? x) (eq? x 'else))
        (else #f))))
  
  (define question-of first)
  (define answer-of second)
  
  (define *cond
    (lambda (e table)
      (evcon (cond-lines-of e) table)))

  (define cond-lines-of cdr)
  
  (define evlis
    (lambda (args table)
      (cond
        ((null? args) '())
        (else (cons (meaning (car args) table) (evlis (cdr args) table))))))

  (define *application
    (lambda (e table)
      (apply1
       (meaning (function-of e) table)
       (evlis (arguments-of e) table))))
  
  (define function-of car)
  (define arguments-of cdr)
  
  (define primitive?
    (lambda (l)
      (eq? (first l) 'primitive)))
  
  (define non-primitive?
    (lambda (l)
      (eq? (first l) 'non-primitive)))
  
  (define apply1
    (lambda (fun vals)
      (cond
        ((primitive? fun)
         (apply-primitive (second fun) vals))
        ((non-primitive? fun)
         (apply-closure (second fun) vals)))))
  
  (define apply-primitive
    (lambda (name vals)
      (cond
        ((eq? name 'cons) (cons (first vals) (second vals)))
        ((eq? name 'car) (car (first vals)))
        ((eq? name 'cdr) (cdr (first vals)))
        ((eq? name 'null?) (null? (first vals)))
        ((eq? name 'eq?) (eq? (first vals) (second vals)))
        ((eq? name 'atom?) (:atom? (first vals)))
        ((eq? name 'zero?) (zero? (first vals)))
        ((eq? name 'add1) (add1 (first vals)))
        ((eq? name 'sub1) (sub1 (first vals)))
        ((eq? name 'number?) (number? (first vals))))))
  
  (define :atom?
    (lambda (e)
      (cond
        ((atom? e) #t)
        ((null? e) #f)
        ((eq? (car x) 'primitive) #t)
        ((eq? (car x) 'non-primitive) #t)
        (else #f))))
  
  (define apply-closure
    (lambda (closure vals)
      (meaning (body-of closure) (extend-table
                                  (new-entry
                                   (formals-of closure)
                                   vals)
                                  (table-of closure)))))
  
)



