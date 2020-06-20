if [[ "${CONFIGURATION}" == *"Debug"* ]]; then
    if which bartycrouch > /dev/null; then
        bartycrouch update -x
    else
        echo "warning: BartyCrouch not installed, download it from https://github.com/Flinesoft/BartyCrouch"
    fi
fi