# Basic program to explore janet-lang's capabilities to run daemons

## Description
The buoy program will create cross-session variables for filesystem paths. Buoys are more robust than environment variables, and don't clog the environment variable namespace

The buoy table will run as a daemon, and will be updated and accessed by the following commands 

(touch on thread safety here)

[m]ake a buoy named 'a' to the current directory
```
$ buoy -m a 
```

[e]xecute a command, substituting all buoys (excaped) for their paths
```
buoy -e cd \a
```

[l]ist the buoy table to stdout
```
buoy -l
```

alias for cd to a buoy as an unescaped string
```
buoy -c a
```


(touch on buoy name constraints / regex)


(touch on recommended aliases??)
