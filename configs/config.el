;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'tango-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; Load sensitive calendar configurations locally if the file exists

;;ORG-GCAL
(let ((secrets-file (expand-file-name "secrets.el" doom-private-dir)))
  (when (file-exists-p secrets-file)
    (load secrets-file)))

;; NYAN-CAT :)
(use-package! nyan-mode
  :init
  (nyan-mode 1)
  :config
  (setq nyan-wavy-trail t
        nyan-animate-nyancat t))

;; GOOGLE TASKS CONFIG
;; ==============================================================================================

(load! "secrets.el")

(use-package! gtasks
  :config
  (setq gtasks-token-directory (expand-file-name "~/.config/emacs/.gtasks/")
        gtasks-client-id my-gtasks-client-id
        gtasks-client-secret my-gtasks-client-secret))

(after! gtasks
  (defvar my-gtasks-ui-list-name "My Tasks"
    "The default list to load in the UI. Must match the exact name in Google Tasks.")

  (defvar-local my-gtasks-ui-current-list-id nil
    "Internal variable to cache the current list ID.")

  (define-derived-mode my-gtasks-ui-mode tabulated-list-mode "GTasks"
    "Interactive major mode for managing Google Tasks."
    (setq tabulated-list-format [("Status" 8 t)
                                 ("Task Title" 0 nil)])
    (setq tabulated-list-padding 2)
    (tabulated-list-init-header))

  (defun my-gtasks-ui-refresh ()
    "Fetch tasks from Google and update the dashboard."
    (interactive)
    (unless my-gtasks-ui-current-list-id
      (setq my-gtasks-ui-current-list-id (gtasks-list-id-by-title my-gtasks-ui-list-name)))

    (message "Syncing with Google Tasks...")
    (let* ((response (gtasks-task-list my-gtasks-ui-current-list-id))
           (tasks (plist-get response :items))
           (entries nil))
      (dolist (task tasks)
        (let* ((id (plist-get task :id))
               (title (plist-get task :title))
               (status (plist-get task :status)))
          (when (string= status "needsAction")
            (push (list id (vector "[ ]" title)) entries))))

      (setq tabulated-list-entries (nreverse entries))
      (tabulated-list-print t)
      (message "Tasks synced!")))

  (defun my-gtasks-ui-complete ()
    "Mark the task currently under the cursor as complete."
    (interactive)
    (let ((task-id (tabulated-list-get-id)))
      (if task-id
          (progn
            (message "Checking off task...")
            (gtasks-task-complete my-gtasks-ui-current-list-id task-id)
            (my-gtasks-ui-refresh))
        (user-error "No task found at cursor position"))))

  (defun my-gtasks-ui-add (title)
    "Prompt for a new task, send it to Google, and refresh the dashboard."
    (interactive "sNew task: ")
    (unless my-gtasks-ui-current-list-id
      (setq my-gtasks-ui-current-list-id (gtasks-list-id-by-title my-gtasks-ui-list-name)))
    (message "Adding task...")
    (gtasks-task-insert my-gtasks-ui-current-list-id (list :title title))
    (my-gtasks-ui-refresh))

   (map! :map my-gtasks-ui-mode-map
        :n "c"   #'my-gtasks-ui-complete
        :n "RET" #'my-gtasks-ui-complete
        :n "a"   #'my-gtasks-ui-add
        :n "g"   #'my-gtasks-ui-refresh
        :n "q"   #'quit-window)) ;

(defun my-gtasks-dashboard ()
  "Open the interactive Google Tasks dashboard."
  (interactive)
  (let ((buf (get-buffer-create "*Google Tasks Dashboard*")))
    (with-current-buffer buf
      (my-gtasks-ui-mode)
      (my-gtasks-ui-refresh))
    (switch-to-buffer buf)))

;; CUSTOM GOOGLE KEYBINDINGS
;; ==============================================================================================
(map! :leader
      (:prefix-map ("g" . "google")
       :desc "Google Tasks Dashboard" "t" #'my-gtasks-dashboard
       :desc "Google Calendar"        "c" #'cfw:open-org-calendar)) ; Or your specific calendar command
