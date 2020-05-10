# more aliases
alias ll='ls -alF --block-size=M'
alias la='ls -A'
alias l='ls -CF'
alias sudo='sudo '
alias aptupgrade='sudo apt update ; sudo apt upgrade -y ; sudo apt dist-upgrade -y ; sudo apt autoremove -y ; sudo apt autoclean; sudo apt -f install -y'
alias upg='aptupgrade '
alias shutnow='sudo halt -p'
alias reboot='sudo reboot'
alias ip='ip -c'
alias diff='diff --color'
alias grep='grep --color'
alias ssh-login-passwd='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
alias ssh-login-identity='ssh -o "IdentitiesOnly=yes"'

alias listenports='sudo netstat -ntulp'

# source all files starting with ".bash_aliases_"
CUR_DIR="$( cd "$(dirname "$0" 2>/dev/null)" >/dev/null 2>&1 ; pwd -P )"
for FILE_BASH_ALIASES in $(find "$CUR_DIR" -maxdepth 1 -type f -name '.bash_aliases_*' 2>/dev/null); do
    . "$FILE_BASH_ALIASES";
done;
