# vi alias to vim when installed
type vim > /dev/null 2>&1 && alias vi='vim'

# common alias
alias ll='ls -alF --block-size=M'
alias la='ls -A'
alias l='ls -CF'
alias ip='ip -c'
alias diff='diff --color'
alias sudo='sudo '
alias listenports='sudo netstat -ntulp'

# apt alias
type apt > /dev/null 2>&1 && alias upg='sudo apt update ; sudo apt upgrade -y ; sudo apt dist-upgrade -y ; sudo apt autoremove -y ; sudo apt autoclean; sudo apt -f install -y'

# pacman alias
type pacman > /dev/null 2>&1 && alias upg='sudo pacman -Syu'

# reboot/shutdown
alias shutnow='sudo halt -p'
alias reboot='sudo reboot'

# grep
alias grep='grep --color'

# ssh
alias ssh-login-passwd='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias ssh-login-identity='ssh -o "IdentitiesOnly=yes"'

# source all files starting with ".bash_aliases_"
CUR_DIR="$( cd "$(dirname "$0" 2>/dev/null)" >/dev/null 2>&1 ; pwd -P )"
for FILE_BASH_ALIASES in $(find "$CUR_DIR" -maxdepth 1 -type l -name '.bash_aliases_*' 2>/dev/null); do
    . "$FILE_BASH_ALIASES";
done;
