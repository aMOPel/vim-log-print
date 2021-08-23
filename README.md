# vim-log-print

like commenter plugin, but for print/log statements

`gl` to toggle the logprint string

## features

* preserve indentation
* toggle on and off
* define your own language specific strings
* puts cursor before closing parenthesis
* goes into insert mode at the right spot when calling on an empty line

## defaults

```vim
" turn default mappings on/off
let g:log_print#default_mappings = 1

" if you dont like it turn default mappings off and make your own mapping
nnoremap <silent> gl <esc>:<c-u>LogPrintToggle<cr>

" add more languages strings in here in your rc
" key must match filetype, values must be array with 1 or 2 strings
let g:log_print#languages = {}

" keys in g:log_print#languages override keys in here
let s:default_languages = #{
			\ python: ["print(", ")"],
			\ javascript: ["console.log(", ")"],
			\ vim: ["echomsg "],
			\ }

" if nothing defined for filetype, it uses ["print(", ")"]
```
