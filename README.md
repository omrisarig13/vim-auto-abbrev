# vim-auto-abbrev
Automate Abbreviates for you

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

This plugin have some commands and mapping that can be used to use the features
of the plugin.

### Commands:
* AutoAbbrevAddCurrentWord - Add the word under the cursor as abbreviate lhs,
    ask the user to insert the rhs value of the abbreviate.
* AutoAbbrevAddCurrentLhsWord - Save the current word as lhs abbreviate value,
    to later on add the rhs value of it.
* AutoAbbrevAddCurrentRhsWord - Add the current word as rhs abbreviate value,
    adding it as the abbreviate of the last saved lhs value.
* AutoAbbrevAddAbbrev - Add a new abbreviate. It get both the lhs value and the
    rhs value of the abbreviate.
* AutoAbbrevReload - Reload the abbreviate file, in case it was modified from
    other vim instance.
* AutoAbbrevDelAbbrev - Delete an abbreviate from the abbreviate file.

### Mappings:
* '<leader>aa' - call AutoAbbrevAddCurrentWord
* '<leader>al' - call AutoAbbrevAddCurrentLhsWord
* '<leader>ar' - call AutoAbbrevAddCurrentRhsWord
* '<leader>ae' - call AutoAbbrevReload

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

## Farther Reading
For father reading and explanation about all the plugin usage and possible
configuration read the help of the plugin (install it and then run 
`help auto-abbrev.txt`

## Contributing
If you want to contribute to the plugin, please do.
I welcome new ideas and would love to add more features to this plugin.

If you have an idea but you don't know how to implement it, you are more than
welcome to open in issue with it. If you have small feature that you want to
implement, you are welcome to write it and open a pull request.
If you want to add a major feature, it is recommended to open an issue first, to
validate with me that this feature is indeed reasonable for this plugin.

If you are going to add code to this plugin, please read
[CONTRIBUTING.md](contributing.md) first.
