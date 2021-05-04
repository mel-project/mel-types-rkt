#lang racket

(require json)
(require "types.rkt")
(require "convert.rkt")

(define (coinid0 covhash) (CoinID covhash 0))
(define (coindata0 covhash)
  (CoinData
    covhash
    0
    "6d"
    ; additional data
    "2ada83c1819a5372dae1238fc1ded123c8104fdaa15862aaee69428a1820fcda"))

; Test tx as a user would define for their test env
(define (exec-env covhash)
  (list
    (list
      (CovEnv
        (coinid0 covhash)
        (CoinDataHeight
          (coindata0 covhash)
          0) ; height
        0 ; spender index
        (header-default))
      (Transaction
        0 ; kind
        (list (coinid0 covhash))
        (list (coindata0 covhash))
        0 ; fee
        (list) ; scripts
        ; data
        "0000000000000000000000000000000000000000000000000000000000000000"
        ;sigs
        (list)))))


; Read the covenant hash from stdin and generate a json test tx on stdout
(let* ([covhash (read-line (current-input-port))])
  (displayln (jsexpr->string (map-mels-to-hm (exec-env covhash)))))
