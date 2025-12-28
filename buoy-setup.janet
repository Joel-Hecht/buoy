#!/usr/local/bin/janet

# for testing, we should create input and output pipes / streams, and then fork to create a background process

#include spork here as well?
#should import sport instead of use spork to not clog namespace
#(import sport)

#this import is installed globally, and only really works if I shebang the script
#in the future, I should configure a project.janet that works to compile this file with deps
#(import sh)
(use sh)

#stupid unnamed pipes
#these are bound to this jaet event loop, and are not storeed on disk (other processes can't access)
#(def (janet_recv janet_send ) (os/pipe))

# communications between just janet event loop called processes should be done in channels


(defn read-from-pipe [pipe_name] 
	#don't want to use with in case pipe is still being written to

	 (def read-pipe (file/open pipe_name :r ))
	 (def data (:read read-pipe :all))
	 (:close read-pipe)
	 data
	#(slurp pipe_name )
)

(defn write-to-pipe [pipe_name data] 
	#don't want to use with in case pipe is still being written to
	(def write-pipe (file/open pipe_name :w ))
	(:write write-pipe data)
	(:flush write-pipe)
	(:close write-pipe)
)

# make named pipe with full permissions, @name should be a path in /tmp 
(defn make-socket [name] 
	#on linux we could use abstract uds but don't want to in case i have to use these on mingw at work (involves kernel)
	#(net/connect :unix name) #client

	(when (os/stat name) (os/rm name))

	(def sock (net/listen :unix name))

	(os/chmod name 8r777) #For some reason pipes made from janet don't have default /tmp/ permissions
	sock
)

(defn server-loop [sockname]

	(def buf @"")
	
	(print "server loop started")
	(def sock (make-socket sockname) )

	(forever
		#wait for client
		(def connection (net/accept sock ))
		(defer (:close connection)
			(buffer/push-string buf (net/read connection 1024) )
			(print buf)
			(net/write connection buf )
		)	
		

	# 	(buffer/push-string buf (read-from-pipe inpipe))
	# 	(print (string "sending: " buf) )
	# 	(write-to-pipe outpipe buf)
	)

)

#main routine

(def makesockname "/tmp/buoy-maker.socket")
(def subsockname "/tmp/buoy-substitute.socket")

(ev/go |(server-loop makesockname )  )
(ev/go |(server-loop subsockname ) )
