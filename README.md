# How to use alias

Include the following line in __.bashrc__ to include __.bash_aliases__ symbolic link to __home/.bash_aliases__ file located in this repository which will also include all the other files named **.bash_aliases_***.

```sh
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```
These symbolic links will be created in your home directory by __update-symbolic-links__ command:

```sh
$ ./update-symbolic-links
```
