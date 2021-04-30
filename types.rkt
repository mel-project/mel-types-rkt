#lang typed/racket

(require json-comb)

;(provide (struct-out CoinID) CoinID-txhash CoinID-index)
(provide (struct-out CoinID)
         (struct-out CoinDataHeight)
         (struct-out Header)
         (struct-out CovEnv)
         (struct-out Transaction)
         (struct-out CoinData))

(define-json-types
[CoinID ([txhash : String]
         [index : Integer])]

[CoinData ([covhash : String]
           [value : Integer]
           [denom : String]
           [additional_data : String])]

[CoinDataHeight ([coin-data : CoinData]
                 [height : Integer])]

[Header ([network : Integer]
         [previous : String]
         [height : Integer]
         [history-hash : String]
         [coins-hash : String]
         [transactions-hash : String]
         [fee-pool : Integer]
         [fee-multiplier : Integer]
         [dosc-speed : Integer]
         [pools-hash : String]
         [stakes-hash : String])]

[CovEnv ([coin-id : CoinID]
         [coin-data-height : CoinDataHeight]
         [spender-index : Integer]
         [last-header : Header])]

[Transaction ([kind : Integer]
              [inputs : (Listof CoinID)]
              [outputs : (Listof CoinData)]
              [fee : Integer]
              [scripts : (Listof String)]
              [data : String]
              [sigs : (Listof String)])])
