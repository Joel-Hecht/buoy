#!/bin/bash
git clone https://github.com/janet-lang/janet.git
cd janet
export PREFIX="${HOME}"/.local	
make -j
make install
make install-jpm-git
export PATH="${PREFIX}"/bin:"${PATH}"
