# vim-log-print

like commenter plugin, but for print/log statements

press `gl` to toggle the logprint string

`gl` isn't mapped in vim by default

## example

```javascript
// example for javascript
// | is cursor
te|st();
// press gl
console.log(test()|);
// press gl again
test()|;

// empty line with indentation
		|
// press gl
// doesn't add the semicolon, only preserves it if it's already there
// goes into insertmode if nothing is wrapped
		console.log(|)
// press gl again (in normal mode)
		|
```

## features

* preserve indentation
* preserve semicolon at end of line
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

" if nothing is defined for filetype, it uses ["print(", ")"]
```
