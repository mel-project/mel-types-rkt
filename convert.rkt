#lang racket

(require json)
(require "types.rkt")

(provide coinid->hashmap
         coindata->hashmap
         coindataheight->hashmap
         header->hashmap
         transaction->hashmap
         header-default
         map-mels-to-hm)

(define (coinid->hashmap c)
  `#hasheq((txhash . ,(CoinID-txhash c))
           (index  . ,(CoinID-index c))))

(define (coindata->hashmap c)
  `#hasheq((covhash . ,(CoinData-covhash c))
           (value   . ,(CoinData-value c))
           (denom   . ,(CoinData-denom c))
           (additional_data . ,(CoinData-additional_data c))))

(define (coindataheight->hashmap c)
  `#hasheq((coin_data . ,(coindata->hashmap (CoinDataHeight-coin-data c)))
           (height    . ,(CoinDataHeight-height c))))

(define (transaction->hashmap t)
  `#hasheq((kind    . ,(Transaction-kind t))
           (inputs  . ,(map-mels-to-hm (Transaction-inputs t)))
           (outputs . ,(map-mels-to-hm (Transaction-outputs t)))
           (fee     . ,(Transaction-fee t))
           (scripts . ,(Transaction-scripts t))
           (data    . ,(Transaction-data t))
           (sigs    . ,(Transaction-sigs t))))

(define (covenv->hashmap e)
  `#hasheq((parent_coinid . ,(coinid->hashmap (CovEnv-coin-id e)))
           (parent_cdh    . ,(coindataheight->hashmap (CovEnv-coin-data-height e)))
           (spender_idx   . ,(CovEnv-spender-index e))
           (last_header   . ,(header->hashmap (CovEnv-last-header e)))))

(define (header->hashmap e)
  `#hasheq((network           . ,(Header-network e))
           (previous          . ,(Header-previous e))
           (height            . ,(Header-height e))
           (history_hash      . ,(Header-history-hash e))
           (coins_hash        . ,(Header-coins-hash e))
           (transactions_hash . ,(Header-transactions-hash e))
           (fee_pool          . ,(Header-fee-pool e))
           (fee_multiplier    . ,(Header-fee-multiplier e))
           (dosc_speed        . ,(Header-dosc-speed e))
           (pools_hash        . ,(Header-pools-hash e))
           (stakes_hash       . ,(Header-stakes-hash e))))

(define (header-default)
  (Header "main-net"
          "" ; previous
          0  ; height
          "" ; history_hash
          "" ; coins_hash
          "" ; transactions_hash
          0  ; fee_pool 
          1  ; fee_multiplier
          1  ; dosc_speed
          "" ; pools_hash
          "" ; stakes_hash
  ))

; Fold a list of mel types into hashmaps
(define (map-mels-to-hm l)
  ;(println l)
  ;(println "")
  (if (null? l) l
    (cons
      (let ([h (car l)])
        (cond
          [(CoinData? h) (coindata->hashmap h)]
          [(CoinDataHeight? h) (coindataheight->hashmap h)]
          [(Transaction? h) (transaction->hashmap h)]
          [(CovEnv? h) (covenv->hashmap h)]
          [(Header? h) (header->hashmap h)]
          [(CoinID? h) (coinid->hashmap h)]
          [(list? h) (map-mels-to-hm h)]))
      (map-mels-to-hm (cdr l)))))
