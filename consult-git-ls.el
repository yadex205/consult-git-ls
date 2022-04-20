;;; consult-git-ls.el --- Do `git ls-files` via Consult interface -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Kanon Kakuno

;; Author: Kanon Kakuno <yadex205@outlook.jp>
;; Homepage: https://github.com/yadex205/consult-git-ls
;; Package-Requires: ((emacs "27.1") (consult "0.16"))
;; SPDX-License-Identifier: MIT
;; Version: 0.1.0

;; This file is not part of GNU Emacs.

;;; Commentary:

;; consult-git-ls provides the `git ls-files` feature for Consult.
;; To use this, run `consult-git-ls`.

;;; Code:

(require 'consult)

(defun consult-git-ls--state ()
  "Not documented."
  (let ((open (consult--temporary-files))
        (jump (consult--jump-state)))
    (lambda (action cand)
      (unless cand
        (funcall open nil))
      (funcall jump action (consult--position-marker (funcall (or open #'find-file) cand) 0 0)))))

;;;###autoload
(defun consult-git-ls (&optional initial)
  "Consult git-ls for query with INITIAL input."
  (interactive)
  (let* ((raw-git-ls-files-result (shell-command-to-string "git ls-files --full-name"))
         (candidates (split-string raw-git-ls-files-result "\n\\|\r\\|\r\n"))
         (prompt-dir (consult--directory-prompt "Consult git-ls: " nil)))
    (consult--read candidates
                   :prompt (car prompt-dir)
                   :lookup #'consult--lookup-member
                   :state (consult-git-ls--state)
                   :initial initial
                   :require-match t
                   :category 'file
                   :sort nil)))

(provide 'consult-git-ls)

;;; consult-git-ls.el ends here
