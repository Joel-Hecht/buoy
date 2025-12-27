#!/usr/local/bin/janet

# for testing, we should create input and output pipes / streams, and then fork to create a background process

(use sh)

($ makefifo janet_in janet_out )

(var input "-1")

(while true 
	(set input ($<_ cat < janet_in) )

	(print input )
)
