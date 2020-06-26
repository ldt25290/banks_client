#!/bin/sh

function run_swiftformat() {
	if which swiftformat > /dev/null; then
    	swiftformat "./App/Sources"
	else
		echo "warning: swiftformat is not installed, attempting to install"
		`brew install swiftformat`
		run_sourcery
	fi
}

run_swiftformat