#lang typed/racket

(require "types.rkt")

(provide melstruct->hashmap
         header-default)


(: melstruct->hashmap (-> MelStruct JsonExpr))
(define (melstruct->hashmap h)
  (match h
    [(CoinID txhash index)
     `#hasheq((txhash . ,txhash)
              (index  . ,index))]
    [(CoinData covhash value denom additional-data)
     `#hasheq((covhash . ,covhash)
              (value   . ,value)
              (denom   . ,denom)
              (additional_data . ,additional-data))]
    [(CoinDataHeight coin-data height)
     `#hasheq((coin_data . ,(melstruct->hashmap coin-data))
              (height    . ,height))]
    [(Transaction kind inputs outputs fee scripts data sigs)
     `#hasheq((kind    . ,kind)
              (inputs  . ,(melstruct->hashmap inputs))
              (outputs . ,(melstruct->hashmap outputs))
              (fee     . ,fee)
              (scripts . ,scripts)
              (data    . ,data)
              (sigs    . ,sigs))]
    [(CovEnv coin-id coin-data-height spender-index last-header)
     `#hasheq((parent_coinid . ,(melstruct->hashmap coin-id))
              (parent_cdh    . ,(melstruct->hashmap coin-data-height))
              (spender_index   . ,spender-index)
              (last_header   . ,(melstruct->hashmap last-header)))]
    ;; last case in another function, just for illustration
    [(? Header? head) (header->hashmap h)]
    [(? list? other)
     ;; compiler knows that other is of type (Listof MelStruct)
     (map melstruct->hashmap other)]))

(define-type JsonExpr
  (U Boolean
     String
     Integer
     (Listof JsonExpr)
     (HashTable Symbol JsonExpr)))

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
