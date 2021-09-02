# vim-log-print

Like a **commenter plugin**, but for **log/print** statements

Meant for the *quick and dirty* debug.

## Installation

Use any **plugin manager** (vim-plug, dein, ...) or use Vims **built-in plugin system**.

**Optional:**

Install https://github.com/Shougo/context_filetype.vim as well for **embedded filetypes**, eg. javascript in html.

## Features

* **preserve indentation**
* **preserve semicolon** at end of line
* **toggle** on and off
* add **below or above** on a new line
* define your **own language specific strings**
* define your **own cursor position**
* puts **cursor at a good spot** by default
* goes into **insert mode** when calling on an **empty/new line**
* **optional support** for [**context_filetype**](https://github.com/Shougo/context_filetype.vim) (this might be unstable)
		
## Usage

See [Defaults](#Defaults) to turn default mappings off.

* `gl` to **toggle** the logprint string for the current line.

* `]g` to make a new line **below** with the logprint string and go in insert mode.

* `[g` same but **above**.

`gl` **isn't used** in vim by default.

`]g` and `[g` are in [unimpaired](https://github.com/tpope/vim-unimpaired) style and also **not used** by vim or unimpaired.

### Example
```javascript
// example for javascript
// | is cursor
te|st();
// press gl
console.log(test()|);
// press gl again
test()|;
// press ]g
// goes into insert mode
test();
console.log(|);

// empty line with indentation
		|
// press gl
// doesn't add the semicolon, only preserves it if it's already there (you can change this)
// goes into insert mode if nothing is wrapped
		console.log(|)
// press gl again (in normal mode)
		|
```
```c
// example c
te|st();
// press gl (goes into insert for c by default, see #Defaults)
printf("%|", test());
// press d<esc>
printf("%d|", test());
// press gl again
test();
```

## Defaults

```vim
" turn default mappings on=1/off=0
let g:log_print#default_mappings = 1

" if you dont like it turn default mappings off and make your own mapping
nnoremap <silent> gl <esc>:<c-u>LogPrintToggle<cr>
nnoremap <silent> [g <esc>:<c-u>LogPrintAbove<cr>
nnoremap <silent> ]g <esc>:<c-u>LogPrintBelow<cr>

" add your own languages strings in here in your vimrc
" keys must match filetypes, values must be dict with specific keys
let g:log_print#languages = {}

" keys in g:log_print#languages override keys in here
let s:default_languages = #{
	\ vim: #{pre:"echomsg "}, " one string
	\ python: #{pre:"print(", post:")"}, " two strings
	\ javascript: #{pre:"console.log(", post:")"},			

	" pre contains | which specifies cursor position after adding
	" if preremove and postremove are given they are used as regex for removal
	" this is necessay when you plan to modify the added strings, else toggling off will fail
	" also note in postremove the semicolon is omitted, so it stays behind after removing
	" if insert = 1 it always goes into insert mode
	\ c: #{insert:1, pre:'printf("%|", ', post:');', preremove:'printf(".*", ', postremove:')'},

	" in pre and post the 'set magic' characters are escaped properly so having eg \n works
	" when toggling off, only the last token surrounded (<< token <<) will remain + semicolon
	\ cpp: #{pre:"std::cout << |", post:' << "\n";', preremove:'std::cout.*<<\s', postremove:'\s<<[^;]*'},
	\ }

" if nothing is defined for the filetype, it uses #{pre:"print(", post:")"}
```

## Caveats

A lot of this functionality can be done with a **snippet plugin** 
like **ultisnips or vsnip**.

The logprint string is determined every time you invoke the command based on 
the value of `&l:filetype or context_filetype#get_filetype()`. 
This means there are **no autocmds** involved, but there is a **slight overhead**
for every call to the plugin.

Toggling the string on in a non empty line should rarely be useful, because in a logprint
usually goes an expression, however you don't usually have expressions laying 
around in your code, without using them somehow.

## Related Projects

https://github.com/mptre/vim-printf

https://github.com/polarmutex/contextprint.nvim
