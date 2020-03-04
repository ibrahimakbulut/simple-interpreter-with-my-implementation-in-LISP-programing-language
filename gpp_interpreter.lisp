





(defun gpp_lexer(file_or_line)

(setq KEYWORDS '( "and" "or" "not" "equal" "less" "nil" "list" "append" "concat"
"set" "deffun" "for" "if" "exit" "load" "disp" "true" "false") )
(setq OPERATORS '( "+" "-" "/" "*" "(" ")" "**"  ","))
(setq KEYWORDS_TOKENS '( "KW_AND" "KW_OR" "KW_NOT" "KW_EQUAL" "KW_LESS" "KW_NIL" 
"KW_LIST" "KW_APPEND" "KW_CONCAT" "KW_SET" "KW_DEFFUN" "KW_FOR" "KW_IF" "KW_EXIT" "KW_LOAD" "KW_DISP" "KW_TRUE" "KW_FALSE"))
(setq OPERATORS_TOKENS  '("OP_PLUS" "OP_MINUS" "OP_DIV" "OP_MULTIP" "OP_OP" "OP_CP" "OP_DBLEMULTIP" "OP_COMMA" "OP_OC" "OP_CC")        )
(setq result_list '())
(setq temp_list file_or_line)

(defun from-list-to-string (listt)  ;;Convert a list to string
    (format nil "~{~A~}" listt))





(setq there_is_quatation 0)

(loop 


(if (or (and (< (char-code (car temp_list)) 123) (> (char-code (car temp_list)) 96) ) (and (< (char-code (car temp_list)) 91) (> (char-code (car temp_list)) 64) ) ) ;if firs char is a letter

	(progn 
		(setq word '())
		(loop 


   			(when  (or (equal  (char-code (car temp_list)) 32)  (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) word)
    		(setq temp_list (cdr temp_list))

		)
		(setq word (reverse word))
		(setq tokenized 1)
		(setq temp_word word)
		(loop 


			(when (null temp_word) (return nil))
			(if  (not (or (and (< (char-code (car temp_word)) 123) (> (char-code (car temp_word)) 96) ) (and (< (char-code (car temp_word)) 91) (> (char-code (car temp_word)) 64) ) (and (< (char-code (car temp_word)) 58) (> (char-code (car temp_word)) 47) )               )  ) 

				(setq tokenized 0)
			

			)
			(setq temp_word (cdr temp_word))


		)

		(if (= tokenized 1)
		
			(progn
		(setq keyword_temp KEYWORDS)
		(setq token_temp KEYWORDS_TOKENS)
		(setq y 0)
		(loop

			(when (or (null  keyword_temp)) (return nil))
			(if (equal (car keyword_temp) (from-list-to-string word))(progn
			(setq result_list  (nconc result_list (list (car token_temp))) ) ;is word a keyword not identifier 
			(setq result_list  (nconc result_list (list (from-list-to-string word))      ) )
			;(print (car token_temp))
			(setq y 1))

			)
			(setq keyword_temp (cdr keyword_temp))
			(setq token_temp (cdr token_temp))
		)	
			(if (equal y 0)
			(progn
			(setq result_list  (nconc result_list (list "IDENTIFIER") ) )
			(setq result_list  (nconc result_list (list (from-list-to-string word))      ) )
			;(print "IDENTIFIER")
			)
			)
		)
			(progn
			(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR " (from-list-to-string word) ) " cannot be tokenized"  ) )) )
			(print (concatenate 'string (concatenate 'string "SYNTAX ERROR " (from-list-to-string word) ) " cannot be tokenized"  ))
			(exit 1)
			)
		)
	)
		
)

(if  (and (< (char-code (car temp_list)) 58) (> (char-code (car temp_list)) 47) ) ;if firs character is digit 
	(progn
		(setq number '())
		(loop 

   			
			(when (or (equal  (char-code (car temp_list)) 32) (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 40) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) number)
    		(setq temp_list (cdr temp_list))

		)


		(setq temp_number number)
		(setq tokenized_number 1)

		(loop 


			(when (null (cdr temp_number) ) (return temp_list))
			(if  (not (and (< (char-code (car temp_number)) 58) (> (char-code (car temp_number)) 47) )  ) 
				(progn
				(setq tokenized_number 0)
				)
			)
			(setq temp_number (cdr temp_number))


		)
		(setq number (reverse number))
		(if (= tokenized_number 1)

		(if (and (=  (char-code (car number)) 48 ) (> (list-length number) 1) )
			(progn
			(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ) )     )     )
			(print (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ))
			(exit 1)
			)
			(progn
			(setq result_list  (append result_list (list "VALUE" ) ) ) ; VALUE added lexer output list
			(setq result_list  (append result_list (list (from-list-to-string number) ) ) )
			;(print "VALUE")
			)
		)
		(progn
		(setq result_list (append result_list (list (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ) )     )     )
		(print (concatenate 'string (concatenate 'string "SYNTAX ERROR "  (from-list-to-string number)) " cannot be tokenized" ))
		(exit 1)
		)
		)
	)
)

(if (and   (not (or (and (< (char-code (car temp_list)) 123) (> (char-code (car temp_list)) 96) ) (and (< (char-code (car temp_list)) 91) (> (char-code (car temp_list)) 64) ) )) (not (equal (char-code (car temp_list)) 10) )  (not (and (< (char-code (car temp_list)) 58) (> (char-code (car temp_list)) 47) )) (not (equal (char-code (car temp_list)) 32)))

	(cond 

			( (and (= (char-code (car temp_list)) 59) (= (char-code (car (cdr temp_list))) 59) )

			(progn
			
			(loop 

				(when  (equal  (char-code (car temp_list)) 10) (equal  (char-code (car temp_list)) 34)(return  temp_list))
    			(setq temp_list (cdr temp_list))
			)
			(setq result_list (append result_list (list "COMMENT")))
			(setq result_list (append result_list (list ";;")))
			;(print "COMMENT")
			)
			)


			(
				(= (char-code (car temp_list)) 34)

				(if (= there_is_quatation 0)
					(progn

						(setq result_list (append result_list (list "OP_OC")))
						(setq result_list (append result_list (list "quote")))
						;(print "OP_OC")
						(setq there_is_quatation 1)
					)
					(progn

					(setq result_list (append result_list (list "OP_CC")))
					(setq result_list (append result_list (list "quote")))
					;(print "OP_CC")
					(setq there_is_quatation 0)
					)


				)
			)

			( (or (= (char-code (car temp_list)) 40) (= (char-code (car temp_list)) 41))

				(if (= (char-code (car temp_list)) 40)
					(progn
					(setq result_list (append result_list (list "OP_OP")))
					(setq result_list (append result_list (list "(")))
					;(print "OP_OP")
					)
					(progn
					(setq result_list (append result_list (list "OP_CP")))
					(setq result_list (append result_list (list ")")))
					;(print "OP_CP")
					)
				)

			)


			( t      
			(progn

			(setq operator_temp '())
			(loop 

   			
			(when (or (equal  (char-code (car temp_list)) 32) (equal (char-code (car temp_list)) 41) (equal (char-code (car temp_list)) 40) (equal (char-code (car temp_list)) 10) (equal (char-code (car temp_list)) 34)) (return  temp_list))
    		(push  (car temp_list) operator_temp)
    		(setq temp_list (cdr temp_list))

			)
			(setq operator_temp (reverse operator_temp))

			(if  (or (= (char-code (car temp_list)) 40) (= (char-code (car temp_list)) 41) (= (char-code (car temp_list)) 34)    )

				(push (car temp_list) temp_list)


			)

			(cond
				( 
					(= (list-length operator_temp) 2)

					(if (and (= (char-code (car operator_temp )) 42) (= (char-code (car (cdr operator_temp)) ) 42))
						(progn
							(setq result_list (append result_list (list "OP_DBLEMULTIP")) )
							(setq result_list (append result_list (list "**")) )
							;(print "OP_DBLEMULTIP")
						)
						(progn

							(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) "cannot be tokenized")))))
							(print  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized")))
							(exit 1)
						)


					)

				)


				(  
					(> (list-length operator_temp) 2)


					(progn
					(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) "cannot be tokenized")))))
					(print   (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized")))
					(exit 1)

					)


				)


				( t

			(progn
			(setq token_operator_temp OPERATORS_TOKENS)
			(setq operator_tempp OPERATORS)

			(setq is_operator nil)

			(loop
				(if (equal (car operator_tempp) (from-list-to-string operator_temp))
				(progn
				(setq is_operator t)
				(setq result_list  (nconc result_list (list (car token_operator_temp))) ) ;is operator
				(setq result_list  (nconc result_list (list (car operator_tempp))) )
				(print (car token_operator_temp))
				)
				)
				(when (or (null (cdr operator_tempp) ) (equal (car operator_tempp) (from-list-to-string operator_temp))) (return nil))
				(setq operator_tempp (cdr operator_tempp))
				(setq token_operator_temp (cdr token_operator_temp))
			)
			(if (equal is_operator nil)
				(progn
				(setq result_list (append result_list (list  (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized") ))))
				(print (concatenate 'string "SYNTAX ERROR " (concatenate 'string (from-list-to-string operator_temp) " cannot be tokenized") ) )
				(exit 1)
				)
			)
			)

			)
			)


			)
			)


			)
	
)

   (when (null  (cdr temp_list) ) (return result_list))
       (setq temp_list (cdr temp_list))

	)
