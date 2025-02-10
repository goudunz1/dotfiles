" vim: fdm=marker :


" ==============================================================================
" File: vimrc
" Author: goudunz1
" Email: goudunz1@outlook.com
" Referrences:
" - https://github.com/chenxuan520/vim-fast
" ==============================================================================


let g:author = "goudunz1"
let g:email = "goudunz1@outlook.com"
let g:default_browser = "firefox"
iabbrev <expr> @@n g:author
iabbrev <expr> @@e g:email


" ==============================================================================
" [vim options] {{{

let mapleader = ","             " use ',' as leader key
set nocompatible                " disable legacy mode(vi)
filetype plugin indent on       " enable plugin and indent based on file types
syntax on                       " enable built-in highlight
set noerrorbells                " turn off error bells
set novisualbell                " turn off visual beeping
set cmdheight=1                 " height of the cmd line
set showcmd                     " show input in the cmd line
set textwidth=0                 " disable auto <cr>
set ruler                       " show cursor position in status line
set laststatus=2                " show status line
set number                      " show line numbers
set relativenumber              " show relative line numbers
"set whichwrap+=h,l              " cursor key can cross rows
set matchpairs+=<:>             " % can now detect <>
set backspace=indent,eol,start  " delete special characters freely
set virtualedit=block           " virtual select inside a tab
set showtabline=2               " show tab menu
set splitbelow                  " split new window below
set splitright                  " split new vertical window right
set mouse=                      " enable mouse
set clipboard=unnamed           " host clipboard (require gvim)
set wildmenu                    " better command auto completion
set colorcolumn=80              " 80 characters warning line
set autoindent                  " auto indent according to the previous line
set cindent                     " turn on indent for c-like languages
set cinoptions=g0,:0,N-s,E-s,(0 " see :help cinoptions
set smartindent                 " smartly choose indent way
set expandtab                   " soft tabs instead of tabs
set shiftwidth=4                " use 4 spaces for auto shift
set tabstop=4                   " set width of tab to 4
set softtabstop=4               " use 4 spaces for a soft tab
set smarttab                    " smartly shift with tabs and spaces
"set foldmethod=marker           " auto fold with marker pairs

set nowrap                      " disable line wrap if cursor too right
set sidescroll=1                " set number of columns to move if cursor too right
set sidescrolloff=1             " keep 1 visible column on the right
set scrolloff=1                 " keep 1 visible line at the bottom

set hlsearch                    " highlight the pattern
set incsearch                   " highlight the pattern when typing
set ignorecase                  " ignore search case
set smartcase                   " smartly ignore search case
"set wrapscan                    " searches wrap over EOF

set nobackup                    " disable backup file
set noswapfile                  " disable swap file
set autoread                    " auto load buffer if file changed
set confirm                     " raise a dialog when saving

" }}}
" ==============================================================================


" ==============================================================================
" [plugin list] (managed by vim-plug) {{{

call plug#begin('~/.vim/plugged')

" onedark theme
Plug 'joshdick/onedark.vim'

" modern auto completion plugin based on LSP servers
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" list symbols based on ctag/coc
Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }

" insert snippets quickly in vim (works together with coc-snippets)
Plug 'honza/vim-snippets'

" lazy vim movement
Plug 'easymotion/vim-easymotion'

" a modern fuzzy finder
Plug 'Yggdroot/LeaderF', { 'on': 'LeaderF', 'do': ':LeaderfInstallCExtension' }

" auto pair/quick substitution of surroundings
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-surround'

" lazy comments
Plug 'tpope/vim-commentary'

" lazy repeating
Plug 'tpope/vim-repeat'

" lazy alignment
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" repeat find/till with f/t instead of ,/;
Plug 'rhysd/clever-f.vim'

" lazy git
Plug 'tpope/vim-fugitive', { 'on': ['Git', 'GV', 'GV!']}
Plug 'junegunn/gv.vim', { 'on': ['Git', 'GV', 'GV!']}

