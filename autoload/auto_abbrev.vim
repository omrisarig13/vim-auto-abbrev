" Functions {{{

" Internal Functions {{{

" Function s:get_right_abbrev {{{
" @brief Get the wanted abbreviate from the user, according to the lhs value it
"  gave.
" @param abbrev - The lhs value as inserted by the user.
" @return The rhs value for the abbreviate command. It would return empty string
"  in case the user hasn't inserted any.
" @note This function waits for input from the user, and won't continue without
"  input from him.
function! s:get_right_abbrev(abbrev)
    let l:message = "Insert the right word for '" . a:abbrev . "' (empty to cancel):"
    let l:right_word = input(l:message)
    return l:right_word
endfunction
" Function s:get_right_abbrev }}}

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

" Function s:remove_lines_from_file {{{
" @brief Remove the given lines from the file, by the line numbers.
" @param file_name - The name of the file to remove the line from.
" @param line_numbers - A list containing all the line numbers to remove.
" @return None
function! s:remove_lines_from_file(file_name, line_numbers)
    let l:file_without_lines = []
    let l:line_number = 0
    for l:line in readfile(a:file_name)
        let l:line_number += 1
        if index(a:line_numbers, l:line_number) < 0
            call add(l:file_without_lines, l:line)
        endif
    endfor
    call writefile(l:file_without_lines, a:file_name)
endfunction
" Function s:remove_lines_from_file }}}

" Function s:decrease_values_above {{{
" @brief Decrease all the values above the given value in the dict by the given
"  value.
" @param dict_to_decrease - The dict to decrease the values in.
" @param value - The value to decrease all the values above.
" @param decrease_value - The value to decrease all the values by.
" @return None
" @note The dict would change in the function.
function! s:decrease_values_above(dict_to_decrease, value, decrease_value)
    for [l:key, l:value] in items(a:dict_to_decrease)
        if l:value > a:value
            let a:dict_to_decrease[l:key] = l:value - a:decrease_value
        endif
    endfor
endfunction
" Function s:decrease_values_above }}}

" Function s:remove_old_abbrev {{{
" @brief Removes the old abbrev from the dictionary and the file, to let the
"  new abbrev take its place.
" @param file_name - The name of the file to remove the abbrev from.
" @param abbrev_dict - The dictionary with all the abbrev names.
" @param abbrev - The name of the abbrev to remove from the dict.
" @return None
" @note If there is no such abbrev in the dictionary, the function would do
"  nothing.
" @note The function would update the dict with the new line numbers of all the
"  abbrevs in it, since they might change after a line is removed.
function! s:remove_old_abbrev(file_name, abbrev_dict, abbrev)
    if has_key(a:abbrev_dict, a:abbrev)
        let l:abbrev_line_number = a:abbrev_dict[a:abbrev]
        call remove(a:abbrev_dict, a:abbrev)
        call s:remove_lines_from_file(a:file_name, [l:abbrev_line_number])
        call s:decrease_values_above(a:abbrev_dict, l:abbrev_line_number, 1)
    endif
endfunction
" Function s:remove_old_abbrev }}}

" Function s:save_only_last {{{
" @brief The moves on the file, and saves only the last abbrev of its kind in
"  the file. It would add this abbrev to the dict, and remove any old abbrev 
"  from it.
" @param file_name - The name of the file with the abbrev in.
" @param abbrev_dict - The dictionary with all the abbrev names.
" @param abbrev - The name of the abbrev to update
" @return None
" @note The function changes the abbrev_dict it gets.
" @note The function assumes that the given abbrev appears in the file at least
"  once.
function! s:save_only_last(file_name, abbrev_dict, abbrev)
    let l:current_line_number = 0
    let l:abbrev_regex = '.*abbreviate ' . a:abbrev
    let l:abbrev_lines = []
    for l:current_line in readfile(a:file_name)
        let l:current_line_number += 1
        " Check if the current line is the line with the abbrev.
        if l:current_line =~ l:abbrev_regex
            call add(l:abbrev_lines, l:current_line_number)
        endif
    endfor
    let l:right_line = l:abbrev_lines[-1]
    let a:abbrev_dict[a:abbrev] = l:right_line
    let l:wrong_lines = l:abbrev_lines[:-2]
    call s:remove_lines_from_file(a:file_name, l:wrong_lines)
    for l:current_line in l:wrong_lines
        call s:decrease_values_above(a:abbrev_dict, l:current_line, 1)
    endfor
endfunction
" Function s:save_only_last }}}

