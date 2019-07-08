" vim-auto-abbrev - Automatically add abbreviates to your config files.
" Maintainer: Omri Sarig <omri.sarig13@gmail.com>
" Version:    1.0
" License:    MIT
" Website:    https://github.com/omrisarig13/vim-auto-abbrev

" Global Variables {{{

if exists('g:loaded_auto_abbrev') && g:loaded_auto_abbrev
    finish
endif
let g:loaded_auto_abbrev = v:true

if !exists('g:auto_abbrev_use_file')
    let g:auto_abbrev_use_file = v:true
endif

if !exists('g:auto_abbrev_file_path')
    let g:auto_abbrev_file_path = expand('~/.vim/abbrevatives')
else
    let g:auto_abbrev_file_path = expand(g:auto_abbrev_file_path)
endif

if !exists('g:auto_abbrev_should_fix_abbrev')
    let g:auto_abbrev_should_fix_abbrev = v:true
endif

" Global Variables }}}

" Commands {{{

command! -nargs=0 AutoAbbrevAddCurrentWord call auto_abbrev#add_current_word()
command! -nargs=* AutoAbbrevAddAbbrev call auto_abbrev#add_abbrev(<f-args>)

" Commands }}}

" Plugin preparing {{{
" Validate that the abbrev file is writable, create it if it does not exist.
if g:auto_abbrev_use_file
    let s:writeable_results = filewritable(g:auto_abbrev_file_path)
    if s:writeable_results == 0
        if filereadable(g:auto_abbrev_file_path)
            echoerr "vim-auto-abbrev: Abbrev file is not writeable"
            finish
        else
            call writefile([], g:auto_abbrev_file_path)
        endif
    elseif s:writeable_results == 2
        echoerr "vim-auto-abbrev: Abbrev file is a directory."
    endif
endif
" Plugin preparing }}}
