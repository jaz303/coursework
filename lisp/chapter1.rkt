(define the-false-value (cons "false" "boolean"))
(define empty-begin (cons "empty" "begin"))
(define env.init '())

(define (evaluate e env)
  (if (atom? e)
      (cond ((symbol? e) (lookup e env)) ; look up symbol in env
            ((or?
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
        (else     (invoke (evaluate (car e) env)
                          (evlis (cdr e) env))))))

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

(define (invoke fn args)
  (if (procedure? fn)
      (fn args)
      (wrong "Not a function" fn)))

(define (make-function variables body env)
  (lambda (args)
    (eprogn body (extend env variables args))))

; make-function