" Function s:get_abbrev_dict {{{
" @brief Get a dict with all the abbreviates in the given file. The dict
"  would include the abbrev as the key, with the abbrev line number as the
"  value.
" @param file_path - The path of the file to list the abbrevs of.
" @return A dict with all the abbrevs from the file.
function! s:get_abbrev_dict(file_path)
    let l:abbrev_dict = {}
    let l:line_number = 0
    " Move over all the lines in the file
    for l:line in readfile(a:file_path)
        let l:line_number +=1
        " Check if the current line is an abbrev line
        if l:line =~ '.*abbreviate \w\w\+'
            " Get the word from the line.
            let l:words = split(l:line)
            let l:abbrev_value = 0
            for l:word in l:words
                let l:abbrev_value += 1
                if l:word ==# "abbreviate"
                    let l:current_word = l:words[l:abbrev_value]
                endif
            endfor

            " Remove the previous word in case it exists
            if has_key(l:abbrev_dict, l:current_word)
                call s:remove_old_abbrev(
                    \ a:file_path, l:abbrev_dict, l:current_word)
                let l:line_number -= 1
            endif

            " Add the new word to the file.
            let l:abbrev_dict[l:current_word] = l:line_number
        endif
    endfor
    return l:abbrev_dict
endfunction
" Function s:get_abbrev_dict }}}

" Internal Functions }}}

" Exported Functions {{{

" Function: auto_abbrev#add_current_word {{{
" @brief Add the current word as an abbreviated lhs value.
" @return None
function! auto_abbrev#add_current_word()
    let l:saved_unnamed_register = @@
    " Get the current word.
    execute "normal! yiw"
    let l:current_word = @@

    " Call the interactive add abbrev.
    call auto_abbrev#interactive_add_abbrev(l:current_word)

    let @@ = l:saved_unnamed_register
endfunction
" Function: auto_abbrev#add_current_word }}}

" Function: auto_abbrev#add_current_lhs_word {{{
" @brief Save the current word as an lhs value.
"  This function would be used together with auto_abbrev#add_current_rhs_word.
"  The other function would be called in the future. When the other function
"  would be called, the abbreviate that include this word as the lhs word would
"  be added.
" @return None
function! auto_abbrev#add_current_lhs_word()
    " Save the original register, to restore it at the end.
    let l:saved_unnamed_register = @@

    " Save the current word.
    execute "normal! yiw"
    let s:current_lhs = @@

    let @@ = l:saved_unnamed_register
endfunction
" Function: auto_abbrev#add_current_lhs_word }}}

" Function: auto_abbrev#add_current_rhs_word {{{
" @brief Add the current word as the rhs of the current abbreviate.
"  This function should be called after the function
"  auto_abbrev#add_current_lhs_word. It would add a new abbreviate for the lhs
"  saved value, with the current word as the rhs value of it.
" @return None
function! auto_abbrev#add_current_rhs_word()
    " Save the original register, to restore it at the end.
    let l:saved_unnamed_register = @@

    " Get the current word.
    execute "normal! yiw"
    let l:current_rhs = @@

    " Add the new abbrev pair.
    if empty(s:current_lhs)
        echohl WarningMsg
        echom "AutoAbbrev: Can't add rhs abbrev without lhs word."
        echohl None
    else
        call auto_abbrev#add_abbrev(s:current_lhs, l:current_rhs)
        let s:current_lhs = ''
    endif

    " Restore the original register.
    let @@ = l:saved_unnamed_register
endfunction
" Function: auto_abbrev#add_current_rhs_word }}}

" Function: auto_abbrev#interactive_add_abbrev {{{
" @brief Add a new abbreviate to the abbreviates file, getting the wanted
"  value from the user.
" @param abbrev - The value to add as the lhs value of the abbreviate command
" @return None
function! auto_abbrev#interactive_add_abbrev(abbrev)
    " Get the rhs value of the abbrev from the user.
    let l:right_word = s:get_right_abbrev(a:abbrev)

    " Add the abbreviate to the system.
    if !empty(l:right_word)
        call auto_abbrev#add_abbrev(a:abbrev, l:right_word)
    endif
endfunction
" Function: auto_abbrev#interactive_add_abbrev }}}

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

    if g:auto_abbrev_support_deletion
        call s:save_only_last(s:abbrev_file_name, s:abbrev_dict, a:abbrev)
    endif
endfunction
" Function: auto_abbrev#add_abbrev }}}

" Function: auto_abbrev#load_abbrev {{{
" @brief Load the abbreviates from the file. The function would source the file,
"  and load any abbreviates from it to the abbrev dict, if the option of
"  g:auto_abbrev_support_deletion is set.
" @return None
function! auto_abbrev#load_abbrev()
    if !empty(s:abbrev_file_name)
        execute "source " . s:abbrev_file_name
    endif
    if g:auto_abbrev_support_deletion
        let s:abbrev_dict = s:get_abbrev_dict(s:abbrev_file_name)
    endif
endfunction
" Function: auto_abbrev#load_abbrev }}}

" Exported Functions }}}

" Functions }}}

" Script Globals {{{
if g:auto_abbrev_use_file
    let s:abbrev_file_name = g:auto_abbrev_file_path
else
    let s:abbrev_file_name = ""
endif
let s:current_lhs = ""

call auto_abbrev#load_abbrev()
" }}}
