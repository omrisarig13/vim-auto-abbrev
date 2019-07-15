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

if !exists('g:auto_abbrev_source_abbrev_file')
    let g:auto_abbrev_source_abbrev_file = v:true
endif

if !exists('g:auto_abbrev_support_deletion')
    let g:auto_abbrev_support_deletion = v:true
endif

if !exists('g:auto_abbrev_add_current_word_map')
    let g:auto_abbrev_add_current_word_map = '<leader>aa'
endif

if !exists('g:auto_abbrev_add_current_word_map_used')
    let g:auto_abbrev_add_current_word_map_used = v:true
endif

if !exists('g:auto_abbrev_add_current_lhs_word_map')
    let g:auto_abbrev_add_current_lhs_word_map = '<leader>al'
endif

if !exists('g:auto_abbrev_add_current_lhs_word_map_used')
    let g:auto_abbrev_add_current_lhs_word_map_used = v:true
endif

if !exists('g:auto_abbrev_add_current_rhs_word_map')
    let g:auto_abbrev_add_current_rhs_word_map = '<leader>ar'
endif

if !exists('g:auto_abbrev_add_current_rhs_word_map_used')
    let g:auto_abbrev_add_current_rhs_word_map_used = v:true
endif

if !exists('g:auto_abbrev_reload_map')
    let g:auto_abbrev_reload_map = '<leader>ae'
endif

if !exists('g:auto_abbrev_reload_map_used')
    let g:auto_abbrev_reload_map_used = v:true
endif

" Global Variables }}}

" Commands {{{

command! -nargs=0 AutoAbbrevAddCurrentWord call auto_abbrev#add_current_word('command')
command! -nargs=0 AutoAbbrevAddCurrentLhsWord call auto_abbrev#add_current_lhs_word('command')
command! -nargs=0 AutoAbbrevAddCurrentRhsWord call auto_abbrev#add_current_rhs_word('command')
command! -nargs=* AutoAbbrevAddAbbrev call auto_abbrev#add_abbrev(<f-args>)
command! -nargs=* AutoAbbrevReload call auto_abbrev#load_abbrev()
command! -nargs=1 AutoAbbrevDelAbbrev call auto_abbrev#del_abbrev(<f-args>)

" Commands }}}

" Mappings {{{

if g:auto_abbrev_add_current_word_map_used && !empty(g:auto_abbrev_add_current_word_map)
    execute "nnoremap " . g:auto_abbrev_add_current_word_map . " :AutoAbbrevAddCurrentWord<cr>"
    execute "vnoremap " . g:auto_abbrev_add_current_word_map . " :<c-u>call auto_abbrev#add_current_word(visualmode())<cr>"
endif

if g:auto_abbrev_add_current_lhs_word_map_used && !empty(g:auto_abbrev_add_current_lhs_word_map)
    execute "nnoremap " . g:auto_abbrev_add_current_lhs_word_map . " :AutoAbbrevAddCurrentLhsWord<cr>"
    execute "vnoremap " . g:auto_abbrev_add_current_lhs_word_map . " :<c-u>call auto_abbrev#add_current_lhs_word(visualmode())<cr>"
endif

if g:auto_abbrev_add_current_rhs_word_map_used && !empty(g:auto_abbrev_add_current_rhs_word_map)
    execute "nnoremap " . g:auto_abbrev_add_current_rhs_word_map . " :AutoAbbrevAddCurrentRhsWord<cr>"
    execute "vnoremap " . g:auto_abbrev_add_current_rhs_word_map . " :<c-u>call auto_abbrev#add_current_rhs_word(visualmode())<cr>"
endif

if g:auto_abbrev_reload_map_used && !empty(g:auto_abbrev_reload_map)
    execute "nnoremap " . g:auto_abbrev_reload_map . " :AutoAbbrevReload<cr>"
endif

" Mappings }}}

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

" Source the abbreviates file if needed.
if g:auto_abbrev_source_abbrev_file
    execute "source " . g:auto_abbrev_file_path
endif
" Plugin preparing }}}
