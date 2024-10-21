"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader=" "
let maplocalleader=" "

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=10

" Turn on the Wild menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Always show current position
set ruler

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
  autocmd GUIEnter * set vb t_vb=
endif

" Add a bit extra margin to the left
set foldcolumn=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

" Set regular expression engine automatically
set regexpengine=0

" Set extra options when running in GUI mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Smart way to move between windows.
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

" Better up/down nav for wrapped lines.
nnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
xnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <silent> <expr> <Down> (v:count == 0 ? 'gj' : 'j')
xnoremap <silent> <expr> <Down> (v:count == 0 ? 'gj' : 'j')
nnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
xnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <silent> <expr> <Up> (v:count == 0 ? 'gk' : 'k')
xnoremap <silent> <expr> <Up> (v:count == 0 ? 'gk' : 'k')

" " Smart way to resize windows.
nmap <C-Up> :resize +2<CR>
nmap <C-Down> :resize -2<CR>
nmap <C-Left> :vertical resize -2<CR>
nmap <C-Right> :vertical resize +2<CR>

" Search inside visual selection
xnoremap g/ <esc>/\%V

" " Opens a new tab with the current buffer's path
" " Super useful when editing files in the same directory
" map <leader>te :tabedit <C-r>=escape(expand("%:p:h"), " ")<cr>/

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" f2dv.vim

set title
set titlestring=%F\ (%{expand('%:p:h')}) titlelen=80

set diffopt+=internal,algorithm:histogram

" Don't continue comment char on newline
autocmd BufWinEnter,BufNewFile * setlocal formatoptions-=cro

" never linebreak
set textwidth=0

" disable wrapping
set nowrap

" never fold on launch
set foldlevel=99

" show search result counts
" ref: https://vi.stackexchange.com/a/23296
set shortmess-=S

if $TERM == "xterm-256color"
  set t_Co=256
endif

" -----------------------------------------------------------------------------|
"                                 ___ ___  __                                  |
"                           |\ | |__   |  |__) |  |                            |
"                           | \| |___  |  |  \ |/\|                            |
"                           - - - - - - - - - - - -                            |
"                                                                              |
" -----------------------------------------------------------------------------|

let g:netrw_banner = 0
let g:netrw_winsize = 10
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_keepdir = 0

autocmd FileType netrw silent! unmap <buffer> <C-h>
autocmd FileType netrw silent! unmap <buffer> <C-j>
autocmd FileType netrw silent! unmap <buffer> <C-k>
autocmd FileType netrw silent! unmap <buffer> <C-l>

" -----------------------------------------------------------------------------|
"                             ___  __          __   ___                        |
"                       |\ | |__  /  \ \  / | |  \ |__                         |
"                       | \| |___ \__/  \/  | |__/ |___                        |
"                       - - - - - - - - - - - - - - - -                        |
"                                                                              |
" -----------------------------------------------------------------------------|
if exists("g:neovide")
  " Put anything you want to happen only in Neovide here
  set linespace=0

  let g:neovide_padding_top = 0
  let g:neovide_padding_bottom = 0
  let g:neovide_padding_right = 0
  let g:neovide_padding_left = 0

  let g:neovide_scroll_animation_length = 0.15
  let g:neovide_cursor_animation_length = 0.03
  let g:neovide_cursor_trail_size = 0.8
  let g:neovide_cursor_antialiasing = v:true
  let g:neovide_cursor_animate_in_insert_mode = v:false
  let g:neovide_cursor_animate_command_line = v:false

  let g:neovide_hide_mouse_when_typing = v:true
  let g:neovide_confirm_quit = v:true

  let g:neovide_fullscreen = v:false
  let g:neovide_remember_window_size = v:false
  let g:neovide_profiler = v:false

  let g:neovide_scale_factor=0.85

  function! ChangeScaleFactor(delta)
    let g:neovide_scale_factor = g:neovide_scale_factor * a:delta
  endfunction

  nnoremap <expr><C-=> ChangeScaleFactor(1.15)
  nnoremap <expr><C--> ChangeScaleFactor(1/1.15)
endif

" Shortcut [window] save and close window
"     \ nmap <silent> <leader>x :w \| CloseOrConfirmExit<cr>
" Shortcut [window] save all and exit
"     \ nmap <silent> <leader>X :wa \| ConfirmExit<cr>

