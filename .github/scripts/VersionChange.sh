#!/bin/bash

# Скрипт для замены версий релиза и документации в make-файлах

# Определение функции для замены версии релиза
function change_release_version {

     # Замена версии релиза
     sed -i "$2s/[0-9]\+.[0-9]\+.[0-9]\+/$R_CURRENT_TAG/" "$1"

}

# Определение функции для замены версии документации
function change_docs_version {

     # Замена версии релиза
     sed -i "$2s/[0-9]\+.[0-9]\+.[0-9]\+/$D_CURRENT_TAG/" "$1"

}

# Определение функции, содержащей все необходимые проверки
function run_version_changes {

     change_release_version "Makefile" "7"
     change_release_version "Make-файлы/Компиляция программ" "7"
     change_release_version "Make-файлы/Компиляция программ, публикация кода на GitHub" "8"
     change_release_version "Make-файлы/Публикация кода на GitHub" "7"
     change_release_version "Пример/Makefile" "7"

     change_docs_version "Makefile" "8"
     change_docs_version "Make-файлы/Компиляция программ" "8"
     change_docs_version "Make-файлы/Компиляция программ, публикация кода на GitHub" "9"
     change_docs_version "Make-файлы/Публикация кода на GitHub" "8"
     change_docs_version "Пример/Makefile" "8"

}

# Получение текущего тега для релиза
R_CURRENT_TAG="$(grep -o "release\-v[0-9]\+\.[0-9]\+\.[0-9]\+\-informational" README.md | grep -o "\-.*\-" | sed 's/-//g' | sed 's/v//')"

# Получение текущего тега для документации
D_CURRENT_TAG="$(grep -o "docs\-v[0-9]\+\.[0-9]\+\.[0-9]\+\-informational" README.md | grep -o "\-.*\-" | sed 's/-//g' | sed 's/v//')"

# Выполнение замен
run_version_changes