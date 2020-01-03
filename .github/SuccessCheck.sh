#!/bin/bash

# Проверка, является ли файл лога пустым 
# (только для запуска с помощью GitHub Action)

if [ -s .github/last_log ]; then
     
     cat .github/last_log
     false
     
fi