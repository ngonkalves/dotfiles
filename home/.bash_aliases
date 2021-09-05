
# common alias
alias sudo='sudo '
alias ll='ls -alF --block-size=M'
alias la='ls -A'
alias l='ls -CF'
alias ip='ip -c'
alias diff='diff --color'
alias free='free -ht'
alias df='df -Tha --total'
alias df-dev='\df -h | \tee >(\head -n 1) >(\grep "^/dev") > /dev/null'
alias du='\du -sxh'
alias du-sort='\du -sxh * | sort -h'
alias du-recursive='\du -acxh | sort -h'
alias netstat-open-ports='sudo netstat -ntulp'
alias netstat-open-connections='sudo \netstat -natu | \tee >(\head -n 2) >(\egrep "(ESTABLISHED|TIME_WAIT)") > /dev/null'
alias mount-dev='mount | \egrep "^/"'
alias curl-ip='curl https://ifconfig.me/'

# vi alias to vim when installed
type vim > /dev/null 2>&1 && alias vi='vim'
type vim > /dev/null 2>&1 && alias sudovi='sudo -E vi'

# top
type htop > /dev/null 2>&1 && alias top='htop'

# apt alias
type apt > /dev/null 2>&1 && alias upg='sudo apt update ; sudo apt upgrade -y ; sudo apt dist-upgrade -y ; sudo apt autoremove -y ; sudo apt autoclean; sudo apt -f install -y'

# pacman alias
type pacman > /dev/null 2>&1 && alias upg='sudo pacman -Syu'

# reboot/shutdown
alias shutnow='sudo halt -p'
alias reboot='sudo reboot'

# grep
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color'

# lsof
alias lsof-listen='sudo lsof -OnP | grep LISTEN'

# ps
alias ps='ps auxf'
alias psg='\ps aux | grep -v grep | grep -i -e VSZ -e'

# ssh
alias ssh-login-passwd='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias ssh-login-identity='ssh -o "IdentitiesOnly=yes"'

# share files on the fly
type python > /dev/null 2>&1 && alias http-here-old='hostname -I && python -m SimpleHTTPServer 88'
type python3 > /dev/null 2>&1 && alias http-here='hostname -I && sudo python3 -m http.server 88'


# function to pull all git repos in a folder
function git-pull-all() {
    for FOLDER in $(find . -maxdepth 1); do if [[ -x $FOLDER/.git ]]; then echo $FOLDER; git -C $FOLDER pull --rebase; fi done;
}

# function to backup file
# Example: file.txt will be copied to file.txt.backup.YYYY.MM.DD_HH.MM.SS
function bckup {
    if [ -z "$1" ]; then
        echo "Usage: bckup <path/file_of_folder_name>"
        return 1
    fi
    if [ -e "$1" ]; then
        DATE=`date +"%Y.%m.%d_%H.%M.%S"`
        if [ -d "$1" ]; then 
            # folder
            \tar cvzf "${1//\//_}.$DATE.backup.tar.gz" "$1"
        elif [ -f "$1"]; then 
            # file
            \cp $1 "$1.$DATE.backup"
        fi
    fi
}

function tarballit {
    if [ -z "$1" ]; then
        echo "Usage: tarballit <path/file_name>"
        return 1
    fi
    if [ -e "$1" ]; then
        \tar cvzf "$1.tar.gz" "$1"
    fi
}

# extract any compressed file type (source: https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions)
function extract {
    if [ -z "$1" ]; then
       # display usage if no parameters given
       echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
       echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
       return 1
    else
       for n in $@
       do
         if [ -f "$n" ] ; then
             case "${n%,}" in
               *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                            tar xvf "$n"       ;;
               *.lzma)      unlzma ./"$n"      ;;
               *.bz2)       bunzip2 ./"$n"     ;;
               *.rar)       unrar x -ad ./"$n" ;;
               *.gz)        gunzip ./"$n"      ;;
               *.zip)       unzip ./"$n"       ;;
               *.z)         uncompress ./"$n"  ;;
               *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                            7z x ./"$n"        ;;
               *.xz)        unxz ./"$n"        ;;
               *.exe)       cabextract ./"$n"  ;;
               *)
                            echo "extract: '$n' - unknown archive method"
                            return 1
                            ;;
             esac
         else
             echo "'$n' - file does not exist"
             return 1
         fi
       done
    fi
}

# displays the command usage statistics
function history-stats {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}

#####################
# PS1 customization #
#####################

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="\[\e[01;36m\]\u\[\e[m\]\[\e[m\]@\[\e[m\]\[\e[01;32m\]\h\[\e[00;m\]:\[\e[01;34m\]\w\[\e[m\] \[\e[00;36m\]\`parse_git_branch\`\[\e[m\] \[\e[01;34m\]\\$\[\e[m\] "
######################
# /PS1 customization #
######################

# source all files starting with ".bash_aliases_"
CUR_DIR="$( cd "$(dirname "$0" 2>/dev/null)" >/dev/null 2>&1 ; pwd -P )"
for FILE_BASH_ALIASES in $(find "$CUR_DIR" -maxdepth 1 -type l -name '.bash_aliases_*' 2>/dev/null); do
    . "$FILE_BASH_ALIASES";
done;
