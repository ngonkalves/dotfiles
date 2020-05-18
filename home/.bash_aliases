# vi alias to vim when installed
type vim > /dev/null 2>&1 && alias vi='vim'

# common alias
alias ll='ls -alF --block-size=M'
alias la='ls -A'
alias l='ls -CF'
alias ip='ip -c'
alias diff='diff --color'
alias sudo='sudo '
alias netstat-open-ports='sudo netstat -ntulp'

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

# ssh
alias ssh-login-passwd='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias ssh-login-identity='ssh -o "IdentitiesOnly=yes"'

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

# source all files starting with ".bash_aliases_"
CUR_DIR="$( cd "$(dirname "$0" 2>/dev/null)" >/dev/null 2>&1 ; pwd -P )"
for FILE_BASH_ALIASES in $(find "$CUR_DIR" -maxdepth 1 -type l -name '.bash_aliases_*' 2>/dev/null); do
    . "$FILE_BASH_ALIASES";
done;
