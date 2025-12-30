.PHONY: all
all:
	sudo jpm deps
	jpm build
	mkdir -p "${HOME}/.buoy/bin"
	sudo cp "build/buoy-client" "/usr/local/bin/"
	sudo cp "build/buoy-server" "/usr/local/bin/"
	#systemd stuff
	#bashrc stuff
	
	
# will not remove anything from bashrc
.PHONY: clean
clean:
	rm -rf build
	sudo rm "/usr/local/bin/buoy-client"
	sudo rm "/usr/local/bin/buoy-server"

	#cleaning /tmp is a little too goody-two-shoes for me but I'm leaving this in anyway
	sudo rm "/tmp/buoy-maker.socket"
	sudo rm "/tmp/buoy-substitute.socket"

	rm -rf "${HOME}/.local/share/buoy"
	
