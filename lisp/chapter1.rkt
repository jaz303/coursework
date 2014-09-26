(define the-false-value (cons "false" "boolean"))
(define empty-begin (cons "empty" "begin"))
(define env.init '())
(define the-end-value (cons "end" "QUIT NOW"))

(define (atom? x)
  (and (not (pair? x))
       (not (null? x))))

(define (evaluate e env)
  (if (atom? e)
      (cond ((symbol? e) (lookup e env)) ; look up symbol in env
            ((or
              (number? e)
              (string? e)
              (char? e)
              (boolean? e)
              (vector? e)) e) ; literal
            (else (wrong "cannot evaluate" e)))
      (case (car e)
        ((quote)  (cadr e))
        ((if)     (if (not (eq? (evaluate (cadr e) env) the-false-value))
                      (evaluate (caddr e) env)
                      (evaluate (cadddr e) env)))
        ((begin)  (eprogn (cdr e) env))
        ((set!)   (update! (cadr e) env (evalaute (caddr e) env)))
        ((lambda) (make-function (cadr e) (cddr e) env))
        (else     (let* ((fn (evaluate (car e) env))
                         (args (evlis (cdr e) env)))
                    (begin
                      (display (cons fn args)) (newline)
                      (invoke fn args)))))))

(define (eprogn exps env)
  (if (pair? exps)
      (if (pair? (cdr exps))
          (begin (evaluate (car exps) env)
                 (eprogn (cdr exps) env))
          (evaluate (car exps) env))
      empty-begin))

(define (evlis exps env)
  (if (pair? exps)
      ;(cons (evaluate (car exps) env)
      ;      (evlis (cdr exps) env))
      
      ; this form forces the list to be evaluated
      ; from left to right
      (let ((argument1 (evaluate (car exps) env)))
        (cons argument1 (evlis (cdr exps) env)))
      
      '()))

(define (lookup id env)
  (if (pair? env)
      (if (eq? (caar env) id)
          (cdar env)
          (lookup id (cdr env)))
      (wrong "No such binding" id)))

(define (update! id env value)
  (if (pair? env)
      (if (eq? (caar env) id)
          (begin (set-cdr! (car env) value) value)
          (update! id (cdr env) value))
      (wrong "No such binding" id)))

(define (extend env variables values)
  (cond ((pair? variables)
         (if (pair? values)
             (cons (cons (car variables) (car values))
                   (extend env (cdr variables) (cdr values)))
             (wrong "Too few values")))
        ((null? variables)
         (if (null? values)
             env
             (wrong "Too many values")))
        ; update env with a single key/value
        ((symbol? variables) (cons (cons variables values) env))))

;(define (x.extend env names values)
;  (cons (cons names values) env))
;
;(define (x.lookup id env)
;  (cond ((pair? env)
;         ))
;
;(define (x.update! id env value)
;  )

(define (invoke fn args)
  (if (procedure? fn)
      (fn args)
      (wrong "Not a function" fn)))

(define (make-function variables body env)
  (lambda (args)
    (eprogn body (extend env variables args))))

; Simulation of shallow bindings...
; I understand what this does but not *why* you'd do it.
;
; Every time the function is called it copies the existing bindings
; for a functions arguments to a list, and then overwrites them in
; a seemingly global location ('apval property list).
;
; OK... so we're avoiding copying the entire env, instead only
; updating those which are specified in the function's arguments.
; Assuming an O(1) implementation of putprop/getprop I can see
; how this would be significantly faster...
(define (s.make-function variables body env)
  (lambda (values current.env)
    (let ((old-bindings
           (map (lambda (var val)
                  (let ((old-value (getprop var 'foobar)))
                    (putprop var 'foobar val)
                    (cons var old-value)))
                  variables
                  values)))
          (let ((result (eprogn body current.env)))
            (for-each (lambda (b) (putprop (car b) 'foobar (cdr b)))
                      old-bindings)
            result))))

(define env.global env.init)

(define-syntax definitial
  (syntax-rules ()
    ((definitial name)
     (begin (set! env.global (cons (cons 'name 'void) env.global))
            'name))
    ((definitial name value)
     (begin (set! env.global (cons (cons 'name value) env.global))
            'name))))

(define-syntax defprimitive
  (syntax-rules ()
    ((defprimitive name value arity)
     (definitial name
       (lambda (values)
         (if (= arity (length values))
             (apply value values)
             (wrong "Incorrect arity" (list 'name values))))))))

(definitial t #t)
(definitial f the-false-value)
(definitial nil '())

(definitial foo)
(definitial bar)
(definitial fib)
(definitial fact)

(defprimitive cons cons 2)
(defprimitive car car 1)
(defprimitive cdr cdr 1)
(defprimitive set-cdr! set-cdr! 2)
(defprimitive + + 2)
(defprimitive eq? eq? 2)
(defprimitive < (lambda (l r) (if (< l r) #t the-false-value)) 2)

(defprimitive end (lambda () the-end-value) 0)

(definitial list
  (lambda (values)
    (apply list values)))

(definitial apply
  (lambda (values)
    ((car values) (cadr values))))

(define (ch1-s)
  (define (toplevel)
    (let ((result (evaluate (read) env.global)))
      (display result)
      (if (not (eq? result the-end-value)) (toplevel))))
  (toplevel))