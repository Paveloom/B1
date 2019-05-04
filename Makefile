
      # Настройки компиляции программ
          comp := gfortran
          opt  := -c -Wall -Wtabs
        pattern:= *.f95
        source := $(wildcard $(pattern))
           obj := $(patsubst %.f95, %.o, $(source))

      # Блок правил для компиляции объектных файлов
      
        main : $(obj)
	       $(comp) $^ -o $@

         %.o : %.f95
	       $(comp) $(opt) $< -o $@

       %.mod : %.f95
	       $(comp) $(opt) $<

      # Блок правил-зависимостей (при необходимости)
        main.o : subprograms.mod

      # Блок правил для инициализации make-файла для сборки программы
      
        result : main input
	        time ./$<  < input > output
	        
        result-r : main input
		rm output
		make result
		cat output

      # Блок правил для очистки директории
        clean :
	 rm -f *.o *.mod main

        clean-all :
	 rm -f *.o *.mod main *.eps *.dat result

      # Блок правил для загрузки программы на Github

        # Правила для проверки статуса репозитория
          git-s :
		git status
		git remote

        # Правило для загрузки на Github с указанием метки репозитория и сообщения коммита (см. Readme)

        ifeq (git,$(firstword $(MAKECMDGOALS)))
        rep := $(wordlist 2,2,$(MAKECMDGOALS))
        m := $(wordlist 3,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
        $(eval $(a):;#)
        endif

          git :
		git add -A
		git commit -m "$(m)"
		git push -u $(rep) master

        # Правило для удаления репозитория в текущей директории
          git-clean :
		rm -rf .git

       # Правило для подключения нового репозитория с указанием названия и метки
       # и загрузки в него стартового make-файла (см. Readme)

        ifeq (git-new,$(firstword $(MAKECMDGOALS)))
        new_rep := $(wordlist 2,2,$(MAKECMDGOALS))
        label := $(wordlist 3,3,$(MAKECMDGOALS))
        $(eval $(a):;#)
        endif

         git-new :
			make git-clean
			git init
			git remote add $(label) git@github.com:Paveloom/$(new_rep).git
			git add Makefile
			git commit -m "Стартовый make-файл."
			git push -u $(label) master
			

