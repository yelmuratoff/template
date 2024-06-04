ID_APPLICATION=""

# Function to display the script usage instructions
usage() {
    echo "Usage: $0 --id [Application ID]. Example: --id com.company. The application name will be added automatically."
    exit 1
}

# Parsing command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --id)
        if [ -z "$2" ]; then
            echo "Error: No ID specified for your application after --id: (com.company). The application name will be added automatically."
            usage
            exit 1
        fi
        ID_APPLICATION="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown argument
        usage
        exit 1
        ;;
    esac
done

# Check if an ID has been provided
if [ -z "$ID_APPLICATION" ]; then
    echo "Error: ID not specified."
    usage
    exit 1
else
    echo "Creating application for: $ID_APPLICATION"
    fvm flutter create . --org $ID_APPLICATION --platforms ios,android,web
    dart pub run flutter_launcher_icons
    dart run flutter_native_splash:create
fi