" highlight all word occurrences
Plug 'dominikduda/vim_current_word'

call plug#end()

" }}}
" ==============================================================================


colorscheme onedark


" ==============================================================================
" [user scripts] {{{

" marcos {{{

" run marco in visual mode
xnoremap @ :normal! @

" repeat for marco, use the marco once and do <c-q>
nnoremap <c-q> @@

" }}}

" code folding {{{

" toggle line wrap
nnoremap <silent> <leader>z :let &l:wrap=!&l:wrap<cr>
xnoremap <silent> <leader>z :let &l:wrap=!&l:wrap<cr>

" move into line wraps instead of jumping over it
noremap j gj
noremap k gk

" switch between fold methods
nnoremap <silent> <leader>m :let &l:fdm=&l:fdm=="marker"?"indent":"marker"<cr>
xnoremap <silent> <leader>m :let &l:fdm=&l:fdm=="marker"?"indent":"marker"<cr>

" open a closed fold with <enter>
" insert an empty line otherwise
nmap <silent><nowait> <expr><enter> foldclosed('.')>0?"zo":"o\<esc>"

" close an open fold with <bs>
nmap <silent><nowait> <expr><bs> foldlevel('.')>0?"zc":"\<bs>"

" }}}

" search and replace {{{

" toggle search pattern highlight
nnoremap <silent> <leader>h :noh<cr>
xnoremap <silent> <leader>h :noh<cr>

" find keywords downwards, example: ve/
xnoremap <silent> / "sy/\V\<<c-r>=@s<cr>\><cr>

" find keywords upwards, example: ve?
xnoremap <silent> ? "sy?\V\<<c-r>=@s<cr>\><cr>

" replace keyword with <f2>, note that register s will be used!
xnoremap <f2> "sy/\V\<<c-r>=@s<cr>\><cr><c-o>:%s/\V\<<c-r>=@s<cr>\>/

" jump and centralize
nnoremap n nzz
xnoremap n nzz
nnoremap N Nzz
xnoremap N Nzz

" }}}

" selection {{{

" extend matching with '%'
packadd! matchit

" move selected area upward/downward
" Note that there could be bugs moving across a fold
xnoremap <silent> <c-k> :move '<-2<cr>gv
xnoremap <silent> <c-j> :move '>+1<cr>gv

" move selected area to window on the left/right
xnoremap <c-h> y<c-w>hPgv:undoj<cr>
xnoremap <c-l> y<c-w>lPgv:undoj<cr>

" }}}

" buffer {{{

" reload/redraw buffer
nnoremap <silent> <leader>r :e<cr>
xnoremap <silent> <leader>r :e<cr>
nnoremap <silent> <leader>R :redraw!<cr>
xnoremap <silent> <leader>R :redraw!<cr>

func! s:change_buf(towards) abort
    if &ft == 'netrw'
        echoerr "netrw cannot be changed"
        return
    endif
    if &bt != ''
        echoerr "buftype ". &bt. " cannot be changed"
        return
    endif
    if a:towards == 'n' | bn | else | bp | endif
	while &bt != ''
        if a:towards == 'n' | bn | else | bp | endif
    endwhile
endfunc

" select previous buffer
nnoremap <silent> <leader>j :call<space><sid>change_buf('p')<cr>
xnoremap <silent> <leader>j :call<space><sid>change_buf('p')<cr>

" select next buffer
nnoremap <silent> <leader>k :call<space><sid>change_buf('n')<cr>
xnoremap <silent> <leader>k :call<space><sid>change_buf('n')<cr>

" store recent closes
let g:recent_closed_bufs={}

func! s:get_recent_closed_bufs() abort
	let list = []
	for [key, value] in items(g:recent_closed_bufs)
		let value['filename'] = key
		call insert(list, value)
	endfor
	call sort(list, {m1, m2 -> m1['time'] > m2['time'] ? -1 : 1})
	call setqflist(list, 'r')
	copen
