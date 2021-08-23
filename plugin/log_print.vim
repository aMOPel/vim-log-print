
if exists("g:loaded_log_print") || v:version < 700
  finish
endif
let g:loaded_log_print = 1

let g:log_print#default_mappings = 1

let g:log_print#languages = {}

let s:default_languages = #{
			\ python: ["print(", ")"],
			\ javascript: ["console.log(", ")"],
			\ vim: ["echomsg "],
			\ }

function! s:get_languages() abort
	let d = {}
	call extend(d, s:default_languages)
	call extend(d, g:log_print#languages)
	return d
endfunction

function! s:toggle(wrap=["print(", ")"]) abort
	let line_nr = line('.')
	let str = getline(line_nr)
	if match(str, get(a:wrap, 0, '')) == -1
		call s:add(a:wrap)
	else
		call s:remove(a:wrap)
	endif
endfunction

function! s:remove(wrap=["print(", ")"]) abort
	let line_nr = line('.')
	let str = getline(line_nr)
	let matches = matchlist(str, '\(.*\)' . get(a:wrap, 0, '') . '\(.*\)' . get(a:wrap, 1, '') . '\(.*\)$')
	let unwrapped = matches[1] . matches[2] . matches[3]
	call setline(line_nr, unwrapped)
endfunction

function! s:add(wrap=["print(", ")"]) abort
	let line_nr = line('.')
	let str = getline(line_nr)
	let matches = matchlist(str, '\v^(\s*)([^;]*)(;?)$')
	let wrapped = matches[1] . get(a:wrap, 0, '') . matches[2] . get(a:wrap, 1, '') . matches[3]
	call setline(line_nr, wrapped)
	call cursor(line_nr, strchars(matches[1]) + strchars(matches[2]) + strchars(a:wrap[0]))
	if strchars(matches[2]) == 0
		if wrapped == matches[1] . get(a:wrap, 0, '') 
			startinsert!
		else
			startinsert
		endif
	endif
endfunction
echomsg 
command! LogPrintToggle eval has_key(s:get_languages(), &ft) ? s:toggle(get(s:get_languages(), &ft)) : s:toggle()

if g:log_print#default_mappings
	nnoremap <silent> gl <esc>:<c-u>LogPrintToggle<cr>
endif
