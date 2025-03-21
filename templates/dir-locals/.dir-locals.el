;;; Exsample of Directory Local Variables  -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")


(
 ;; for TypesCript
 (jtsx-typescript-mode . ((eval . (lsp-deferred))
													(eval . (eglot-ensure))
													(eval . (apheleia-mode))))

 ;; for tsx
 (jtsx-tsx-mode . ((eval . (lsp-deferred))
									 (eval . (eglot-ensure))
									 (eval . (apheleia-mode))))

 ;; for JavaScript and jsx
 (jtsx-jsx-mode . ((eval . (eglot-ensure))
									 (eval . (lsp-deferred))
									 (eval . (apheleia-mode))))

 ;; for Astro
 (astro-ts-mode . ((eglot-server-programs . ((astro-ts-mode . ("astro-ls" "--stdio"
																															 :initializationOptions
																															 (:typescript
																																(:tsdk "/PATH/TO/typescript/lib"))))))
									 (eval . (eglot-ensure))
									 (eval . (apheleia-mode))))

 ;; for yaml
 (eglot-workspace-configuration . (:yaml ( :format (:enable t)
																					 :validate t
																					 :hover t
																					 :completion t
																					 ;; ここに一覧がある
																					 ;; https://github.com/SchemaStore/schemastore/blob/master/src/api/json/catalog.json
																					 :schemas
																					 ( https://json.schemastore.org/yamllint.json ["/*.yml"]
																				  	 https://json.schemastore.org/github-workflow.json ["/.github/workflows/*.{yml,yaml}"]
																						 https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json ["/PATH/TO.{yml,yaml}"]
																						 https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json ["/PATH/TO.{yml,yaml}"]
																						 )
																					 :schemaStore (:enable t))))
 ;; for Blade
 (php-ts-mode . ((apheleia-formatters . (prettier-blade
																				 . ("apheleia-npx" "prettier" "--stdin-filepath" filepath
																						"--plugin=@shufo/prettier-plugin-blade" "--parser=blade"
																						"--tab-width=2" "--print-width=160" "--sort-html-attributes=code-guide")))
								 (apheleia-mode-alist . ((php-ts-mode . prettier-blade)))
								 (eval . (apheleia-mode))))

 )
