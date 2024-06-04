IP_ADDRESS=""

# Function to display the script usage instructions
usage() {
    echo "Usage: $0 --ip [IP address]"
    exit 1
}

# Parsing command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --ip)
        if [ -z "$2" ]; then
            echo "Error: No IP address specified after --ip."
            usage
            exit 1
        fi
        IP_ADDRESS="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown argument
        usage
        exit 1
        ;;
    esac
done

# Check if an IP address has been provided
if [ -z "$IP_ADDRESS" ]; then
    echo "Error: IP address not specified."
    usage
    exit 1
else
    echo "Connecting to IP: $IP_ADDRESS"
    adb tcpip 5555
    adb connect $IP_ADDRESS
fi
