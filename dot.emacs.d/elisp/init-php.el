(autoload 'php-mode "php-mode")
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

(add-hook 'php-mode-hook
					(lambda ()
						(c-set-style "stroustrup")
						(c-set-offset 'arglist-cont 0)
						(c-set-offset 'arglist-intro '+)
						(c-set-offset 'arglist-close 0)
						(c-set-offset 'case-label '+)
						(setq indent-tabs-mode nil)
						(setq fill-column 78)
						; インデントは2文字
						(setq c-basic-offset 4)

						;; php-completion.el
						(require 'php-completion)
						(php-completion-mode t)
						(define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
						(make-variable-buffer-local 'ac-sources)
						(add-to-list 'ac-sources 'ac-source-php-completion)
))