" Shortcut [window] exit
"     \ nmap <leader>eq :qa<cr>
" Shortcut [window] exit without saving
"     \ nmap <leader>eQ :qa!<cr>
" Shortcut [window] save and exit
"     \ nmap <leader>ew :wqa<cr>

"autosize panes after window resize
autocmd VimResized * wincmd =

" Better grep using `ripgrep` and Grep
" https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
set grepprg=rg\ --vimgrep\ --no-heading
set grepformat+=%f:%l:%c:%m

function! Grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

" Open quickfix / loclist when it changes.
augroup quickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup END

" " 'line' text-objects
" " https://vi.stackexchange.com/a/6102
" xnoremap il g_o^
" onoremap il :normal vil<cr>
" xnoremap al $o^
" onoremap al :normal val<cr>
"
" xnoremap iL g_o0
" onoremap iL :normal viL<cr>
" xnoremap aL $o0
" onoremap aL :normal vaL<cr>

" paste while retain original value and cursor position
" https://stackoverflow.com/a/7164121
noremap p p`[
noremap P P`[
xnoremap p pgvy`[

" dot-repeat and restore cursor position
nnoremap . m`.``

" Paste linewise above/below with optional reindentation.
" Copied from tpope/vim-unimpaired.
function! s:putline(how, map) abort
  let [body, type] = [getreg(v:register), getregtype(v:register)]
  if type ==# 'V'
    exe 'normal! "'.v:register.a:how
  else
    call setreg(v:register, body, 'l')
    exe 'normal! "'.v:register.a:how
    call setreg(v:register, body, type)
  endif
  silent! call repeat#set("\<Plug>(unimpaired-put-".a:map.")")
endfunction

nnoremap <silent> <Plug>(unimpaired-put-above) :call <SID>putline('[p', 'above')<CR>
nnoremap <silent> <Plug>(unimpaired-put-below) :call <SID>putline(']p', 'below')<CR>
nnoremap <silent> <Plug>(unimpaired-put-above-rightward) :<C-U>call <SID>putline(v:count1 . '[p', 'Above')<CR>>']
nnoremap <silent> <Plug>(unimpaired-put-below-rightward) :<C-U>call <SID>putline(v:count1 . ']p', 'Below')<CR>>']
nnoremap <silent> <Plug>(unimpaired-put-above-leftward)  :<C-U>call <SID>putline(v:count1 . '[p', 'Above')<CR><']
nnoremap <silent> <Plug>(unimpaired-put-below-leftward)  :<C-U>call <SID>putline(v:count1 . ']p', 'Below')<CR><']
nnoremap <silent> <Plug>(unimpaired-put-above-reformat)  :<C-U>call <SID>putline(v:count1 . '[p', 'Above')<CR>=']
nnoremap <silent> <Plug>(unimpaired-put-below-reformat)  :<C-U>call <SID>putline(v:count1 . ']p', 'Below')<CR>=']
nnoremap <silent> <Plug>unimpairedPutAbove :call <SID>putline('[p', 'above')<CR>
nnoremap <silent> <Plug>unimpairedPutBelow :call <SID>putline(']p', 'below')<CR>

nnoremap [p <Plug>(unimpaired-put-above)
nnoremap ]p <Plug>(unimpaired-put-below)
nnoremap [P <Plug>(unimpaired-put-above)
nnoremap ]P <Plug>(unimpaired-put-below)
nnoremap >P <Plug>(unimpaired-put-above-rightward)
nnoremap >p <Plug>(unimpaired-put-below-rightward)
nnoremap <P <Plug>(unimpaired-put-above-leftward)
nnoremap <p <Plug>(unimpaired-put-below-leftward)
nnoremap =P <Plug>(unimpaired-put-above-reformat)
nnoremap =p <Plug>(unimpaired-put-below-reformat)


" make Y act like D and C (yank to EOL)
nmap Y y$

" change default split direction
set splitright
set splitbelow

" Display line numbers
set number

" Show which line your cursor is on
set cursorline

" smarter-cursorline
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#smarter-cursorline
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" In Visual mode the size of the selected area is shown
set showcmd

" faster updates
set updatetime=1000

" share vim with system clipboard
" https://stackoverflow.com/a/30691754
set clipboard^=unnamed,unnamedplus

set breakindent

" don't mess with indenting comments
set nosmartindent
set cindent

" Wait indefinitely for next key.
set notimeout ttimeout ttimeoutlen=50

" enable mouse support in normal mode
set mouse=n

" easier scrollback in terminal
tnoremap <C-u> <C-\><C-n>

" Misc shortcuts

" Shortcut! :.!figbox surround line in ascii box (figbox)

" open file at position in new split
" Natively, `gs` is for the useless `sleep` command.
" With this mapping, `gsp` is for "Go to file under cursor in new split"
nnoremap gsp :wincmd F<CR>


" Account for my common typo when quitting
command Q :q
command Qa :qa
command Wq :wq
command Wqa :wqa

" Toggle background
set background=dark
nnoremap <leader>tb :execute 'set background=' . (&background == 'dark' ? 'light' : 'dark')<CR>
" Toggle wrap
nnoremap <leader>tw :setlocal wrap! wrap?<CR>

" Filetype configs
autocmd BufNewFile,BufRead *.yml.tpl,*.yaml.tpl setlocal filetype=yaml

autocmd FileType python setlocal colorcolumn=88
" autocmd FileType python,yaml,sh,zsh setlocal cinkeys-=0# indentkeys-=0#
" autocmd FileType yaml,helm setlocal foldmethod=indent foldcolumn=0 foldlevel=99

autocmd FileType yaml,sh,zsh setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python,markdown,vim,json setlocal ts=4 sts=4 sw=4 expandtab

autocmd filetype text,markdown setlocal wrap


" Revert to previous buffer and open existing buffer in vertical split.
nnoremap <leader><C-o> :bprev \| vsplit \| bnext \| wincmd p<CR>

" Quick buffer switching
nnoremap gb :ls<CR>:b<Space>
"""
nnoremap <silent> <leader>w :w<CR>
nnoremap <silent> <leader>W :wa<CR>
" See :help cmdline-special
nnoremap <silent> <leader>qu :edit#<CR>
nnoremap <silent> <leader>qs :close<CR>
nnoremap <silent> <leader>qS :only<CR>
nnoremap <silent> <leader>qa :%bdelete<CR>
nnoremap <silent> <leader>qt :tabclose<CR>
nnoremap <silent> <leader>qc :bdelete<CR>

" Common bracket mappings
" Next / prev arg
nnoremap ]a :next<CR>
nnoremap [a :prev<CR>
nnoremap ]A :last<CR>
nnoremap [A :first<CR>
" Next / prev buffer
nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
nnoremap ]B :blast<CR>
nnoremap [B :bfirst<CR>
" Next / prev quickfix entry
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>
nnoremap ]Q :clast<CR>
nnoremap [Q :cfirst<CR>
" Next / prev loclist entry
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
nnoremap ]L :llast<CR>
nnoremap [L :lfirst<CR>
" quickly-move-current-line
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-move-current-line
nnoremap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nnoremap ]e  :<c-u>execute 'move +'. v:count1<cr>
" quickly-add-empty-lines
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-add-empty-lines
" nnoremap [<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[
" nnoremap ]<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
nnoremap ]<space> :set paste<CR>m`o<Esc>``:set nopaste<CR>
nnoremap [<space> :set paste<CR>m`O<Esc>``:set nopaste<CR>

" Like <C-w>T, Open buffer in new tab, but preserve original window.
nnoremap <C-w>t :tab sp<CR>

" saner-behavior-of-n-and-n
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-behavior-of-n-and-n
nnoremap <expr> n  'Nn'[v:searchforward]
xnoremap <expr> n  'Nn'[v:searchforward]
onoremap <expr> n  'Nn'[v:searchforward]

nnoremap <expr> N  'nN'[v:searchforward]
xnoremap <expr> N  'nN'[v:searchforward]
onoremap <expr> N  'nN'[v:searchforward]

" saner-command-line-history
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-command-line-history
cnoremap <expr> <c-n> wildmenumode() ? "\<c-n>" : "\<down>"
cnoremap <expr> <c-p> wildmenumode() ? "\<c-p>" : "\<up>"

" clear highlight, etc. when pressing `Esc` in normal mode
" https://github.com/mhinz/vim-galore?tab=readme-ov-file#saner-ctrl-l
nnoremap <silent> <esc> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><esc>

" " dont-lose-selection-when-shifting-sidewards
" " https://github.com/mhinz/vim-galore?tab=readme-ov-file#dont-lose-selection-when-shifting-sidewards
" vnoremap <silent> < <gv
" vnoremap <silent> > >gv

"""

source ~/.vim/vimrc.d/plugins.vimrc

" Add comment above / below current line
nnoremap gco o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>
nnoremap gcO O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>

if !has('nvim')
  " Vim only
  " Easier macro repeat (like neovim)
  nmap Q @q
  xmap Q :normal @q<CR>
else
  " Neovim only

  " Sets how neovim will display certain whitespace characters in the editor.
  set list
  set listchars=multispace:·,lead:·,trail:·,tab:»·,extends:→,precedes:←,nbsp:␣
  " ,eol:↲

  " Require 24-bit colors (required by "fancy" UI plugins)
  set termguicolors

  " Preview substitutions live, as you type!
  set inccommand=split

  " Stabilize text on split
  set splitkeep=screen

  " Global status bar
  set laststatus=3

  " Don't show the mode, since it's already in the status line
  set noshowmode

  " Keep signcolumn on by default
  set signcolumn=yes

  " Disable nvim "editorconfig" feature to resolve this issue
  " that it introduces with `vim-symlink`.
  " ref: https://github.com/aymericbeaumet/vim-symlink/issues/14
  let g:editorconfig = 0

  " Open terminal in insert-mode.
  augroup TermOpenInsert
    autocmd!
    autocmd TermOpen term://* if &buftype ==# 'terminal' | startinsert | endif
  augroup END

  let pythonpath = stdpath('data') . '/python'
  let g:python3_host_prog = pythonpath . '/bin/python'

  if !isdirectory(pythonpath)
    echo 'Setting up Python environment...'
    call system(['python', '-m', 'venv', pythonpath])
    echo 'Installing Python packages...'
    call system([g:python3_host_prog, '-m', 'pip', 'install', 'pynvim'])
  endif
endif

" Command to delete all git-related buffers
function! QuitGit() abort
  let buffers = range(1, bufnr('$'))
  for buf in buffers
    let filetype = getbufvar(buf, '&filetype')
    if filetype ==# 'git' || filetype ==# 'fugitive' || filetype ==# 'fugitiveblame' || filetype ==# 'floggraph'
      execute 'bdelete ' . buf
    endif
  endfor
endfunction

" Command to delete all hidden buffers
function! QuitHidden() abort
  let buffers = range(1, bufnr('$'))
  for buf in buffers
    if bufloaded(buf) && bufwinnr(buf) == -1
      execute 'bdelete ' . buf
    endif
  endfor
endfunction

function! QuitOther()
  execute 'silent! tabonly'
  execute 'silent! only'
  execute 'QuitHidden'
endfunction

" Command to conditionally close window or delete buffer
function! QuitSmart() abort
  let current_win = win_getid()
  let current_bufnr = winbufnr(current_win)
  let current_buftype = getbufvar(current_bufnr, '&buftype')

  " Count the number of non-special windows and those with the current buffer.
  let normal_window_count = 0
  let buffer_window_count = 0
  let windows = range(1, winnr('$'))

  for win in windows
    let bufnr = winbufnr(win)
    if bufnr == current_bufnr
      let buffer_window_count += 1
    endif

    let buftype = getbufvar(bufnr, '&buftype')
    if buftype == ''
      let normal_window_count += 1
    endif
  endfor

  if buffer_window_count > 1
    " if this buffer exists in more than one window, close the window.
    close
  elseif len(windows) > 1 || current_buftype != ''
    bdelete
  " elseif expand('%:p') == ''
  "   " if this is an empty buffer
  "   quit
  else
    Bdelete
  endif
endfunction

command QuitGit call QuitGit()
command QuitHidden call QuitHidden()
command QuitOther call QuitOther()
command QuitSmart call QuitSmart()

nnoremap <silent> <leader>x  :QuitSmart<CR>
nnoremap <silent> <leader>qq :QuitSmart<CR>
" Bdelete is supplied by vim-bbye
nnoremap <silent> <leader>qe :Bdelete<CR>
nnoremap <silent> <leader>qo :QuitHidden<CR>
nnoremap <silent> <leader>qO :QuitOther<CR>
nnoremap <silent> <leader>qg :QuitGit<CR>
nnoremap <silent> <leader>gq :QuitGit<CR>