result_list
	)
 	
(defvar EXPLISTI '( ("(" "concat" "EXPLISTI" "EXPLISTI" ")") 
					("(" "append" "EXPI" "EXPLISTI" ")") ("null") 
					("LISTVALUE")) )

(defvar EXPI '( ("(" "+" "EXPI" "EXPI" ")") ("(" "-" "EXPI" "EXPI" ")") 
				("(" "*" "EXPI" "EXPI" ")") ("(" "/" "EXPI" "EXPI" ")") 
				("Identifier") 
				("(" "Identifier" "EXPLISTI" ")") 
				("IntegerValue")
				("(" "deffun" "Identifier" "IDLIST" "EXPLISTI" ")")    
				("(" "set" "Identifier" "EXPI" ")") 
				("(" "defvar" "Identifier" "EXPI" ")") 
				("(" "if" "EXPB" "EXPLISTI" "EXPLISTI" ")") 
				("(" "if" "EXPB" "EXPLISTI" "EXPLISTI" "EXPLISTI" ")") 
				("(" "while" "(" "EXPB" ")" "EXPLISTI" ")" ) 
				("(" "for"  "(" "Identifier" "EXPI" "EXPI" ")" "EXPLISTI" ")")  ))

(defvar EXPB '( ("(" "and" "EXPB" "EXPB" ")") ("(" "or" "EXPB" "EXPB" ")") 
				("(" "equal" "EXPB" "EXPB" ")") ("(" "equal" "EXPI" "EXPI" ")")
				("(" "not" "EXPB" ")") ("BinaryValue") ))

