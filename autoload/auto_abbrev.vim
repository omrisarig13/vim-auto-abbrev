" Script Globals {{{
if g:auto_abbrev_use_file
    let s:abbrev_file_name = g:auto_abbrev_file_path
else
    let s:abbrev_file_name = ""
endif

" }}}

" Functions {{{

" Internal Functions {{{

" Function s:create_abbrev_command {{{
" @brief Create the abbreviate command that should run according to the lhs and
"  rhs of the command.
" @param lhs - The lhs value for the abbrev command.
" @param rhs - The rhs value for the abbrev command.
" @return The abbreviate command that should run in order to add the wanted
"  abbreviate to the system.
" @note This function was created mainly to allow support in the future for the
"  option to use something else as the abbreviate command.
function! s:create_abbrev_command(lhs, rhs)
    return "abbreviate " . a:lhs . " " . a:rhs
endfunction
" Function s:create_abbrev_command }}}

" Function s:apply_abbrev_command {{{
" @brief Apply the abbrev command to the system. This function would both run
"  the command in the system, and add the command to the abbreviates file, so
"  it would be loaded automatically in the future.
" @param abbrev_command - The abbreviate command that should be applied.
" @param abbrev_file_name - The file name of the abbreviate file, to add the new
"  command into. Empty file name would mean that no file would be updated with
"  the new abbrev.
" @return None
function! s:apply_abbrev_command(abbrev_command, abbrev_file_name)
    if !empty(a:abbrev_file_name)
        call writefile([a:abbrev_command], a:abbrev_file_name, "a")
    endif
    execute a:abbrev_command
endfunction
" Function s:apply_abbrev_command }}}

" Function s:change_current_abbrev {{{
" @brief Replace all the instances of the old abbrev with this new abbrev.
" @param old_value - The value before the abbreviate command.
" @param new_value - The value that should be after the abbrev command.
" @return None
function! s:change_current_abbrev(old_value, new_value)
    " Replace all the values of the previous abbreviate. Without warnings in
    " case there are none.
    execute "%s/\\<" . a:old_value . "\\>/" . a:new_value . "/gIe"
    " Replace to the position before the substitute command took place.
    norm ``
endfunction
" Function s:change_current_abbrev }}}

" Internal Functions }}}

" Exported Functions {{{

" Function: auto_abbrev#add_abbrev {{{
" @brief Add a new abbreviate to the abbreviates file.
" @param abbrev - The value to add as the lhs value of the abbreviate command
" @param full_name - The value to add as the rhs value of the abbreviate
"  command
" @return None
function! auto_abbrev#add_abbrev(abbrev, full_name)
    let l:command = s:create_abbrev_command(a:abbrev, a:full_name)

    call s:apply_abbrev_command(l:command, s:abbrev_file_name)

    if g:auto_abbrev_should_fix_abbrev
        call s:change_current_abbrev(a:abbrev, a:full_name)
    endif
endfunction
" Function: auto_abbrev#add_abbrev }}}

" Exported Functions }}}

" Functions }}}
