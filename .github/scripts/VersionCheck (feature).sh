#!/bin/bash

# Вывод заголовка скрипта
printf "\nЗапущен скрипт, проверяющий, отличается ли текущая версия релиза от предыдущей.\n\n"

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

     printf "\nУказанные теги различаются в README.md.\n\n"

     exit 1

fi

printf "\nВсё в порядке.\n"