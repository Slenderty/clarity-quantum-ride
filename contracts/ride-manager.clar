;; QuantumRide - Ride Manager Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-invalid-state (err u101))
(define-constant err-insufficient-funds (err u102))

;; Data vars
(define-map rides
  { ride-id: uint }
  {
    rider: principal,
    driver: (optional principal),
    pickup: (string-utf8 100),
    destination: (string-utf8 100),
    fare: uint,
    status: (string-ascii 20)
  }
)

(define-data-var ride-counter uint u0)

;; Public functions
(define-public (request-ride (pickup (string-utf8 100)) (destination (string-utf8 100)) (fare uint))
  (let ((ride-id (var-get ride-counter)))
    (map-insert rides
      { ride-id: ride-id }
      {
        rider: tx-sender,
        driver: none,
        pickup: pickup,
        destination: destination,
        fare: fare,
        status: "REQUESTED"
      }
    )
    (var-set ride-counter (+ ride-id u1))
    (ok ride-id))
)

(define-public (accept-ride (ride-id uint))
  (let ((ride (unwrap! (map-get? rides { ride-id: ride-id }) (err u404))))
    (asserts! (is-eq (get status ride) "REQUESTED") err-invalid-state)
    (ok (map-set rides
      { ride-id: ride-id }
      (merge ride { 
        driver: (some tx-sender),
        status: "ACCEPTED"
      })))
  )
)
