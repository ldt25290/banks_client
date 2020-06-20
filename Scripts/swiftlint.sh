if which swiftlint > /dev/null; then
    swiftlint
else
	echo "warning: Swiftlint not installed, use 'brew install swiftlint' to install"
fi