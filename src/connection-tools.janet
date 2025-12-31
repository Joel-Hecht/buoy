#!/user/local/bin/janet

# Using only this library to fully manage your connections, you will be 
# able to use constant-length reads (non-blocking) to read all from a 
# socket by using a specific end deliminter, which is managed in 
# functions from this module

	
( def connectionManager
	@{
		:type "connectionManager"
		:connection nil
		:leftover ""
		:packetSize 512
		:setConnection (fn [self connection] (put self :connection connection ) )
		:acceptManaged (fn [self] 
			(def buf (net/read (self :connection) (self :packetSize) ) )
			(def terminator (string/find " \\e" buf ) )
			(if (nil? terminator)
				(do
					#we need another packet - add to leftover and recurse
					(put self :leftover (string (self :leftover) buf ) )
					(:acceptManaged self)
				)
				(do
					(def output (string (self :leftover) (string/slice buf 0 terminator ) ) )

					#put anything after back into leftover in case there were two sends
					(put self :leftover (string/slice buf (+ terminator 3) ) )

					#remove no-single-backslash constraint that we added in :sendManaged
					(string/replace-all "\\\\" "\\" output )
				)
			)
		)
		:sendManaged ( fn [self data]

			#remove any possible instance of a single backslash
			(string/replace-all "\\" "\\\\" data )

			#append a string that now cannot exist anywhere else in the 
			(def newdata (string data " \\e"))
			(net/write (self :connection) newdata)

		)
	}
)

(defn make-connectionManager [connection]
	(def c connectionManager)
	(:setConnection c connection)
	c
)

