# How to use alias

Include the following line in __.bashrc__ to include __.bash_aliases__ file which will also include all the other files named **.bash_aliases_***.

```sh
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```
Then execute __update-symbolic-links__ command:

```sh
$ ./update-symbolic-links
```