endfunc

func! s:close_buf() abort
    if bufname() == '' || len(getbufinfo({'buflisted': 1})) == 0
        quit | return
    endif
    if &bt == 'quickfix'
        cclose | return
    elseif &bt == 'loclist'
        lclose | return
    endif
    if (&bt != '' || &ft == 'netrw')
        bd | return
    endif
    if &bt == ''
        let buf_now = bufnr()
        " save recent closed buffers
        let g:recent_closed_bufs[bufname()] = {
                    \'lnum': line('.'),
                    \ 'col': col('.'),
                    \'text': 'closed at '.strftime("%H:%M"),
                    \'time': localtime()
                    \}
        " go back to the last buffer before we switched to this one
        let buf_jump_list = getjumplist()[0]
        let buf_jump_now = getjumplist()[1] - 1
        while buf_jump_now >= 0
            let last_nr = buf_jump_list[buf_jump_now]["bufnr"]
            let last_line = buf_jump_list[buf_jump_now]["lnum"]
            if buf_now != last_nr && bufloaded(last_nr) &&
                        \getbufvar(last_nr, "&bt") == ''
                execute ":b ".last_nr
                execute ":bd ".buf_now
                return
            else
                let buf_jump_now -= 1
            endif
        endwhile
        bp | while &bt != '' | bp | endwhile
        execute "bd ".buf_now
    endif
endfunc

" leave current buffer
nnoremap <silent> <leader>q :call<space><sid>close_buf()<cr>
xnoremap <silent> <leader>q :call<space><sid>close_buf()<cr>

" get recent closed buffers
nnoremap <silent> <leader>Q :call <sid>get_recent_closed_bufs()<cr>
xnoremap <silent> <leader>Q :call <sid>get_recent_closed_bufs()<cr>

augroup buf
    autocmd!
    " remember the last position when re-opening a buffer
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
                \exec "normal! g'\"" | endif

    " set cursor line if and only if window on focus
    autocmd BufEnter,WinEnter * setlocal cursorline
    autocmd BufLeave,WinLeave * setlocal nocursorline
    "autocmd BufEnter,WinEnter * setlocal cursorcolumn
    "autocmd BufLeave,WinLeave * setlocal nocursorcolumn
augroup END

" save current buffer
nnoremap <silent> <leader>w :w<cr>
xnoremap <silent> <leader>w :w<cr>

" load file in new buffer
nnoremap <leader>e :e<space><c-r>=getcwd()<cr>/
xnoremap <leader>e :e<space><c-r>=getcwd()<cr>/
nnoremap <leader>E :e<space>/
xnoremap <leader>E :e<space>/

" }}}

" split view {{{

" adjust window boundary
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w><
noremap <c-right> <c-w>>

" change focused window
noremap <up> <c-w>k
noremap <down> <c-w>j
noremap <left> <c-w>h
noremap <right> <c-w>l

" adjust window position
noremap <leader><up> <c-w>K
noremap <leader><down> <c-w>J
noremap <leader><left> <c-w>H
noremap <leader><right> <c-w>L

" scroll in the other window (for reading or referrence)
nnoremap \<c-u> <c-w>p<c-u><c-w>p
nnoremap \<c-d> <c-w>p<c-d><c-w>p
nnoremap \<c-f> <c-w>p<c-f><c-w>p
nnoremap \<c-b> <c-w>p<c-b><c-w>p
nnoremap \<c-y> <c-w>p<c-y><c-w>p
nnoremap \<c-e> <c-w>p<c-e><c-w>p


" scroll with cursor (in the other window)
nnoremap \zz <c-w>pzz<c-w>p
nnoremap \zt <c-w>pzt<c-w>p
nnoremap \zb <c-w>pzb<c-w>p

" 'man' instead of two words 'vert help'
cnoreab man vert help

