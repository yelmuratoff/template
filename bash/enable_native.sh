ID_APPLICATION=""

# Функция для вывода инструкции по использованию скрипта
usage() {
    echo "Использование: $0 --id [ID приложения]. Пример: --id com.company. Имя приложения добавится автоматически."
    exit 1
}

# Парсинг аргументов командной строки
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --id)
        if [ -z "$2" ]; then
            echo "Ошибка: после --id не указан ID для вашего приложения: (com.company). Имя приложения добавится автоматически."
            usage
            exit 1
        fi
        ID_APPLICATION="$2"
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
if [ -z "$ID_APPLICATION" ]; then
    echo "Ошибка: ID не указан."
    usage
    exit 1
else
    echo "Создание приложения для: $ID_APPLICATION"
    fvm flutter create . --org $ID_APPLICATION --platforms ios,android,web
fi
