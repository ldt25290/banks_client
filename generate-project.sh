#!/bin/sh

function run_sourcery() {
	if which sourcery > /dev/null; then
    	sourcery
	else
		echo "warning: Sourcery not installed, attempting to install"
		`brew install sourcery`
		run_sourcery
	fi
}

function run_xcodegen() {
	if which xcodegen > /dev/null; then
    	xcodegen generate
	else
		echo "warning: xcodegen not installed, attempting to install"
		`brew install xcodegen`
		run_xcodegen
	fi
}


run_sourcery
run_xcodegen

bundle install
bundle exec pod install

xcodebuild clean -project "banks-client.xcodeproj"