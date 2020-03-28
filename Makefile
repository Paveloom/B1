
     ## Это шаблон make-файла для публикации кода на GitHub.

     ## Репозиторий на GitHub: https://github.com/Paveloom/B1
     ## Документация: https://www.notion.so/paveloom/B1-fefcaf42ddf541d4b11cfcab63c2f018

     ## Версия релиза: 2.1.3
     ## Версия документации: 2.1.0

     ## Автор: Павел Соболев (http://paveloom.tk)

     ## Для корректного отображения содержимого
     ## символ табуляции должен визуально иметь
     ## ту же длину, что и пять пробелов.

     # Настройки make-файла

     ## Имя координатора
     MAKE := make

     ## Указание оболочки
     SHELL := /bin/bash

     ## Указание make-файлу выполнять все правила в одном вызове оболочки
     .ONESHELL :

     ## Заглушка на вывод информации указанным правилам
     .SILENT :

     ## Правила-псевдоцели
     .PHONY : git, git-am, new, del, git-new, git-clean, archive

     ## Правило, выполняющееся при вызове координатора без аргументов
     ALL : git



     # Блок правил для разработки и публикации кода на GitHub

     ## Имя пользователя на GitHub
     USERNAME := Paveloom

     ## Сообщение стартового коммита
     START_MESSAGE := "Стартовый коммит."

     ## Имя ветки изменений
     FEATURE_BRANCH := feature

     ## Правило для создания и публикации коммита
     git :
	      git add -A
	      git commit -e

	      # Проверка, был ли создан коммит
	      if [ $$? -eq 0 ]; then

	           git push --follow-tags

	      fi

     ## Правило для обновления последнего коммита до текущего состояния локального репозитория
     git-am :
	         git add -A
	         git commit --amend

	         # Проверка, был ли создан коммит
	         if [ $$? -eq 0 ]; then

	              git push --follow-tags --force-with-lease

	         fi

     ## Правило для создания ветки изменений
     new :
	      git checkout -q master
	      git checkout -b ${FEATURE_BRANCH}
	      git push -u origin ${FEATURE_BRANCH}

     ## Правило для удаления текущей ветки изменений локально
     del :
	      git checkout -q master
	      git branch -D ${FEATURE_BRANCH}

     ## Правило для подключения удалённого репозитория и
     ## загрузки в него стартового make-файла

     ifeq (git-new, $(firstword $(MAKECMDGOALS)))
          NEW_REP := $(wordlist 2, 2, $(MAKECMDGOALS))
          $(eval $(NEW_REP):;@#)
     endif

     git-new :
	          $(MAKE) git-clean
	          git init
	          git remote add origin git@github.com:$(USERNAME)/$(NEW_REP).git
	          git add Makefile
	          git commit -m $(START_MESSAGE)
	          git push -u origin master

     ## Правило для удаления репозитория в текущей директории
     git-clean :
	            rm -rf .git

     # Правило для создания архивов
     archive :
	          find Make-файлы/ -path '*/.*' -prune -o -type f -print | zip Архивы/Make-файлы.zip -FS -q -@
