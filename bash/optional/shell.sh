#!/bin/bash

# Enable Bash Completion support on zsh
IF_ZSH 'autoload bashcompinit; bashcompinit'

# Enable Bash Completion
if [[ -z "$(which complete 2>/dev/null)" ]] && [[ $(uname) == 'Darwin' ]]; then
	# Bash Completion
	if [[ -f "$(brew --prefix)/etc/bash_completion" ]]; then
		bash "$(brew --prefix)/etc/bash_completion"
	fi
fi

# Store much more bash history (default is 500)
export HISTFILESIZE=40000

# Ignore duplicate lines
export HISTCONTROL=erasedups

if [[ "$0" =~ bash$ ]]; then

    # Ignore case when doing bash completion
    #bind "set completion-ignore-case"

    # Auto-append the history on shell exit
    shopt -s histappend

    # Try and keep multi-line commands in good shape in the history
    shopt -s lithist
    shopt -s cmdhist

    # Auto correct simple misspellings
    shopt -s cdspell
    #shopt -s dirspell

    # Complete hostname when typing
    shopt -s hostcomplete
fi

# More easily view logs with less
#export LESSOPEN="|sed -r 's/(---|\\\r\\\n\"?|\" \")/\n/g' '%s'"
export LESSOPEN="|sed -r 's/(---|\\\r\\\n\"?)/\n/g' '%s' | sed 's/\" \"//g'"

# Follow symlinks
function ff() {
	LINK=$(readlink -f "$(which "$1")")
	LINK_PWD=$(dirname "$LINK")
	pushd "$LINK_PWD"
}


# Easier process search
function au() {
	cmd="sudo ps Awwl"
	if [ "${1}" -eq "${1}" ] 2>/dev/null; then
		cmd="${cmd} ${1}"
	else
		cmd="${cmd} | head -n1 &&
			 ${cmd} | grep --ignore-case --color=auto ${1} | head -n-1"
	fi
	eval "${cmd}"
}

function _du() {
	DEPTH=1
	DIR=.
	while getopts ':d:h' opt; do
		case $opt in
			d)
			    DEPTH=$OPTARG
			    ;;
			h)
				echo "Usage: $0 [-d maxdepth] [dir=.]" >&2
				return 1
		      ;;
		    \?)
		      echo "Invalid option: -$OPTARG" >&2
		      ;;
		  esac
	done
	shift "$((OPTIND-1))"
	DIR="${*:-.}"

    du -hd "$DEPTH" "$DIR"/ | sort -h
}

function lscount {
	MAXDEPTH=0
	DIR=.
	while getopts ':d:h' opt; do
		case $opt in
			d)
			    MAXDEPTH=$OPTARG
			    ;;
			h)
		      echo "Usage: $0 [-d maxdepth] [dir=.]" >&2
			  return 1
		      ;;
		    \?)
		      echo "Invalid option: -$OPTARG" >&2
		      ;;
		  esac
	done
	shift "$((OPTIND-1))"
	DIR="${*:-.}"

	find "$DIR" -maxdepth "$MAXDEPTH" -type d -print0 | while read -d '' -r dir; do
		num=$(find "$dir" -ls | wc -l);
		printf "%5d files in directory %s\n" "$num" "$dir";
	done
}

function memcachetop() {
    if [[ "$1" == "-h" ]]; then echo "Usage: $0 [socket=/tmp/memcached.sock]"; return 1; fi
    SOCK=${1:-/tmp/memcached.sock}
    if [[ -S "$SOCK" ]]; then
        MEMCACHED="nc -U $SOCK"
    else
        HOST=${2:-localhost}
        PORT=${2:-11211}
        MEMCACHED="nc $HOST $PORT"
    fi
    watch "$(<<EOF
		echo 'stats' | $MEMCACHED |
		awk '/cmd_get|get_misses/ {print \$3}' | sed -E 's@[\r\s\n ]+@/@g' | xargs -n2 |
		sed -E 's@(/\$)|[ ]+@@g' | sed -E 's@^(.*?)/@(1-\1)/@' |
		bc -l | cut -c1-5 | xargs echo 'Cache Hit Rate (%):'
EOF
	)"
}

# Show the commands you use most (http://lifehacker.com/202712/review-your-most-oft-used-unix-commands)
function history_ranked() {
    history 0 | awk '{print $2}' | awk 'BEGIN {FS="|"} {print $1}' | sort | uniq -c | sort -r
}

# Helpful command for printing a filetree from the current directory
alias filetree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"


# Useful sed string for replacing newlines in the input
alias sed_regex_replace_nl=':a;N;$!ba;s/\n/ /g'


# More helpful whois
alias gwhois="whois -h geektools.com"

# Use html instead of pdf for manp viewing
function manp() {
    MANP_DIR=~/Library/Mobile\ Documents/iCloud~com~pspdfkit~viewer/Documents
    mkdir -p "${MANP_DIR}"
    groffer --man --www --www-viewer="bash -c 'mv -f -t \"${MANP_DIR}\" \${1} && open -a Google\ Chrome \"${MANP_DIR}/\$(basename \${1})\"' bash" "$1" &
    echo "Generating HTML-formatted manpage in the background..."
    echo "It will be saved to ${MANP_DIR}"
    echo "Google Chrome will open with the generated document when finished."
}

# transfer.sh - simple uploading from the shell
function transfer() {
    if [ $# -eq 0 ]; then
        printf "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    INFILE=$1
    local basefile

    if tty -s; then
        basefile=$(basename "$INFILE" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
        curl --progress-bar --upload-file "$INFILE" "https://transfer.sh/$basefile" | pbcopy
    else
        curl --progress-bar --upload-file "-" "https://transfer.sh/$INFILE" | pbcopy
    fi
    pbpaste
}
