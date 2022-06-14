;; Place your bindings here.

;; For example:
;;(define-key global-map (kbd "C-+") 'text-scale-increase)
;;(define-key global-map (kbd "C--") 'text-scale-decrease)

(windmove-default-keybindings)

(global-set-key (kbd "M-S-<left>")  'windmove-left)
(global-set-key (kbd "M-S-<right>") 'windmove-right)
(global-set-key (kbd "M-S-<up>")    'windmove-up)
(global-set-key (kbd "M-S-<down>")  'windmove-down)


;; magit
(global-set-key (kbd "M-g") 'magit-status)
