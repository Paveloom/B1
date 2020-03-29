#!/bin/bash

# Вывод заголовка скрипта
printf "\nЗапущен скрипт, проверяющий, отличается ли текущая версия релиза от предыдущей.\n\n"

# Определение имени ветки с изменениями
FEATURE_BRANCH_NAME="feature"

# Переход на ветку master
git checkout -q master

# Сохранение тега последнего коммита на master в переменную
MASTER_TAG="$(git describe --tags master)"

printf "Проверка, совпадает ли текущий тег с мастер тегом...\n\n"

# Получение текущего тега для релиза
R_CURRENT_TAG="$(grep -o "release\-v[0-9]\+\.[0-9]\+\.[0-9]\+\-informational" README.md | grep -o "\-.*\-" | sed 's/-//g')"

# Получение текущего тега для документации
D_CURRENT_TAG="$(grep -o "docs\-v[0-9]\+\.[0-9]\+\.[0-9]\+\-informational" README.md | grep -o "\-.*\-" | sed 's/-//g')"

printf "Тег на master:\n"
echo $MASTER_TAG

if echo "$MASTER_TAG" | grep -q "rv"; then

     printf "\nТекущий тег из README.md для релиза:\n"
     echo r$H1_CURRENT_TAG

     # Проверка, отличается ли тег на master от текущего тега
     if [ ! r$H1_CURRENT_TAG == $MASTER_TAG ]; then

          printf "\nТекущий тег для релиза и тег на master НЕ совпадают. Обновите"
          printf "\nтег на master в соответствии с текущим тегом.\n\n"

          exit 1

     fi

elif echo "$MASTER_TAG" | grep -q "dv"; then

     printf "\nТекущий тег из README.md для документации:\n"
     echo d$H2_CURRENT_TAG

     # Проверка, отличается ли тег на master от текущего тега
     if [ ! d$H2_CURRENT_TAG == $MASTER_TAG ]; then

          printf "\nТекущий тег для документации и тег на master НЕ совпадают. Обновите"
          printf "\nтег на master в соответствии с текущим тегом.\n\n"

          exit 1

     fi

else

     printf "\nМастер тег не содержит префикса rv / dv.\n\n"
     exit 1

fi

printf "\nВсё в порядке.\n"