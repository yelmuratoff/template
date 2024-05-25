IP_ADDRESS=""

# Функция для вывода инструкции по использованию скрипта
usage() {
    echo "Использование: $0 --ip [IP-адрес]"
    exit 1
}

# Парсинг аргументов командной строки
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --ip)
        if [ -z "$2" ]; then
            echo "Ошибка: после --ip не указан IP-адрес."
            usage
            exit 1
        fi
        IP_ADDRESS="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # неизвестный аргумент
        usage
        exit 1
        ;;
    esac
done

# Проверка, был ли предоставлен IP-адрес
if [ -z "$IP_ADDRESS" ]; then
    echo "Ошибка: IP-адрес не указан."
    usage
    exit 1
else
    echo "Подключение к IP: $IP_ADDRESS"
    adb tcpip 5555
    adb connect $IP_ADDRESS
fi