" }}}

" scrolling {{{

" eye friendly ctrl-o
nnoremap <c-o> <c-o>zz

" }}}

" multitask {{{

" open a new empty tab
nnoremap <leader><tab> :tabnew<cr>:e <c-r>=getcwd()<cr>/
xnoremap <leader><tab> :tabnew<cr>:e <c-r>=getcwd()<cr>/
nnoremap <leader><bs> :tabclose<cr>
xnoremap <leader><bs> :tabclose<cr>

" open a new empty window
nnoremap <leader>v :vert new<cr>:e <c-r>=getcwd()<cr>/
xnoremap <leader>v :vert new<cr>:e <c-r>=getcwd()<cr>/
nnoremap <leader>V :new<cr>:e <c-r>=getcwd()<cr>/
xnoremap <leader>V :new<cr>:e <c-r>=getcwd()<cr>/

" open up a terminal
nnoremap <silent> <leader>t :vert term<cr>
xnoremap <silent> <leader>t :vert term<cr>
nnoremap <silent> <leader>T :bo term ++rows=6<cr>
xnoremap <silent> <leader>T :bo term ++rows=6<cr>

" open up a terminal in a new tab
nnoremap <silent> <leader>x :tabe<cr>:vert term ++curwin ++close<cr>
xnoremap <silent> <leader>x :tabe<cr>:vert term ++curwin ++close<cr>

" open up a terminal in a new tab under directory of current file
nnoremap <silent> <leader>X :tabe<cr>:call term_start("bash",
            \{"cwd":"<c-r>=expand('%:p:h')<cr>",
            \"curwin":1,"term_finish":"close"})<cr>
xnoremap <silent> <leader>X :tabe<cr>:call term_start("bash",
            \{"cwd":"<c-r>=expand('%:p:h')<cr>",
            \"curwin":1,"term_finish":"close"})<cr>

" run async tasks with 'vert term'
command! -complete=shellcmd -nargs=+ Run exec "vert term ".<q-args>
cnoreab bang Run

" }}}

" code cleanup {{{

" unhide control characters
nnoremap <silent> <leader>i :let &l:list=!&l:list<cr>
xnoremap <silent> <leader>i :let &l:list=!&l:list<cr>

" highlight all trailing spaces
match DiffDelete /\v\s+$/

" erase trailing spaces, example ggvG\d<space>
nnoremap <silent> d<space> :s/\v\s+$//<cr>:noh<cr><c-o>
xnoremap <silent> <leader>d<space> :s/\v\s+$//<cr>:noh<cr><c-o>

" clear the current line
nnoremap dc d0d$

" re-enter the current line
nnoremap di d0d$i

" re-enter the current line (insert mode)
inoremap <c-d> <c-o>cc

" }}}

" yank and paste {{{

" yank a whole line
nnoremap yy Y

" yank from system clipboard
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+Y
xnoremap <leader>Y "+Y

" paste to system clipboard
nnoremap <leader>p "+p
xnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>P "+P

" }}}

" lazy indent {{{

" quick indent in normal/visual mode
nnoremap <tab> >>
xnoremap <tab> >gv
nnoremap <s-tab> <<
xnoremap <s-tab> <gv

