#!/usr/local/bin/janet

#this routine will send data and then read from other pipe

#assume the server has already created these pipes

(defn read-from-pipe [pipe_name] 
	#refactor to use with
	(def read-pipe (file/open pipe_name :r ))
	(def data (:read read-pipe :all))
	(:close read-pipe)
	data
)

(defn write-to-pipe [pipe_name data] 
	#could refactor to use with
	(def write-pipe (file/open pipe_name :w ))
	(:write write-pipe data)
	(:flush write-pipe)
	(:close write-pipe)
)

(defn sender-loop [outpipe inpipe] 

	#blocks, we cant create read pipe until there is data on the other side
	#in other words, this blocks until we have a writer
	#(var read-pipe (file/open "/tmp/janet-out" :r ) )
	#(def write-pipe (file/open outpipe :w ) )

	(for i 0 4
		(write-to-pipe outpipe "sdfsfsdf\n")
		(print (read-from-pipe inpipe ))
	)
)

(def send "/tmp/janet-in")
(def recv "/tmp/janet-out")

(sender-loop send recv)


