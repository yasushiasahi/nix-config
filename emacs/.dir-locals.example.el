;;; Exsample of Directory Local Variables  -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((jtsx-jsx-mode . ((eval . (eglot-ensure))
									 (eval . (apheleia-mode))))
 (php-ts-mode . ((apheleia-formatters . (prettier-blade
																				 . ("apheleia-npx" "prettier" "--stdin-filepath" filepath
																						"--plugin=@shufo/prettier-plugin-blade" "--parser=blade"
																						"--tab-width=2" "--print-width=160" "--sort-html-attributes=code-guide")))
								 (apheleia-mode-alist . ((php-ts-mode . prettier-blade)))
								 (eval . (apheleia-mode))))
 (astro-ts-mode . ((eglot-server-programs . ((astro-ts-mode . ("astro-ls" "--stdio"
																															 :initializationOptions
																															 (:typescript
																																(:tsdk "/PATH/TO/typescript/lib"))))))
									 (eval . (eglot-ensure))
									 (eval . (apheleia-mode))))
 (jtsx-typescript-mode . ((eval . (eglot-ensure))
													(eval . (apheleia-mode))))
 (jtsx-tsx-mode . ((eval . (lsp-deferred))
									 (eval . (apheleia-mode)))))
