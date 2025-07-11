
;; bet-logic-contract
;; A decentralized betting contract for STX price predictions within specified time frames
;; Users can bet on whether STX price will rise or drop within a given duration

;; constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INVALID_BET_AMOUNT (err u101))
(define-constant ERR_INVALID_DURATION (err u102))
(define-constant ERR_BET_NOT_FOUND (err u103))
(define-constant ERR_BET_ALREADY_RESOLVED (err u104))
(define-constant ERR_BET_NOT_EXPIRED (err u105))
(define-constant ERR_INSUFFICIENT_BALANCE (err u106))
(define-constant ERR_INVALID_PREDICTION (err u107))
(define-constant ERR_ORACLE_ERROR (err u108))
(define-constant ERR_WITHDRAWAL_FAILED (err u109))

;; Betting parameters
(define-constant MIN_BET_AMOUNT u100000) ;; 0.1 STX in microSTX
(define-constant MAX_BET_AMOUNT u100000000000) ;; 100,000 STX in microSTX
(define-constant MIN_DURATION u3600) ;; 1 hour in seconds
(define-constant MAX_DURATION u2592000) ;; 30 days in seconds
(define-constant HOUSE_EDGE u300) ;; 3% house edge (300 basis points)
(define-constant BASIS_POINTS u10000) ;; 100% = 10,000 basis points

;; Bet outcomes
(define-constant BET_OUTCOME_PENDING u0)
(define-constant BET_OUTCOME_WIN u1)
(define-constant BET_OUTCOME_LOSE u2)
(define-constant BET_OUTCOME_DRAW u3)

;; Prediction types
(define-constant PREDICTION_RISE u1)
(define-constant PREDICTION_DROP u2)

;; Oracle and timing
(define-constant ORACLE_TOLERANCE u300) ;; 5 minutes tolerance for price fetching
(define-constant RESOLUTION_WINDOW u86400) ;; 24 hours window to resolve expired bets

;; data maps and vars
;;

;; private functions
;;

;; public functions
;;
