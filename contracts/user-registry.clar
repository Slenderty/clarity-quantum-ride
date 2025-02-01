;; QuantumRide - User Registry Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))

;; Data vars
(define-map users
  principal
  {
    role: (string-ascii 10),
    rating: uint,
    total-rides: uint,
    active: bool
  }
)

;; Public functions
(define-public (register-user (role (string-ascii 10)))
  (ok (map-set users
    tx-sender
    {
      role: role,
      rating: u0,
      total-rides: u0,
      active: true
    }))
)

(define-public (update-rating (user principal) (new-rating uint))
  (let ((existing-user (unwrap! (map-get? users user) (err u404))))
    (ok (map-set users
      user
      (merge existing-user {
        rating: new-rating
      })))
  )
)
