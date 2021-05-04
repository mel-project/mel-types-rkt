#lang typed/racket

(require "types.rkt")

(provide melstruct->hashmap
         header-default)


(: melstruct->hashmap (-> MelStruct JsonExpr))
(define (melstruct->hashmap h)
  (cond
    [(CoinData? h) (coindata->hashmap h)]
    [(CoinDataHeight? h) (coindataheight->hashmap h)]
    [(Transaction? h) (transaction->hashmap h)]
    [(CovEnv? h) (covenv->hashmap h)]
    [(Header? h) (header->hashmap h)]
    [(CoinID? h) (coinid->hashmap h)]
    [(list? h) (map melstruct->hashmap h)]))

(define-type JsonExpr
  (U Boolean
     String
     Integer
     (Listof JsonExpr)
     (HashTable Symbol JsonExpr)))

(: coinid->hashmap (-> CoinID JsonExpr))
(define (coinid->hashmap c)
  (match c
    [(CoinID txhash index)
     `#hasheq((txhash . ,txhash)
              (index  . ,index))]))

(: coindata->hashmap (-> CoinData JsonExpr))
(define (coindata->hashmap c)
  (match c
    [(CoinData covhash value denom additional-data)
     `#hasheq((covhash . ,covhash)
              (value   . ,value)
              (denom   . ,denom)
              (additional_data . ,additional-data))]))

(: coindataheight->hashmap (-> CoinDataHeight JsonExpr))
(define (coindataheight->hashmap c)
  (match c
    [(CoinDataHeight coin-data height)
     `#hasheq((coin_data . ,(coindata->hashmap coin-data))
              (height    . ,height))]))

(: transaction->hashmap (-> Transaction JsonExpr))
(define (transaction->hashmap t)
  (match t
    [(Transaction kind inputs outputs fee scripts data sigs)
     `#hasheq((kind    . ,kind)
              (inputs  . ,(melstruct->hashmap inputs))
              (outputs . ,(melstruct->hashmap outputs))
              (fee     . ,fee)
              (scripts . ,scripts)
              (data    . ,data)
              (sigs    . ,sigs))]))

(: covenv->hashmap (-> CovEnv JsonExpr))
(define (covenv->hashmap e)
  (match e
    [(CovEnv coin-id coin-data-height spender-index last-header)
     `#hasheq((parent_coinid . ,(coinid->hashmap coin-id))
              (parent_cdh    . ,(coindataheight->hashmap coin-data-height))
              (spender_index   . ,spender-index)
              (last_header   . ,(header->hashmap last-header)))]))

(: header->hashmap (-> Header JsonExpr))
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

(: header-default (-> Header))
(define (header-default)
  (Header 1  ; main-net
          "0000000000000000000000000000000000000000000000000000000000000000" ; previous
          0  ; height
          "0000000000000000000000000000000000000000000000000000000000000000" ; history_hash
          "0000000000000000000000000000000000000000000000000000000000000000" ; coins_hash
          "0000000000000000000000000000000000000000000000000000000000000000" ; transactions_hash
          0  ; fee_pool 
          1  ; fee_multiplier
          1  ; dosc_speed
          "0000000000000000000000000000000000000000000000000000000000000000" ; pools_hash
          "0000000000000000000000000000000000000000000000000000000000000000" ; stakes_hash
          ))
