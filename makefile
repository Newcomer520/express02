RED=\e[0;31m
NC=\e[0m
c_branch="none"
task="build"

#no color


heroku:
	@git checkout h-master
master:
	@git checkout master 
	@echo "Git Status:" 
	@git status 
	@git branch | sed -n '/\* /s/*/Current Branch:/p'
	@echo -e "${RED}continue to push to github? (y/N)${NC}"; \
	read yn; \
	while [ -z "$$yn" ] || ([ "$$yn" != "y" ] && [ "$$yn" != "n" ]); do \
	read -r -p "Please input y or n: [y/N]($${yn}) " yn; \
	done ; \
	if [ "$$yn" ==  "y" ]; \
	then \
		echo 'ready to push..'; \
		git push origin master; \
	else \
		echo "see ya!"; \
	fi
gtask:
	@gulp --require LiveScript ${task}


