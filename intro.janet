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
(defn make-pipe [name] 
	#ideally this would also check if the file is a pipe and not just some random thing
	(if (os/stat name )
		#remove existing pipe and replace with our own.  Effectively clearing the buffer
		(os/rm name )
	)
	($ mkfifo ,name ) #needs to be run as user, not as root so we can change permissions later
	# this doesnt work because it is blocking - if we could add a timeout or make it continue if there is no data immediately availible this would be perfect
	#(read-from-pipe name )# flush the pipe
	(os/chmod name 8r777) #For some reason pipes made from janet don't have default /tmp/ permissions
)

(defn server-loop [inpipe outpipe]

	(def buf @"")
	
	(forever
		(buffer/push-string buf (read-from-pipe inpipe))
		(print (string "sending: " buf) )
		(write-to-pipe outpipe buf)
	)

)

#main routine

(def inpipe "/tmp/janet-in")
(def outpipe "/tmp/janet-out")

#make named pipes
(make-pipe inpipe)
(make-pipe outpipe)

(server-loop inpipe outpipe)
