#lang racket

(require json)
(require "types.rkt")

(provide coinid->hashmap
         coindata->hashmap
         coindataheight->hashmap
         header->hashmap
         transaction->hashmap)

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
           (height    . ,(CoinDataHeight-height))))

(define (transaction->hashmap t)
  `#hasheq((kind    . (Transaction-kind t))
           (inputs  . (Transaction-inputs t))
           (outputs . (Transaction-outputs t))
           (fee     . (Transaction-fee t))
           (scripts . (Transaction-scripts t))
           (data    . (Transaction-data t))
           (sigs    . (Transaction-sigs t))))

(define (covenv->hashmap e)
  `#hasheq((parent_coinid . (coinid->hashmap (CovEnv-coin-id e)))
           (parent_cdh    . (coindataheight->hashmap (CovEnv-coin-data-height e)))
           (spender_idx   . (CovEnv-spender-index e))
           (last_header   . (header->hashmap (CovEnv-last-header e)))))

(define (header->hashmap e)
  `#hasheq((network           . (Header-network e))
           (previous          . (Header-previous e))
           (height            . (Header-height e))
           (history_hash      . (Header-history-hash e))
           (coins_hash        . (Header-coins-hash e))
           (transactions_hash . (Header-transactions-hash e))
           (fee_pool          . (Header-fee-pool e))
           (fee_multiplier    . (Header-fee-multiplier e))
           (dosc_speed        . (Header-dosc-speed e))
           (pools_hash        . (Header-pools-hash e))
           (stakes_hash       . (Header-stakes-hash e))))
