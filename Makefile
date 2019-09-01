
     ## Заглушка на вывод сообщений указанными правилами
     ## (без указания имён подавляет вывод со стороны make-файла у всех правил)
     .SILENT: 

     # Блок правил для загрузки кода на Github
     
     ## Имя пользователя на GitHub
     username := Paveloom
		
	## Правило для загрузки коммита на удалённый репозиторий

     git :
		 git add -A
		 git commit -e
		 git push
		 
     ## Правило для обновления последнего коммита в удалённом репозитории 
     ## до текущего состояния локального репозитория
		 
     git-am : 
	         git add -A
	         git commit --amend
	         git push --force-with-lease
	         
	## Правило для передачи изменений, проделанных в ветке dev, в ветку master
	## (слияние без создания коммита слияния; способ через создание второстепенной ветки feature)
			
     git-dev :
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
	                git checkout dev
	                git checkout -b dev-upd
	                git merge --squash master -Xtheirs
	                git commit
	                git checkout dev
	                git merge dev-upd
	                git branch -D dev-upd
	                git push --force-with-lease

     ## Правило для подключения нового удалённого репозитория и загрузки в него стартового make-файла (см. README.md)

     ifeq (git-new, $(firstword $(MAKECMDGOALS)))
          new_rep := $(wordlist 2, 2, $(MAKECMDGOALS))
          $(eval $(new_rep):;@#)
     endif

     git-new :
			make git-clean
			git init
			git remote add origin git@github.com:$(username)/$(new_rep).git
			git add Makefile
			git commit -m "Стартовый коммит."
			git push -u origin master
			
     ## Правило для удаления репозитория в текущей директории
     
     git-clean :
		       rm -rf .git

