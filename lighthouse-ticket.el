(require 'lighthouse-util)

(defun lighthouse-display-ticket (ticket)
  (switch-to-buffer (get-buffer-create "Lighthouse"))
  (save-excursion
    (let ((title (plist-get ticket :title))
          (number (plist-get ticket :number))
          (created_by (plist-get ticket :creator_name))
          (state (plist-get ticket :state))
          (created_at (plist-get ticket :created_at)))
      (lighthouse-insert-ticket-header ticket)
      (insert "\n\n")
      (lighthouse-insert-ticket-subheader ticket)
      (insert "\n\n")
      (lighthouse-insert-ticket-body ticket)
      (insert "\n\n=====================================")
      (insert "=====================================\n\n")
      (lighthouse-insert-ticket-versions ticket)
      (insert "\n")
      (insert-button "UPDATE TICKET" 'action 'lighthouse-update-ticket)
      )))

(defun lighthouse-insert-ticket-header (ticket)
  (let ((number (plist-get ticket :number))
        (title (plist-get ticket :title))
        (state (plist-get ticket :state))
        (fill-column 80))
    (insert (concat "#" (number-to-string number) ": "))
    (insert title)
    (insert (concat " (state: " state ")"))))

(defun lighthouse-insert-ticket-subheader (ticket)
  (let ((creator (plist-get ticket :creator_name))
        (created_at (plist-get ticket :created_at))
        (milestone (plist-get ticket :milestone_title))
        (fill-column 80))
    (insert (concat "Reported By: " creator " | "))
    (insert (concat created_at " | "))
    (insert (concat "in " milestone))))

(defun lighthouse-insert-ticket-body (ticket)
  (let ((body (replace-regexp-in-string "\r\n" "\n" (plist-get ticket :body)))
        (attachments (plist-get ticket :attachments_count))
        (begin (point))
        (fill-column 80))
    (insert body)
    (fill-region begin (point) 'left)
    (insert (concat "\n\n\nAttachments: " (number-to-string attachments)
                    ))))

(defun lighthouse-insert-ticket-versions (ticket)
  (let ((versions (plist-get ticket :versions)))
    (insert "Comments & Changes to This Ticket\n\n")
    (map 'list (lambda (version)
                 "List all ticket versions except the first"
                 (unless (eq (plist-get version :version) 1)
                   (lighthouse-insert-ticket-version version)
                   (insert "\n\n-------------------------------------")
                   (insert "-------------------------------------\n\n"))) versions)))

(defun lighthouse-insert-ticket-version (version)
  (let ((updated_by (plist-get version :user_name))
        (updated_at (plist-get version :created_at))
        (body (replace-regexp-in-string "\r\n" "\n" (plist-get version :body)))
        (state (plist-get version :state))
        (assigned_to (plist-get version :assigned_user_name))
        (begin (point))
        (fill-column 80))
    (insert updated_by)
    (insert (concat " | " updated_at " | "))
    (insert (concat "state: " state "\n\n"))
    (insert body)
    (insert (concat "\n\nAssigned To: " assigned_to))
    (fill-region begin (point) 'left))
  )

(provide 'lighthouse-ticket)