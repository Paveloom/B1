
     ## Это шаблон make-файла для публикации кода на GitHub.

     ## Репозиторий на GitHub: https://github.com/Paveloom/B1
     ## Документация: https://www.notion.so/paveloom/B1-fefcaf42ddf541d4b11cfcab63c2f018

     ## Версия релиза: 1.2.2
     ## Версия документации: 1.0.1

     ## Автор: Павел Соболев (http://paveloom.tk)

     ## Для корректного отображения содержимого 
     ## символ табуляции должен визуально иметь
     ## ту же длину, что и пять пробелов.

     # Настройки make-файла

     ## Имя координатора
     make_name := make

     ## Заглушка на вывод сообщений указанными правилами
     ## (без указания имён подавляет вывод со стороны make-файла у всех правил)
     
     .SILENT : 

     ## Правила-псевдоцели

     .PHONY : result, result-r, result-d, result-c, clean, \
              git, git-am, git-dev, git-dev-ready, git-new, git-new-2, \
              git-dev-re, git-dev-ready-re, force_change, git-clean



     # Блок правил для разработки и публикации кода на GitHub
     
     ## Имя пользователя на GitHub
     username := Paveloom
     
     ## Форсировать изменения в текущей версии? (см. документацию по правилам git-dev
     ## и git-dev-ready; см. действия, выполняемые при значении true, в правиле force-change)
     force-changes := true

     ## Сообщение стартового коммита
     start_message := "Стартовый коммит."

     ## Правило для создания и публикации коммита

     git : 
	      git add -A
	      git commit -e
	      git push
 
     ## Правило для обновления последнего коммита до текущего состояния локального репозитория
 
     git-am : 
	         git add -A
	         git commit --amend
	         git push --force-with-lease
         
     ## Правило для обновления ветки master до текущего состояния ветки dev
     ## (слияние без создания коммита слияния; способ через создание второстепенной ветки feature)

     git-dev : 
	          if [ "true" = "$(force-changes)" ]; then \
	               git checkout dev; \
	               $(make_name) force-change; \
	               git add -A; \
	               git commit --amend --no-edit; \
	               git push --force-with-lease; \
	          fi
	
	          git checkout master
	          git checkout -b feature
	          git merge --squash dev -Xtheirs
	          git commit
	          git checkout master
	          git merge feature
	          git branch -D feature
	          git push --force-with-lease
	          git checkout dev

     ## Правило для обновления ветки dev до текущего состояния ветки master
     ## (аналогично правилу git-dev, только в обратную сторону; разумно использовать, только
     ## если были проделаны изменения на ветке master после последнего слияния)

     git-dev-ready : 
	                if [ "true" = "$(force-changes)" ]; then \
	                     git checkout master; \
	                     $(make_name) force-change; \
	                     git add -A; \
	                     git commit --amend --no-edit; \
	                     git push --force-with-lease; \
	                fi
	
	                git checkout dev
	                git checkout -b dev-upd
	                git merge --squash master -Xtheirs
	                git commit
	                git checkout dev
	                git merge dev-upd
	                git branch -D dev-upd
	                git push --force-with-lease

     ## Правило для подключения удалённого репозитория с одной веткой и
     ## загрузки в него стартового make-файла (см. документацию по правилам)

     ifeq (git-new, $(firstword $(MAKECMDGOALS)))
          new_rep := $(wordlist 2, 2, $(MAKECMDGOALS))
          $(eval $(new_rep):;@#)
     endif

     git-new : 
	          $(make_name) git-clean
	          git init
	          git remote add origin git@github.com:$(username)/$(new_rep).git
	          git add Makefile
	          git commit -m "$(start_message)"
	          git push -u origin master

     ## Правило для подключения нового удалённого репозитория с двумя ветками и
     ## загрузки в него стартового make-файла (см. документацию по правилам)

     ifeq (git-new-2, $(firstword $(MAKECMDGOALS)))
          new_rep := $(wordlist 2, 2, $(MAKECMDGOALS))
          $(eval $(new_rep):;@#)
     endif

     git-new-2 : 
	            $(make_name) git-clean
	            git init
	            git remote add origin git@github.com:$(username)/$(new_rep).git
	            git add Makefile
	            git commit -m "$(start_message)"
	            git push -u origin master
	            git checkout -b dev
	            git push -u origin dev

     ## Правило для повторения последнего переноса изменений из ветки dev в ветку master
     ## (используется reset --hard, поэтому следует использовать только при уверенности в
     ## правильности своих действий — поэтому задаётся вопрос)

     git-dev-re :
	             echo
	             echo "Будет использован reset --hard. Убедитесь, что последний коммит в ветке master получен переносом изменений из ветки dev."
	             echo "Скопируйте, если необходимо, сообщение последнего коммита на ветке master:"
	             echo
	
	             git log master -1 --pretty=format:%s; echo
	             git log master -1 --pretty=format:%b; echo
	
	             while [ -z "$$CONTINUE" ]; do \
	                  read -r -p "Продолжить? [y]: " CONTINUE; \
	             done ; \
	             [ $$CONTINUE = "y" ] || [ $$CONTINUE = "Y" ] || (echo; echo "Отменено."; echo; exit 1;)
	
	             echo
	             git checkout master
	             git reset --hard HEAD~1
	             $(make_name) git-dev
   
     ## Правило для повторения последнего переноса изменений из ветки master в ветку dev
     ## (используется reset --hard, поэтому следует использовать только при уверенности в
     ## правильности своих действий — поэтому задаётся вопрос)

     git-dev-ready-re :
	                   echo
	                   echo "Будет использован reset --hard. Убедитесь, что последний коммит в ветке dev получен переносом изменений из ветки master."
	                   echo "Скопируйте, если необходимо, сообщение последнего коммита на ветке dev:"
	                   echo
	
	                   git log dev -1 --pretty=format:%s; echo
	                   git log dev -1 --pretty=format:%b; echo
	
	                   while [ -z "$$CONTINUE" ]; do \
	                        read -r -p "Продолжить? [y]: " CONTINUE; \
	                   done ; \
	                   [ $$CONTINUE = "y" ] || [ $$CONTINUE = "Y" ] || (echo; echo "Отменено."; echo; exit 1;)
	
	                   echo
	                   git checkout dev
	                   git reset --hard HEAD~1
	                   $(make_name) git-dev-ready

     ## Правило для форсирования изменений (добавляет / удаляет пробелы в последней пустой строке;
     ## создает пустую строку, если необходимо; использование зависит от переменной force-changes)
     
     force-change : 
	               if tail Makefile -n 1 | grep '[[:alpha:]]'; then \
	                    echo "$f" >> Makefile; \
	               else \
	                    if tail Makefile -n 1 | grep ' [[:space:]]'; then \
	                         truncate -s-1 Makefile; \
	                    else \
	                         truncate -s-1 Makefile; \
	                         echo "$f " >> Makefile; \
	                    fi \
	               fi

     ## Правило для удаления репозитория в текущей директории
     
     git-clean : 
	            rm -rf .git
