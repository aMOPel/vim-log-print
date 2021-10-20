if exists("g:loaded_log_print") || v:version < 700
	finish
endif
let g:loaded_log_print = 1

if !exists("g:log_print#default_mappings")
	let g:log_print#default_mappings = 1
endif

let s:installed_context_filetype = (globpath(&runtimepath, 'autoload/context_filetype.vim') !=# '')

let s:default_languages = #{
	\ python: #{pre:"print(", post:")"},
	\ javascript: #{pre:"console.log(", post:")"},
	\ vim: #{pre:"echomsg "},
	\ c: #{insert:1, pre:'printf("%|", ', post:');', preremove:'printf(".*", ', postremove:')'},
	\ cpp: #{pre:"std::cout << |", post:' << "\n";', preremove:'std::cout.*<<\s', postremove:'\s<<[^;]*'},
	\ }

function! s:escape(str)
	return escape(a:str, '^$.*~\[]')
endfunction

function! s:get_languages() abort
	let d = {}
	call extend(d, s:default_languages)
	if exists("g:log_print#languages")
		call extend(d, g:log_print#languages)
	endif
	return d
endfunction

function! s:toggle() abort
	let line_nr = line('.')
	let str = getline(line_nr)
  if s:installed_context_filetype
    let conft = context_filetype#get_filetype()
  else
    let conft = &l:filetype
  endif
	let wrap = has_key(s:get_languages(), conft) ? s:get_languages()[conft] : s:get_languages().python
	if has_key(wrap, 'preremove') && has_key(wrap, 'postremove')
		let i = get(wrap, 'preremove', '')
	else
		let i = s:escape(substitute(get(wrap, 'pre', ''), '|', '', ""))
	endif
	if match(str, i) == -1
		call s:add(wrap)
	else
		call s:remove(wrap)
	endif
endfunction

function! s:remove(wrap) abort
	let line_nr = line('.')
	let str = getline(line_nr)
	if has_key(a:wrap, 'preremove') && has_key(a:wrap, 'postremove')
		let i = get(a:wrap, 'preremove', '')
		let j = get(a:wrap, 'postremove', '')
	else
		let i = s:escape(substitute(get(a:wrap, 'pre', ''), '|', '', ""))
		let j = s:escape(get(a:wrap, 'post', ''))
	endif
	let matches = matchlist(str, '^\(.*\)' . i . '\(.*\)' . j . '\(.*\)$')
	let unwrapped = matches[1] . matches[2] . matches[3]
	call setline(line_nr, unwrapped)
endfunction

function! s:add(wrap) abort
	let line_nr = line('.')
	let str = getline(line_nr)

	let matches = matchlist(str, '\v^(\s*)([^;]*)(;?)$')

	let cursor_index = match(get(a:wrap, 'pre', ''), '|')

	let i = substitute(get(a:wrap, 'pre', ''), '|', '', "")
	let j = get(a:wrap,'post', '')

	let semicolon = get(a:wrap, 'post', '')[-1] == ';' ? matches[3] : ''
	let wrapped = matches[1] . i . matches[2] . j . semicolon
	call setline(line_nr, wrapped)
	if cursor_index >= 0
		call cursor(line_nr, strchars(matches[1]) + cursor_index + 1)
	else 
		call cursor(line_nr, strchars(matches[1]) + strchars(matches[2]) + strchars(get(a:wrap, 'pre', '')) + 1)
	endif
	if strchars(matches[2]) == 0
		if wrapped == matches[1] . get(a:wrap, 'pre', '')
			startinsert!
		else
			startinsert
		endif
	elseif get(a:wrap, 'insert')
		startinsert
	endif
endfunction

function! s:toggle_new_line(above) abort
	let line_nr = line('.')
	let str = getline(line_nr)
	let indent = matchlist(str, '\v^(\s*)')
	echomsg indent
	if a:above
		norm O
	else
		norm o
		let line_nr += 1
	endif
	call setline(line_nr, indent[1])
	call s:toggle()
endfunction

command! LogPrintToggle call s:toggle()
command! LogPrintBelow call s:toggle_new_line(0)
command! LogPrintAbove call s:toggle_new_line(1)

nnoremap <Plug>LogPrintToggle <esc>:<c-u>LogPrintToggle<cr>
nnoremap <Plug>LogPrintAbove <esc>:<c-u>LogPrintAbove<cr>
nnoremap <Plug>LogPrintBelow <esc>:<c-u>LogPrintBelow<cr>

if g:log_print#default_mappings
	nmap <silent> gl <Plug>LogPrintToggle
	nmap <silent> [g <Plug>LogPrintAbove
	nmap <silent> ]g <Plug>LogPrintBelow
endif
