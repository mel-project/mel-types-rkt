#lang racket

(require json)
(require "types.rkt")
(require "convert.rkt")

(let ([x "test"]
      [covhash (read-line (current-input-port))])
  (print (jsexpr->string (coinid->hashmap (CoinID covhash 0)))))
  ;(write-json (CoinID x 0) (open-output-file "tmp.test")))
  ;(write-to-file (CoinID x 0) "tmp.test")
  ;(print (CoinID-txhash (CoinID x 0))))
