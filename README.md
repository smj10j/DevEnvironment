DevEnvironment
==============

All my various settings

# Installation #

Run the following in your shell the installation directory can be changed if desired (defaults to ~/.smj10j/DevEnvironment)
``` .bash 
	sudo port install bash-completion; export INSTALL_DIR=; curl -s https://bitbucket.org/smj10j/devenvironment/raw/master/install/install.sh | /bin/bash && $(tail -n 1 log); unset INSTALL_DIR; rm log;
```

While this repos is public, authentication will be required and the above will not work. Instead replace your Bitbucket username and use:
``` .bash 
	sudo port install bash-completion; USERNAME=smj10j; export INSTALL_DIR=; curl -u $USERNAME -s https://bitbucket.org/smj10j/devenvironment/raw/master/install/install.sh | /bin/bash && $(tail -n 1 log); unset INSTALL_DIR; rm log;
```

# What's Included #

- ## Files ##
	1. `edit <file|directory>` - quickly open files in BBEdit from Terminal
	2. `lso [file|directory]` - ls with permissions in octal
``` bash
				-rw-r--r-- 0644 Code/smj10j/DevEnvironment/.DS_Store
				drwxr-xr-x 0755 Code/smj10j/DevEnvironment/.git
				-rw-r--r-- 0644 Code/smj10j/DevEnvironment/.gitignore
				-rw-r--r-- 0644 Code/smj10j/DevEnvironment/.gitmodules
				-rw-r--r-- 0644 Code/smj10j/DevEnvironment/README.md
				drwxr-xr-x 0755 Code/smj10j/DevEnvironment/bash
				drwxr-xr-x 0755 Code/smj10j/DevEnvironment/editors
				drwxr-xr-x 0755 Code/smj10j/DevEnvironment/install
```
	
	
- ## Paths ##
	1. `pathsadd <path string>` - gracefully manages appending a string of paths to the $PATH variable
	2. `pathadd <directory>` - adds a single directory (if not present) to the $PATH variable
		
		
- ## SSH ##
	1. Automatically starts ssh-agent and adds private keys
	2. `s <host> <user>` - attempts to use bash completion for hosts and users


- ## OSX ##
	1. Sets the screenshot directory to  ~/Screenshots
	2. Sets Finder to always show hidden files
	3. `listRegisteredURLSchemes` - lists the currently registered URL schemes
	4. [Bash-completion](http://trac.macports.org/wiki/howto/bash-completion)

- ## Git ##
	1. [Git Aliases](http://www.jperla.com/blog/post/teach-yourself-git-in-2-minutes)
``` bash
				alias ad='git add'
				alias pl='git pull'
				alias ph='git push'
				alias cm='git commit -m'
				alias sl='git status -uall'
				alias lg='git log'
				alias gp='git grep'
				alias de='git diff --ignore-space-change'
				alias me='git merge'
				alias bh='git branch'
				alias ct='git checkout'
```

- ## Vim ##
	1. [Custom vimrc](https://github.com/amix/vimrc) - in Amix's words, "The Ultimate vimrc"
		
		
		
		
		
		
		
		
		