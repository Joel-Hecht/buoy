#!/usr/local/bin/janet

#this routine will send data and then read from other pipe

#assume the server has already created these pipes

(defn usage [status] 
	(print "Usage: \tbuoy -e <command> \n\tbuoy [-m | -c] <string>")
	#put more usage stuff here	
	(os/exit status ) 
)

(defn client-loop [ msg sockname ] 

	#blocks, we cant create read pipe until there is data on the other side
	#in other words, this blocks until we have a writer
	#(var read-pipe (file/open "/tmp/janet-out" :r ) )
	#(def write-pipe (file/open outpipe :w ) )

	(def connection (net/connect :unix sockname))
	(net/write connection msg )
	(print (net/read connection 1024))	
)

(defn prepare-and-send [argsarray sock] 
	
		#remove $0 and flag
		(var command-array (array/slice argsarray 2 ) )
		#all backslashes become double backslashes, so it is impossible for
		#the new string to contain " \ "
		(set command-array (map (fn [x] (string/replace-all "\\" "\\\\" x )) command-array )   )
		(def command-joined (string/join command-array " \\ "))
	
		#\\e will indicate the end of the message
		(client-loop (string command-joined " \\e" )  sock)

)

#not robust option checking because i suck
(defn checkopt [msock esock] 
	(let [args (dyn :args)]
		(case (get args 1)
			"-m" (prepare-and-send args msock )
			"-e" (prepare-and-send args esock )
			"-c" (usage 0) #unimplemented as of yet
			"-h" (usage 0)
			(usage 1) # got nothing
		)
	)
)

(def msock "/tmp/buoy-maker.socket")
(def esock "/tmp/buoy-substitute.socket")

(checkopt msock esock )

