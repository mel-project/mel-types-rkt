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
    ""))

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


(let* ([x "test"]
       [covhash "sdf"]
       ;[covhash (read-line (current-input-port))]
       [js-str (jsexpr->string (coinid->hashmap (CoinID covhash 0)))])
  (println js-str)
  (println (map-mels-to-hm (exec-env covhash)))
  (println (jsexpr->string (map-mels-to-hm (exec-env covhash))))
  (write-json js-str (open-output-file "tmp.test")))
