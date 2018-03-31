(require-package 'exwm)
(require-package 'xelb)

;; (exwm-config-default)

;; (exwm-config-misc)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode 1)


(setq display-time-default-load-average nil)
(display-time-mode t)

(ido-mode 1)

(require 'exwm)

(require 'exwm-config)
(exwm-config-ido)

(setq exwm-workspace-number 3)

(add-hook 'exwm-update-class-hook
	  (lambda ()
	    (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
			(string= "gimp" exwm-instance-name))
	      (exwm-workspace-rename-buffer exwm-class-name))))

(add-hook 'exwm-update-title-hook
	  (lambda ()
	    (when (or (not exwm-instance-name)
		      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
		      (string= "gimp" exwm-instance-name))
	      (exwm-workspace-rename-buffer exwm-title))))

(setq exwm-input-global-keys
      `(
	([?\s-r] . exwm-reset)
	([?\s-w] . exwm-workspace-switch)
	,@(mapcar (lambda (i)
		    `(,(kbd (format "s-%d" i))
		      (lambda ()
			(interactive)
			(exwm-workspace-switch-create ,i))))
		  (number-sequence 0 9))
	([?\s-&] . (lambda (command)
		     (interactive (list (read-shell-command "$ ")))
		     (start-process-shell-command command nil command)))))

(define-key exwm-mode-map [?\C-q] #'exwm-input-send-next-key)

(setq exwm-input-set-simulation-keys
      '(
	;; movement
	([?\C-b] . [left])
	([?\C-f] . [right])
	([?\C-p] . [up])
	([?\C-n] . [down])
	([?\C-a] . [home])
	([?\C-e] . [end])
	([?\M-v] . [prior])
	([?\C-v] . [next])
	([?\C-d] . [delete])
	([?\C-k] . [S-end delete])
	;; cut/paste
	([?\C-w] . [?\C-x])
	([?\M-w] . [?\C-c])
	([?\C-y] . [?\C-v])
	;; search
	([?\C-s] . [?\C-f])))

;; (setq exwm-workspace-minibuffer-position 'bottom)
;; (setq exwm-workspace-display-echo-area-timeout 3)

(require 'exwm-randr)
(setq exwm-randr-workspace-output-plist '(0 "HDMI1"))
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (start-process-shell-command
             "xrandr" nil "xrandr --output HDMI1 --left-of eDP1 --auto")))
(exwm-randr-enable)

;; (require 'exwm-cm)
;; (setq window-system-default-frame-alist '((x . ((alpha . 100)))))
;; (setq exwm-cm-opacity 80)
;; (exwm-cm-enable)

;; (require 'exwm-systemtray)
;; (exwm-systemtray-enable)

(exwm-enable)

;; (start-process "" nil "ibus-daemon" "-drx")
;; (start-process "" nil "fcitx" "-d" "-r")

(provide 'init-exwm)
