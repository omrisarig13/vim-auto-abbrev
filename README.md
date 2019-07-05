# vim-auto-abbrev

## Introduction
Abbreviations are a great vim feature to automatically fix common typos.
However, it is very annoying to add them all one by one, and it cuts off
the workflow in the middle every time you are adding a new abbreviate to the
config.

This plugin is here to solve this problem. The plugin enables you to add
abbreviate as you work, without starting to change the files and buffers you
are in. This plugin have API that would let you add the abbreviations as you
encounter them, without more work than the work that you would have invested
just to fix typo in the word.

## Usage

TODO

## Installation
You can use your favorite plugin manager to install this plugin, as any other
plugin.

Couple of examples:
### [Vundle](https://github.com/VundleVim/Vundle.vim)
Add this line to one of the files loaded when opening vim:
``` vimscript
Plugin 'omrisarig13/vim-auto-abbrev'
```

### [pathogen.vim](https://github.com/tpope/vim-pathogen)
``` bash
git clone https://github.com/omrisarig13/vim-auto-abbrev.git ~/.vim/bundle/vim-auto-abbrev
```
Than reload Vim and run `:helptags ~/.vim/bundle/vim-auto-abbrev/doc/` in it.


