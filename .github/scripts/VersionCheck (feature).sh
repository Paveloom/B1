#!/bin/bash

# Вывод заголовка скрипта
printf "\nЗапущен скрипт, проверяющий, отличается ли текущая версия релиза от предыдущей.\n\n"

# Определение имени временной директории
TMP_FOLDER_NAME="tmp"

# Определение начального числа ошибок
ERROR_COUNT=0

# Определение функции для проверки версии релиза
function check_release_version {

     printf "\nПроверяется версия релиза в файле $1 ...\n\n"

     if grep "Версия релиза: " "$1" | grep -q "$R_CURRENT_TAG_ESCAPED"; then

          printf "\nВерсия релиза в файле соответствует текущей.\n\n"

     else

          printf "\n[!] Версия релиза в файле НЕ соответствует текущей.\n\n"
          ERROR_COUNT=$((ERROR_COUNT+1))

     fi

}

# Определение функции для проверки версии документации
function check_docs_version {

     printf "\nПроверяется версия документации в файле $1 ...\n\n"

     if grep "Версия документации: " "$1" | grep -q "$D_CURRENT_TAG_ESCAPED"; then

          printf "\nВерсия документации в файле соответствует текущей.\n\n"

     else

          printf "\n[!] Версия документации в файле НЕ соответствует текущей.\n\n"
          ERROR_COUNT=$((ERROR_COUNT+1))

     fi

}

# Определение функции для проверки версии релиза в архиве
function check_release_version_zip {

     printf "\nПроверяется версия релиза в файле $2,\n"
     printf "который находится в архиве "$1" ...\n"

     # Создание временной директории, если она еще не создана
     if [ ! -d $TMP_FOLDER_NAME ]; then
          mkdir $TMP_FOLDER_NAME

     # Удаление всех файлов во временной директории
     else
          rm -rf tmp/*
     fi

     printf "\nРазархивирование во временную директорию ...\n"

     # Разархивирование
     unzip -q "$1" -d $TMP_FOLDER_NAME

     if grep "Версия релиза: " $TMP_FOLDER_NAME/"$2" | grep -q "$R_CURRENT_TAG_ESCAPED"; then

          printf "\nВерсия релиза в файле соответствует текущей.\n\n"

     else

          printf "\n[!] Версия релиза в файле НЕ соответствует текущей.\n\n"
          ERROR_COUNT=$((ERROR_COUNT+1))

     fi

}

# Определение функции для проверки версии документации в архиве
function check_docs_version_zip {

     printf "\nПроверяется версия документации в файле $2,\n"
     printf "который находится в архиве "$1" ...\n"

     # Создание временной директории, если она еще не создана
     if [ ! -d $TMP_FOLDER_NAME ]; then
          mkdir $TMP_FOLDER_NAME

     # Удаление всех файлов во временной директории
     else
          rm -rf tmp/*
     fi

     printf "\nРазархивирование во временную директорию ...\n"

     # Разархивирование
     unzip -q "$1" -d $TMP_FOLDER_NAME

     if grep "Версия документации:" $TMP_FOLDER_NAME/"$2" | grep -q "$D_CURRENT_TAG_ESCAPED"; then

          printf "\nВерсия документации в файле соответствует текущей.\n\n"

     else

          printf "\n[!] Версия документации в файле НЕ соответствует текущей.\n\n"
          ERROR_COUNT=$((ERROR_COUNT+1))

     fi

}

# Определение функции, содержащей все необходимые проверки
function run_version_checks {

     check_release_version "Makefile"
     check_release_version "Make-файлы/Компиляция программ"
     check_release_version "Make-файлы/Компиляция программ, публикация кода на GitHub"
     check_release_version "Make-файлы/Публикация кода на GitHub"
     check_release_version "Пример/Makefile"

     check_docs_version "Makefile"
     check_docs_version "Make-файлы/Компиляция программ"
     check_docs_version "Make-файлы/Компиляция программ, публикация кода на GitHub"
     check_docs_version "Make-файлы/Публикация кода на GitHub"
     check_docs_version "Пример/Makefile"

     check_release_version_zip "Архивы/Make-файлы.zip" "Make-файлы/Компиляция программ"
     check_release_version_zip "Архивы/Make-файлы.zip" "Make-файлы/Компиляция программ, публикация кода на GitHub"
     check_release_version_zip "Архивы/Make-файлы.zip" "Make-файлы/Публикация кода на GitHub"

     check_docs_version_zip "Архивы/Make-файлы.zip" "Make-файлы/Компиляция программ"
     check_docs_version_zip "Архивы/Make-файлы.zip" "Make-файлы/Компиляция программ, публикация кода на GitHub"
     check_docs_version_zip "Архивы/Make-файлы.zip" "Make-файлы/Публикация кода на GitHub"

}

# Определение имени ветки с изменениями
FEATURE_BRANCH_NAME="feature"

# Переход на ветку master
git checkout -q master

# Сохранение тега последнего коммита на master в переменную
MASTER_TAG="$(git describe --tags master)"

printf "Тег на master:\n"
echo $MASTER_TAG

# Переход на ветку изменений
git checkout -q $FEATURE_BRANCH_NAME

# Получение текущего тега для релиза
R_CURRENT_TAG="$(grep -o "release\-v[0-9]\+\.[0-9]\+\.[0-9]\+\-informational" README.md | grep -o "\-.*\-" | sed 's/-//g')"

# Получение текущего тега для документации
D_CURRENT_TAG="$(grep -o "docs\-v[0-9]\+\.[0-9]\+\.[0-9]\+\-informational" README.md | grep -o "\-.*\-" | sed 's/-//g')"

# Получение текущего тега для релиза с избеганием точек
R_CURRENT_TAG_ESCAPED="$(echo "$R_CURRENT_TAG" | sed 's/v//' | sed 's/\./\\./g')"

# Получение текущего тега для документации с избеганием точек
D_CURRENT_TAG_ESCAPED="$(echo "$D_CURRENT_TAG" | sed 's/v//' | sed 's/\./\\./g')"

# Получение текущего тега в целом
CURRENT_TAG="$(git describe --tags feature)"

# Получение текущего префикса
CURRENT_PREFIX="${CURRENT_TAG:0:2}"

# Смена текущего тега в зависимости от префикса
if [ "rv" == "$CURRENT_PREFIX" ]; then

     CURRENT_TAG=r"$R_CURRENT_TAG"

elif [ "dv" == "$CURRENT_PREFIX" ]; then

     CURRENT_TAG=d"$D_CURRENT_TAG"

fi

printf "\nТекущий тег из README.md:\n"
echo $CURRENT_TAG

# Проверка, изменился ли текущий тег
if [ $CURRENT_TAG == $MASTER_TAG ]; then

     printf "\nТекущий тег и тег на master совпадают. Обновите текущий тег"
     printf "\nв соответствии с установками Semantic Versioning.\n\n"

     exit 1

fi

# Избегание точек в текущем теге
CURRENT_TAG="$(echo $CURRENT_TAG | sed "s/$CURRENT_PREFIX//" | sed 's/v//' | sed 's/\./\\./g')"

# Проверка, совпадает ли другой тег в README.md
if ! grep -q "releases/tag/$CURRENT_PREFIX$CURRENT_TAG" README.md; then

     printf "\n[!] Указанные теги различаются в README.md.\n\n"
     ERROR_COUNT=$((ERROR_COUNT+1))

fi

# Запуск указанных проверок
run_version_checks

if [ "$ERROR_COUNT" -gt 0 ]; then

     printf "Число ошибок: $ERROR_COUNT\n\n"
     exit 1

else

     printf "Всё в порядке.\n"

fi