# How to use alias

To use alias in you bash session you will need to include the main alias file __.bash_aliases__ in __.bashrc__ like in the line below:
```sh
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```
Then execute __update-symbolic-links__ command like:

```sh
$ ./update-symbolic-links
```