(defvar VALUES '( ("IntegerValue") ("VALUES" "IntegerValue") ))

(defvar LISTVALUES     '( ("'" "(" "VALUES" ")") ( "'" "(" ")") ("null") )  )	 

(defvar IDLIST '(("(" "Identifier" ")") ("Identifier" "IDLIST") ("Identifier")))





(defun helper_interpreter (token_stream)

	(let (   (copy_token_stream token_stream) (kinds_of_parameters '()) (there_is_operator 0) (parameters '()) (before_op 0) (return_of_recursives '() ) (total_tokens 0) (operator_what 0) (is_finished 0)  (first_tour 1) (end_of_exp 0) )

		(progn
			
		(loop

		
			(when (null copy_token_stream)(return nil) )


			(cond

			(    (string-equal (car copy_token_stream) "IDENTIFIER") 


				(progn

				(if (= there_is_operator 1)

				( progn
					(push (cadr copy_token_stream) parameters)
					(push "IDENTIFIER" kinds_of_parameters)
					(setq total_tokens (+ total_tokens 2))

				)
				(progn
				(print "gppinterpreter : there must be a operation before ")
				(exit 1)
				)
				)
				(setq before_op 0)
				)

			)
			(   (string-equal (car copy_token_stream) "VALUE") 

				(progn

				(if (= there_is_operator 1)

				( progn
					(push (parse-integer (cadr copy_token_stream) ) parameters)
					(push "VALUE" kinds_of_parameters)
					(setq total_tokens (+ total_tokens 2))

				)
				(progn
				(print "gppinterpreter :  there must be a operation before ")
				(exit 1)
				)
				)
				(setq before_op 0)
				)

			)


			(  (or (string-equal (car copy_token_stream) "KW_TRUE") (string-equal (car copy_token_stream) "KW_FALSE") )

				(progn

				(if (= there_is_operator 1)

				( progn
					(if (string-equal (car copy_token_stream) "KW_TRUE")
						(push t parameters)
						(push nil parameters)
					)
					(push "binary" kinds_of_parameters)
					(setq total_tokens (+ total_tokens 2))

				)
				(progn
				(print "gppinterpreter :  there must be a operation before ")
				(exit 1)
				)
				)
				(setq before_op 0)
				)

			)

			( (string-equal (car copy_token_stream) "OP_OP")   ;eger ard arda iki acilan parentez varsa bunu belirle

				(cond (  (= first_tour 1) 
						(progn
						(setq first_tour 0)
						)
					  )
					  ( t
				(if (= there_is_operator 1)

				(progn
				(setq  return_of_recursives (helper_interpreter   copy_token_stream)) 
				(push (nth 0 return_of_recursives) parameters)
				(push "VALUE" kinds_of_parameters)
				(setq copy_token_stream (subseq copy_token_stream    (nth 1 return_of_recursives)    )) ;kac ilerledigi bul
				(setq total_tokens (+ total_tokens   (nth 1 return_of_recursives)  2) )

				)

				(progn

					(print "gppinterpreter : SEMANTIC error ")
					(exit 1)

				)

				)
				)
				)

			)

			(    (and (not (string-equal (car copy_token_stream) "OP_OP"))  (not (string-equal (car copy_token_stream) "OP_CP")) (not (string-equal (car copy_token_stream) "OP_OC")) (not (string-equal (car copy_token_stream) "OP_CC")) (not (string-equal (car copy_token_stream) "IDENTIFIER")) (not (string-equal (car copy_token_stream) "VALUE"))      )     

				(progn
				(setq operator_what (car copy_token_stream))
				(setq total_tokens (+ total_tokens 2))
				(setq there_is_operator 1)
				)

			)			

			( (string-equal (car copy_token_stream) "OP_CP")
				(progn 

				(if (= first_tour 1)
					(progn
					(print "gppinterpreter : SEMANTIC error :- unnecessary (")
					(exit 1)
					)
				)
				(setq total_tokens (+ total_tokens 2))
				(setq end_of_exp (+ end_of_exp 1))
				(cond

					( (string-equal operator_what "OP_PLUS")

					(progn



					(setq parameters (reverse parameters))
					(setq kinds_of_parameters (reverse kinds_of_parameters))

					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  )


							(if (= parameters_number 0)

							(progn
								(print "There is no parameter for PLUS OPERATOR")
								(exit 1)
							)

							)	
					(loop

						(when (=  counter parameters_number) (return nil) )

						(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

							(progn

								(if (not (gethash (car parameters) variables) )
									(progn

										(print (car parameters) )
										(print "has no value.")
										(exit 1)
									)
									(setq result (+ result  (gethash (car parameters) variables)))
								)

							)

							(if (string-equal (car kinds_of_parameters) "binary")

								(progn
									(print "+ is not defined over binaries")
									(exit 1)
								)

								(setq result (+ result  (car parameters)))
							)
						)

						
						(setq counter (+ counter 1))
						(setq parameters (cdr parameters))
						(setq kinds_of_parameters (cdr kinds_of_parameters))
				
					)
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)

					)

					)

					( (string-equal operator_what "OP_MINUS")

					(progn


					(setq parameters (reverse parameters))
					(setq kinds_of_parameters (reverse kinds_of_parameters))

					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  (sublist  (subseq parameters 0 (list-length parameters))  )   )
						(progn


							(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

							(progn

								(if (not (gethash (car sublist) variables) )
									(progn

										(print (car parameters) )
										(print "has no value.")
										(exit 1)
									)
									(setq result   (gethash (car sublist) variables))
								)

							)


							(if (string-equal (car kinds_of_parameters) "binary")

								(progn
									(print "- is not defined over binaries")
									(exit 1)
								)

								(setq result   (car sublist))
							)
							)

							(if (= parameters_number 0)

							(progn
								(print "There is no parameter for MINUS OPERATOR")
								(exit 1)
							)

							)							

							(setq sublist (cdr sublist))
							(setq kinds_of_parameters (cdr kinds_of_parameters))
							(setq counter (+ counter 1))

							(loop

							(when (=  counter  parameters_number) (return nil) )

							(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

							(progn

								(if (not (gethash (car sublist) variables) )
									(progn

										(print (car parameters) )
										(print "has no value.")
										(exit 1)
									)
									(setq result  (- result (gethash (car sublist) variables)) )
								)

							)


							(if (string-equal (car kinds_of_parameters) "binary")

								(progn
									(print "- is not defined over binaries")
									(exit 1)
								)

								(setq result (- result  (car sublist)) )
							)
							)	
							(setq counter (+ counter 1))
							(setq sublist (subseq sublist 1))
				
						)
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)
					)	
					)

					)

					( (string-equal operator_what "OP_MULTIP")

					(progn


					(setq parameters (reverse parameters))


					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  )

						(progn

							(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

							(progn

								(if (not (gethash (car parameters) variables) )
									(progn

										(print (car parameters) )
										(print "has no value.")
										(exit 1)
									)
									(setq result   (gethash (car parameters) variables))
								)

							)


							(if (string-equal (car kinds_of_parameters) "binary")

								(progn
									(print "* is not defined over binaries")
									(exit 1)
								)

								(setq result   (car parameters))
							)
							)

					(if (= parameters_number 0)

						(progn
							(print "There is no parameter for MULTIPLICATION OPERATOR")
							(exit 1)
						)

					)	


					(progn
					(setq parameters (cdr parameters))
					(setq counter (+ counter 1))
					(loop

						(when (=  counter parameters_number) (return nil) )


							(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

							(progn

								(if (not (gethash (car parameters) variables) )
									(progn

										(print (car parameters) )
										(print "has no value.")
										(exit 1)
									)
									(setq result  (* result (gethash (car parameters) variables)) )
								)

							)


							(if (string-equal (car kinds_of_parameters) "binary")

								(progn
									(print "* is not defined over binaries")
									(exit 1)
								)

								(setq result (* result  (car parameters)) )
							)
							)


						(setq counter (+ counter 1))
						(setq parameters (cdr parameters))
				
					)
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)
					)
					)

					)

					)


					( (string-equal operator_what "OP_DIV")

					(progn

					(setq parameters (reverse parameters))


					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  (first_parameter 0))
					(progn

							(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

							(progn

								(if (not (gethash (car parameters) variables) )
									(progn

										(print (car parameters) )
										(print "has no value.")
										(exit 1)
									)
									(setq first_parameter   (gethash (car parameters) variables))
								)

							)


							(if (string-equal (car kinds_of_parameters) "binary")

								(progn
									(print "/ is not defined over binaries")
									(exit 1)
								)

								(setq first_parameter   (car parameters))
							)
							)

						(if (= parameters_number 0)

						(progn
							(print "There is no parameter for DIVISION OPERATOR")
							(exit 1)
						)

					)
					(setq parameters (cdr parameters))
					(setq kinds_of_parameters (cdr kinds_of_parameters))

							(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

							(progn

								(if (not (gethash (car parameters) variables) )
									(progn

										(print (car parameters) )
										(print "has no value.")
										(exit 1)
									)
									(setq result   (gethash (car parameters) variables))
								)

							)
							(if (string-equal (car kinds_of_parameters) "binary")

								(progn
									(print "/ is not defined over binaries")
									(exit 1)
								)

								(setq result (car parameters))
							)
							)

					(setq parameters (cdr parameters))
					(setq kinds_of_parameters (cdr kinds_of_parameters))
					(setq counter (+ counter 2))
					(loop

						(when (=  counter parameters_number) (return nil) )

								(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

							(progn

								(if (not (gethash (car parameters) variables) )
									(progn

										(print (car parameters) )
										(print "has no value.")
										(exit 1)
									)
									(setq result  (* result (gethash (car parameters) variables)) )
								)

							)

							(if (string-equal (car kinds_of_parameters) "binary")

								(progn
									(print "/ is not defined over binaries")
									(exit 1)
								)

								(setq result (* result  (car parameters)) )
							)
							)
						(setq counter (+ counter 1))
						(setq parameters (cdr parameters))
				
					)
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push (/ first_parameter result) return_values)
					(return-from helper_interpreter return_values)
					)
					)
					)
					)

					( (string-equal operator_what "KW_LIST")

					(progn


					(setq parameters (reverse parameters))

					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  )

					(if (= parameters_number 0)

						(progn
							(print "There is no parameter for LIST")
							(exit 1)
						)

					)

					(setq result parameters)
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)

					)

					)

					( (string-equal operator_what "KW_AND")

					(progn

					(setq parameters (reverse parameters))
					(setq kinds_of_parameters (reverse kinds_of_parameters))



					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  )

					(if (= parameters_number 0)

						(progn
							(print "There is no parameter for AND")
							(exit 1)
						)

					)

					(if (string-equal (car kinds_of_parameters) "IDENTIFIER")


						(if (and (not (gethash (car parameters) variables) ) (not nil (car parameters)) (not (eq T (car parameters))) )

							(progn
								(print (car parameters) )
								(print "has no value.")
								(exit 1)
							)
							(setq result (gethash (car parameters) variables))
						)
						(progn

						(setq result (car parameters))

						)


					)

					(setq parameters (cdr parameters))
					(setq kinds_of_parameters (cdr kinds_of_parameters))
					(setq counter (+ counter 1))

					(loop

						(when (=  counter parameters_number) (return nil) )

					(if (string-equal (car kinds_of_parameters) "IDENTIFIER")


						(if (not (gethash (car parameters) variables) )

							(progn

								(print (car parameters) )
								(print "has no value.")
								(exit 1)
							)
							(setq result (and result (gethash (car parameters) variables)) )
						)
						(setq result (and result  (car parameters)))


					)
						(setq result (and result  (car parameters)))
						(setq counter (+ counter 1))
						(setq parameters (cdr parameters))
				
					)
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)

					)

					)

					( (string-equal operator_what "KW_OR")

					(progn


					(setq parameters (reverse parameters))

					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  )

					(setq result (car parameters))
					(setq parameters (cdr parameters))
					(setq counter (+ counter 1))

					(loop

						(when (=  counter parameters_number) (return nil) )
						(setq result (or result  (car parameters)))
						(setq counter (+ counter 1))
						(setq parameters (cdr parameters))
				
					)
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)

					)

					)
					( (string-equal operator_what "KW_NOT")

					(progn


					(setq parameters (reverse parameters))
					(setq kinds_of_parameters (reverse kinds_of_parameters))

					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  )

					(progn

					(if (= parameters_number 0)

						(progn
							(print "There is no parameter for NOT")
							(exit 1)
						)

					)

					(if (> parameters_number 1)
						(progn
							(print "gppinterpreter: Too many parameter for NOT:")
							(exit 1)
						)
					)
					(if (string-equal (car kinds_of_parameters) "IDENTIFIER")

						(if (not (gethash (car parameters) variables) )
							(progn

								(print (car parameters) )
								(print "has no value.")
								(exit 1)
							)
							(progn
							(setq result  (not (gethash (car parameters) variables)) )
							)
						)
						(setq result (not (car parameters)) )
					)


					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)
					)

					)

					)

					( (string-equal operator_what "KW_EQUAL")

					(progn



					(if (> (list-length parameters) 2 )
						(progn

							(print "gppinterpreter : Too many argument given to EQUAL")
							(exit 1)
						)
					)
					(if	(< (list-length parameters) 2)
						(progn

							(print "gppinterpreter : Too few argument given to EQUAL")
							(exit 1)
						)
					)

					(setq parameters (reverse parameters))

					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  )


					(setq result (equal (car parameters) (cadr parameters)))
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)

					)

					)

					( (string-equal operator_what "KW_SET")

					(progn


					(if (> (list-length parameters) 2 )
						(progn

							(print "gppinterpreter : Too many argument given to SET")
							(exit 1)
						)
					)
					(if	(< (list-length parameters) 2)
						(progn

							(print "gppinterpreter :  Too few argument given to SET")
							(exit 1)
						)
					)

					(setq parameters (reverse parameters))
					(setq kinds_of_parameters (reverse kinds_of_parameters))

					(if (string-equal "VALUE" (car kinds_of_parameters))
						(progn

							(print "gppinterpreter - SET : first parameter is not a symbol ")
							(exit 1)

						)
					)

					(let  (  (counter 0)   (result 0) (parameters_number (list-length parameters))  (return_values '())  )

					(setq result (cadr parameters))

					(if (string-equal "IDENTIFIER" (cadr kinds_of_parameters))

						(if ( not   (gethash (cadr parameters) variables) )
						(progn
						(print (cadr parameters))
						(print "have no value---")
						(exit 1)

						)
						(progn
						
						(setf (gethash (car parameters) variables)   (gethash (cadr parameters) variables) )
						(setq result  (gethash (cadr parameters) variables) )
						)

						)
						(setf (gethash (car parameters) variables)  (cadr parameters) )

					)
					(setq is_finished (+ is_finished 1))
					(push total_tokens return_values)
					(push result return_values)
					(return-from helper_interpreter return_values)
					)

					)

					)

				)
				)
			)

		)
			(setq copy_token_stream (cddr copy_token_stream))
	)

	(if (= is_finished 0)
		(progn
		(print "gppinterpreter :  There is missing ) in the  end of program")   
		(exit 1)
		)
	)
	(if (= is_finished 2)
		(progn
		(print "gppinterpreter :  There is too many ) in the  end of program")
		(exit 1)
		)

	)

	)

)


)