" press <leader> then hold <space> to add more spaces, <esc> to stop
nnoremap <silent> <leader><space> i<space><c-[>
            \:while getchar()==32<bar>
            \undoj<bar>
            \exec "normal!i<space>"<bar>
            \redraw<bar>
            \endwhile<cr>

" press <leader> then hold o to add empty lines, <esc> to stop
nnoremap <silent> <leader>o :call append(line('.'),"")<cr>
            \:while getchar()==111<bar>
            \undoj<bar>
            \call append(line('.'),"")<bar>
            \redraw<bar>
            \endwhile<cr>

" do the same as above when holding O, but upwards
nnoremap <silent> <leader>O :call append(line('.')-1,"")<cr>
            \:while getchar()==79<bar>
            \undoj<bar>
            \call append(line('.')-1,"")<bar>
            \redraw<bar>
            \endwhile<cr>

" TODO: convert front tabs to tabwidth spaces and vice versa

" }}}

" lazy cmode {{{

" tcsh-style command line (bash compatible)
cnoremap <c-a> <home>
cnoremap <c-b> <left>
cnoremap <c-f> <right>

" command line key characters, you can modifiy these for better performance
let g:cmd_pairs={'(': ')', '[': ']', '{': '}', '<': '>', '"': '"', "'": "'",
            \ '`': '`'}

" auto complete command line key characters
func! s:cmd_auto_pair(ch) abort
    if has_key(g:cmd_pairs, a:ch)
        return a:ch. g:cmd_pairs[a:ch]. "\<left>"
    elseif a:ch == getcmdline()[getcmdpos() - 1]
        return "\<right>"
    else
        return a:ch
    endif
endfunc

cnoremap <expr> ( <sid>cmd_auto_pair('(')
cnoremap <expr> ) <sid>cmd_auto_pair(')')
cnoremap <expr> [ <sid>cmd_auto_pair('[')
cnoremap <expr> ] <sid>cmd_auto_pair(']')
cnoremap <expr> { <sid>cmd_auto_pair('{')
cnoremap <expr> } <sid>cmd_auto_pair('}')
cnoremap <expr> < <sid>cmd_auto_pair('<')
cnoremap <expr> > <sid>cmd_auto_pair('>')
cnoremap <expr> " <sid>cmd_auto_pair('"')
cnoremap <expr> ' <sid>cmd_auto_pair("'")
cnoremap <expr> ` <sid>cmd_auto_pair('`')

" auto delete verbose key characters
func! s:cmd_auto_bs() abort
    let cr = getcmdline()[getcmdpos() - 1]
    let cl = getcmdline()[getcmdpos() - 2]
    if has_key(g:cmd_pairs, cl) && (g:cmd_pairs[cl] == cr)
        return "\<right>\<bs>\<bs>"
    else
        return "\<bs>"
    endif
endfunc

cnoremap <expr> <bs> <sid>cmd_auto_bs()

" }}}

" lazy IO {{{

" change pwd
cnoreab cd cd <c-r>=expand('%:p:h')<cr>

" remove current file
command! -nargs=0 -bang Remove call delete(expand('%')) | :bd | :bn
cnoreab rm Remove

" rename current file
command! -nargs=1 -bang -complete=file Rename let @s=expand('%') |
            \file <args> | write! | call delete(@s)
cnoreab <expr>mv "Rename ".expand('%:p:h')

" make new directory
command! -nargs=1 -bang -complete=file Mkdir echo mkdir(<f-args>)
cnoreab <expr>md "Mkdir ".expand('%:p:h')

" remove directory
command! -nargs=1 -bang -complete=file Rmdir echo delete(<f-args>, "d")
cnoreab <expr>rd "Rmdir ".expand('%:p:h')

" force write
command! -nargs=0 -bang SudoWrite w !sudo tee % >/dev/null
cnoreab w!! SudoWrite
nnoremap <leader>W :w!!<cr>
xnoremap <leader>W :w!!<cr>

" }}}

" Goto eXternal link {{{
" use netrw's gx if present
if !exists("g:loaded_netrw")
    func! s:gx() abort
    	let m = matchstrpos(getline('.'), 'https*://\S[^][(){}]*')
    	while m[0] != '' && (m[1] > col('.') || m[2] < col('.'))
    		let m = matchstrpos(getline('.'), 'https*://\S[^][(){}]*', m[2])
    	endwhile
        if m[0] != ''
    	    let browser = get(g:, 'default_browser', 'firefox')
            let link = m[0]
            call job_start(browser. ' '. link)
        else
            echoerr 'cannot find link'
        endif
    endfunc

    nnoremap <silent><nowait> gx :call<space><sid>gx()<cr>
endif

" }}}

" quickfix {{{

" get quickfix window number
func! s:getqfwinnr() abort
    let wins = filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')
    return empty(wins) ? 0 : wins[0].winnr
endfunc

" <leader>+c to toggle quickfix window
nnoremap <silent><expr> <leader>c <sid>getqfwinnr() ? ":cclose\<cr>" :
            \":copen\<cr>"

" scroll between quickfix results
nnoremap <silent> <c-p> :cprevious<cr>
xnoremap <silent> <c-p> :cprevious<cr>
nnoremap <silent> <c-n> :cnext<cr>
xnoremap <silent> <c-n> :cnext<cr>

" TODO: <leader>+C to toggle quickfix popup menu
func! s:qfpopup() abort
endfunc

nnoremap <leader>C :call <sid>qfpopup()<cr>

" }}}

" vim diff {{{

" shortcuts to open up a vimdiff window
command! -nargs=1 -bang -complete=file Diff exec ":vert diffsplit ".<q-args>
cnoreab <expr> diff "Diff ".expand('%:p').".bak"

" }}}

" termdebug {{{

" vertical split termdebug windows
let g:termdebug_wide=1

" load termdebug when necessary
nnoremap <expr> <f5> :packadd! termdebug<cr>:Termdebug<space>

" mappings for term debugging
nnoremap <f6> :Break<cr>
nnoremap <f7> :Over<cr>
nnoremap <f8> :Step<cr>

" }}}

" TODO: fzf/lf/lazygit support

" TODO: hexedit

" TODO: timer monitor

" TODO: vim-markdown

" TODO: examine key binding

" TODO: gitgutter

" TODO: vim-textobj

" }}}
" ==============================================================================


" ==============================================================================
" [file types] {{{

augroup ft
    autocmd!

" The 'exec as' script
function! s:exec_as(cmd,str)
    let temp=tempname()
    let content=["#!"..a:cmd]+split(a:str,'\n')
    call writefile(content, temp)
    call setfperm(temp,"rwxrwxrwx")
    exec ":bo term ++rows=6 "..temp
endfunction

    " *.vim
    " <leader>s source current vim script
    "        \i call vim-plug's PlugInstall()
    "        \r call vim-plug's PlugClean()
    autocmd FileType vim nnoremap <silent><buffer> <leader>s :source <c-r>=expand('%:p')<cr><cr> |
                \nnoremap <silent><buffer> \i :PlugInstall<cr> |
                \nnoremap <silent><buffer> \r :PlugClean<cr>

    " *.sh
    " <leader>s source current bash script
    "     \<cr> execute current shell script
    "        \x in visual mode, execute the selected area;
    "           in normal mode, execute current line
    autocmd FileType sh nnoremap <silent><buffer> <leader>s :!source <c-r>=expand('%:p')<cr><cr> |
                \nnoremap <silent><buffer> \<cr> :!/bin/bash <c-r>=expand("%")<cr><cr> |
                \xnoremap <silent><buffer> \x "*y:call <sid>exec_as('/bin/bash',getreg('*'))<cr> |
                \nnoremap <silent><buffer> \x 0v$"*y:call <sid>exec_as('/bin/bash',getreg('*'))<cr>

    " *.make
    " stupid makefile syntax
    autocmd FileType make set noexpandtab shiftwidth=4 tabstop=4 softtabstop=4

    " *.html
    " \<cr> test current html file
    autocmd FileType html let b:browser=get(g:,'default_browser','firefox') |
                \nnoremap <silent><buffer> \<cr> :w<cr>:call job_start(b:browser.' '.expand('%:p'))<cr>

    " *.c/cpp
    " clang-format LLVM style
    " set compiler options for testing
    autocmd FileType c,cpp set expandtab shiftwidth=2 tabstop=2 softtabstop=2 |
                \let b:compiler=&filetype=="c"?"clang":"clang++" |
                \let &l:makeprg=b:compiler." -O2 -Werror -gdwarf-4 % -o $*"

    " *.py
    " \<cr> execute current python script
    "    \x in normal mode, execute current line;
    "       in visual mode, execute selected area
    autocmd FileType python nnoremap <silent><buffer> \x 0v$"*y:call <sid>exec_as('/usr/bin/env python3',getreg('*'))<cr> |
                \xnoremap <silent><buffer> \x "*y:call <sid>exec_as('/usr/bin/env python3',getreg('*'))<cr> |
                \nnoremap <silent><buffer> \<cr> :!/usr/bin/env python3 <c-r>=expand("%")<cr><cr>

augroup END

" }}}
" ==============================================================================


" ==============================================================================
" [plugin settings] {{{

" TODO: vim-precode

" TODO: vim-dashboard

" vista.vim {{{

" enable vista icons
let g:vista#renderer#enable_icon=1

" default vista backend
let g:vista_default_executive='ctags'

" shortcut to inspect symbols
nnoremap <silent> <leader>L :Vista coc<cr>
nnoremap <silent> <leader>l :Vista!!<cr>

" TODO:delete buffer if vista is the only buffer remaining
augroup Vista
	autocmd!
	autocmd BufEnter * if (&ft == 'vista' || &ft == 'vista_markdown') &&
                \winnr('$') == 1 | bd | endif
augroup END

" }}}

" LeaderF {{{

" set LeaderF window to popup mode
let g:Lf_WindowPosition = 'popup'

" }}}

" coc.nvim {{{

" use nvm to manage node versions
let g:coc_node_path = '~/.nvm/versions/node/v23.3.0/bin/node'

" always show notification column on the left
set signcolumn=yes

" use (shift-)tab to navigate
inoremap <silent><expr> <tab> coc#pum#visible()?coc#pum#next(1):"\<tab>"
inoremap <silent><expr> <s-tab> coc#pum#visible()?coc#pum#prev(1):"\<c-h>"

" use <cr> to confirm
inoremap <silent><expr> <cr> coc#pum#visible()?coc#pum#confirm():
            \"\<cr>\<c-r>=coc#on_enter()\<cr>"

" TODO more coc settings

" }}}

" vim-easymotion {{{

" ignore case when super moving
let g:EasyMotion_smartcase = 1

" trigger super move with \ + (vim default key)
map \ <plug>(easymotion-prefix)

" }}}

" auto-pairs {{{

" disable some pre-defined mappings
let g:AutoPairsMapCh=0
let g:AutoPairsMapBS=0
let g:AutoPairsMapCR=0

" }}}

" tabular {{{

" tabularize the last " (eg. vim scripts)
nnoremap <leader>" :Tabularize<space>/"\ze[^"]*$/l1c1l0<cr>
xnoremap <leader>" :Tabularize<space>/"\ze[^"]*$/l1c1l0<cr>

" tabularize the last # (eg. python)
nnoremap <leader># :Tabularize<space>/#\ze[^#]*$/l1c1l0<cr>
xnoremap <leader># :Tabularize<space>/#\ze[^#]*$/l1c1l0<cr>

" tabularize a regex
nnoremap <leader>/ :Tabularize /
xnoremap <leader>/ :Tabularize /

" }}}

" clever-f {{{

" f/t does not cross the current line
let g:clever_f_across_no_line=1

" only highlight the first character that matches
let g:clever_f_mark_direct=1

" smartly ignore case
let g:clever_f_smart_case=1

" enhance ; with clever-f
nmap <silent><nowait> ; <Plug>(clever-f-repeat-forward)
xmap <silent><nowait> ; <Plug>(clever-f-repeat-forward)

" }}}

" vim_current_word {{{

" highlight only in focused window
let g:vim_current_word#highlight_only_in_focused_window = 1

hi link CurrentWord Underlined
hi link CurrentWordTwins Underlined

" }}}

" TODO: more plugin settings

" }}}
" ==============================================================================


" TODO: Deprecated

"" ==============================================================================
"" This script change vim's default scrolling behavior
"" Credit to Terry Ma:
"" https://github.com/terryma/vim-smooth-scroll
"" ==============================================================================
"
"" Scroll the screen up
"function! myscroll#up(dist, duration, speed)
"    call s:do_scroll('u', a:dist, a:duration, a:speed)
"endfunction
"
"" Scroll the screen down
"function! myscroll#down(dist, duration, speed)
"    call s:do_scroll('d', a:dist, a:duration, a:speed)
"endfunction
"
"" Scroll the screen smoothly
"" dir: Direction of the scroll. 'd' is downwards, 'u' is upwards
"" dist: Distance, or the total number of lines to scroll
"" duration: How long should each scrolling animation last. Each scrolling
"" animation will take at least this long. It could take longer if the scrolling
"" itself by Vim takes longer
"" speed: Scrolling speed, or the number of lines to scroll during each scrolling
"" animation
"function! s:do_scroll(dir, dist, duration, speed)
"    for i in range(a:dist/a:speed)
"        let start = reltime()
"        if a:dir ==# 'd'
"            if line(".") >= line("$")
"                break
"            endif
"            exec "normal! ".a:speed."\<c-e>".a:speed."j"
"        else
"            if line(".") <= 1
"                break
"            endif
"            exec "normal! ".a:speed."\<c-y>".a:speed."k"
"        endif
"        redraw
"        let elapsed = s:get_ms_since(start)
"        let snooze = float2nr(a:duration-elapsed)
"        if snooze > 0
"            exec "sleep ".snooze."m"
"        endif
"    endfor
"endfunction
"
"" Calculate intervals
"function! s:get_ms_since(time)
"    let cost = split(reltimestr(reltime(a:time)), '\.')
"    return str2nr(cost[0])*1000 + str2nr(cost[1])/1000.0
"endfunction


"" ==============================================================================
"" This script provides binary editing features based on xxd
"" Example:
"" ==============================================================================
"
"" add xxd arguments here
"let s:xxdcmd = ":%!xxd"
"
"" reverse hex dump
"let s:xxdrcmd = ":%!xxd -r"
"
"let b:MyHexEnabled=0
"
"function! myhex#toggle() abort
"    if b:MyHexEnabled
"        call myhex#disable()
"    else
"        call myhex#enable()
"    endif
"endfunction
"
"function! myhex#enable() abort
"	if !executable('xxd')
"        echoerr "xxd not found in your $PATH"
"        return
"    endif
"
"    let b:MyHexEnabled=1
"    setlocal bin
"    setlocal filetype=
"    silent! exec s:xxdcmd
"    redraw!
"
"	augroup MyHex
"		autocmd!
"        autocmd BufReadPost <buffer> setlocal filetype= | silent! exec s:xxdcmd | redraw!
"		autocmd BufWritePre <buffer> let s:savedpos = getcurpos() | silent! exec s:xxdrcmd
"		autocmd BufWritePost <buffer> silent! exec s:xxdcmd | call cursor([s:savedpos[1], s:savedpos[2]])
"		autocmd BufDelete <buffer> setlocal nobin | autocmd! MyHex
"	augroup END
"endfunction
"
"function! myhex#disable() abort
"    let b:MyHexEnabled=0
"    setlocal nobin
"    silent! autocmd! MyHex
"    exec ":e"
"endfunction
"
"command! -bang -nargs=0 MyHexToggle call <sid>myhex#toggle()
"command! -bang -nargs=0 MyHexEnable call <sid>myhex#enable()
"command! -bang -nargs=0 MyHexDisable call <sid>myhex#disable()