(defun helper_paranthesis (stream)

(let (    (opening 0)  (closing 0)    (counter 0)   )
	(loop

		(when (null stream)(return nil) )
		
		(cond  

			( (and  (= opening closing) (not (= opening 0)) )

				(return-from helper_paranthesis counter)

			)

			( (string-equal (car stream) "OP_OP") 

				(progn
				(setq opening (+ opening 1))
				(setq counter (+ counter 1))
				)
			)


			( (string-equal (car stream) "OP_CP")

				(progn
				(setq closing (+ closing 1))
				(setq counter (+ counter 1))
				)
			)


			( t

				(progn
				(setq counter (+ counter 1))
				)

			)


		)

		(setq stream (cddr stream)) 




	)
	counter

)
)

(defun gppinterpreter(&optional file)



(setq file_content '())
(setq infinite_count2 0)
(setq all_result 0)
(setq variables (make-hash-table :test 'equal))

(defun read_as_list ()   ;;To read from console
	(let (  (line '() )   (characters 0) )

		(loop

			(setq characters (read-char))
			(when (= (char-code characters) 10) (return nil) )

			(push characters line)
		)
		(push (code-char 10) line)
		(setq line (reverse line))
		line
	)
)


	(if (equal file nil)

		(progn

		(loop 

   			(when (= infinite_count2 1) (return  temp_list))

   			(setq file_content (read_as_list))

   			

   			(setq all_result (helper_interpreter (gpp_lexer file_content) ) )
   			(print "SYNTAX and SEMANTIC OK. RESULT :")
   			(print (car all_result) )
   			(terpri)


		)

		)

		(progn


		(let (  (all_size 0)      (paranhthesiss 0)       (total 0)       (result 0)  (tokens 0)  )

		(let ((in (open file :if-does-not-exist nil))) 
  			(when in
    			(loop for line = (read-char in nil)
        			 while line do (setq file_content (push line file_content))) ;openin file and read chararacter by character
    						(close in)))
		
		(setq file_content (reverse file_content))
		(setq tokens (gpp_lexer file_content))

		(setq all_size (list-length tokens))

		
		(loop 

			(setq paranhthesiss (* (helper_paranthesis tokens) 2 ))
			
			(setq total (+ total paranhthesiss))
			(setq result (helper_interpreter  (subseq tokens 0 paranhthesiss)) )
			(when (= total all_size) (return  0))

			(setq tokens (subseq tokens paranhthesiss))


		)

   		(print "SYNTAX and SEMANTIC OK. RESULT :")
   		(print (car result) )
   		(terpri)
		)

		)

	)


)





