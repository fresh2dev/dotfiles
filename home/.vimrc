"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintainer:
"       Amir Salihefendic - @amix3k
"
" Awesome_version:
"       Get this config, nice color schemes and lots of plugins!
"
"       Install the awesome version from:
"
"           https://github.com/amix/vimrc
"
" Sections:
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


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
let mapleader = " "
let maplocalleader = " "
map , <leader>

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set scrolloff=10

" " Avoid garbled characters in Chinese language windows OS
" let $LANG='en'
" set langmenu=en
" source $VIMRUNTIME/delmenu.vim
" source $VIMRUNTIME/menu.vim

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

" " Enable 256 colors palette in Gnome Terminal
" if $COLORTERM == 'gnome-terminal'
"     set t_Co=256
" endif

" try
"     colorscheme desert
" catch
" endtry

" set background=dark

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


" """"""""""""""""""""""""""""""
" " => Visual mode related
" """"""""""""""""""""""""""""""
" " Visual mode pressing * or # searches for the current selection
" " Super useful! From an idea by Michael Naumann
" vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
" vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
" map <space> /
" map <C-space> ?

" " Disable highlight when <leader><cr> is pressed
" map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" " Close the current buffer
" map <leader>bd :Bclose<cr>:tabclose<cr>gT
"
" " Close all the buffers
" map <leader>ba :bufdo bd<cr>
"
" map <leader>l :bnext<cr>
" map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
" map <leader>tn :tabnew<cr>
" map <leader>to :tabonly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tm :tabmove
" map <leader>t<leader> :tabnext<cr>

" " Let 'tl' toggle between this and the last accessed tab
" let g:lasttab = 1
" nmap <leader>tl :exe "tabn ".g:lasttab<CR>
" au TabLeave * let g:lasttab = tabpagenr()


" " Opens a new tab with the current buffer's path
" " Super useful when editing files in the same directory
" map <leader>te :tabedit <C-r>=escape(expand("%:p:h"), " ")<cr>/

" " Switch CWD to the directory of the open buffer
" map <leader>cd :cd %:p:h<cr>:pwd<cr>

" " Specify the behavior when switching between buffers
" try
"   set switchbuf=useopen,usetab,newtab
"   set stal=2
" catch
" endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" """"""""""""""""""""""""""""""
" " => Status line
" """"""""""""""""""""""""""""""
" " Always show the status line
" set laststatus=2
"
" " Format the status line
" set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Remap VIM 0 to first non-blank character
" map 0 ^

" " Move a line of text using ALT+[jk] or Command+[jk] on mac
" nmap <M-j> mz:m+<cr>`z
" nmap <M-k> mz:m-2<cr>`z
" vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
" vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

" if has("mac") || has("macunix")
"   nmap <D-j> <M-j>
"   nmap <D-k> <M-k>
"   vmap <D-j> <M-j>
"   vmap <D-k> <M-k>
" endif

" " Delete trailing white space on save, useful for some filetypes ;)
" fun! CleanExtraSpaces()
"     let save_cursor = getpos(".")
"     let old_query = getreg('/')
"     silent! %s/\s\+$//e
"     call setpos('.', save_cursor)
"     call setreg('/', old_query)
" endfun
"
" if has("autocmd")
"     autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
" endif
"
"
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " => Spell checking
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Pressing ,ss will toggle and untoggle spell checking
" map <leader>ss :setlocal spell!<cr>
"
" " Shortcuts using <leader>
" map <leader>sn ]s
" map <leader>sp [s
" map <leader>sa zg
" map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
" noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" " Quickly open a buffer for scribble
" map <leader>q :e ~/buffer<cr>
"
" " Quickly open a markdown buffer for scribble
" map <leader>x :e ~/buffer.md<cr>
"
" " Toggle paste mode on and off
" map <leader>pp :setlocal paste!<cr>


" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " => Helper functions
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Returns true if paste mode is enabled
" function! HasPaste()
"     if &paste
"         return 'PASTE MODE  '
"     endif
"     return ''
" endfunction

" " Don't close window, when deleting a buffer
" command! Bclose call <SID>BufcloseCloseIt()
" function! <SID>BufcloseCloseIt()
"     let l:currentBufNum = bufnr("%")
"     let l:alternateBufNum = bufnr("#")
"
"     if buflisted(l:alternateBufNum)
"         buffer #
"     else
"         bnext
"     endif
"
"     if bufnr("%") == l:currentBufNum
"         new
"     endif
"
"     if buflisted(l:currentBufNum)
"         execute("bdelete! ".l:currentBufNum)
"     endif
" endfunction

" function! CmdLine(str)
"     call feedkeys(":" . a:str)
" endfunction

" function! VisualSelection(direction, extra_filter) range
"     let l:saved_reg = @"
"     execute "normal! vgvy"
"
"     let l:pattern = escape(@", "\\/.*'$^~[]")
"     let l:pattern = substitute(l:pattern, "\n$", "", "")
"
"     if a:direction == 'gv'
"         call CmdLine("Ack '" . l:pattern . "' " )
"     elseif a:direction == 'replace'
"         call CmdLine("%s" . '/'. l:pattern . '/')
"     endif
"
"     let @/ = l:pattern
"     let @" = l:saved_reg
" endfunction

" f2dv.vim

set title
set titlestring=%F\ (%{expand('%:p:h')}) titlelen=80

set diffopt+=internal,algorithm:histogram

" Don't continue comment char on newline
set formatoptions-=cro

" never linebreak
set textwidth=0

" disable wrapping
set nowrap

" never fold on launch
set foldlevel=99

" show search result counts
" ref: https://vi.stackexchange.com/a/23296
set shortmess-=S

" Use `Q` to run quick macro, like Neovim.
nmap Q @q

" Confirm exit when closing last window.
function! ConfirmExit()
    let resp = confirm("", "&Quit All\n&Buffer Close\n&Window Close\n&Tab Close\n&Restart", 99)
    if resp == 1
        quitall
    elseif resp == 2
        Bdelete
    elseif resp == 3
        close
    elseif resp == 4
        tabclose
    elseif resp == 5
        silent! %bd | enew
    endif
endfunction

function! CloseOrConfirmExit()
  if winnr('$') > 1 || tabpagenr('$') > 1
      quit
  else
      call ConfirmExit()
  endif
endfunction

command! ConfirmExit call ConfirmExit()
command! CloseOrConfirmExit call CloseOrConfirmExit()

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

" quick write
nmap <leader>w :w<cr>
nmap <leader>W :wa<cr>
" quick quit
nmap <silent> <leader>q :CloseOrConfirmExit<cr>
nmap <silent> <leader>Q :ConfirmExit<cr>

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

" disable vim Ex mode
nnoremap Q <Nop>

" jump to first non-blank character
nnoremap H ^
vnoremap H ^
" jump to end of line
nnoremap L g_
vnoremap L g_

" grep uses `ripgrep`
set grepprg=rg\ --vimgrep\ --no-heading
set grepformat+=%f:%l:%c:%m

" "line" text-objects
" https://vi.stackexchange.com/a/6102
xnoremap il g_o^
onoremap il :normal vil<cr>
xnoremap al $o^
onoremap al :normal val<cr>

xnoremap iL g_o0
onoremap iL :normal viL<cr>
xnoremap aL $o0
onoremap aL :normal vaL<cr>

" paste and retain original value
" https://stackoverflow.com/a/7164121
xnoremap p pgvy

" make Y act like D and C (yank to EOL)
nmap Y y$

" change default split direction
set splitright
set splitbelow

" Show which line your cursor is on
set cursorline
hi CursorLine cterm=none

" Display line numbers
set number
" Display relative numbers for the active pane
augroup BgHighlight
    autocmd!
    autocmd WinEnter * setlocal cursorline "relativenumber
    autocmd WinLeave * setlocal nocursorline "norelativenumber
augroup END

" In Visual mode the size of the selected area is shown
set showcmd

" faster updates
set updatetime=333

" share vim with system clipboard
" https://stackoverflow.com/a/30691754
set clipboard^=unnamedplus

set breakindent

" don't mess with indenting comments
set nosmartindent
set cindent

" duration to respect key combinations
set timeout timeoutlen=300 ttimeoutlen=300

" enable mouse support in normal mode
set mouse=n

" easier scrollback in terminal
tnoremap <C-u> <C-\><C-n>

" Misc shortcuts

" Shortcut! :.!figbox surround line in ascii box (figbox)

" open file at position in new split
nmap <leader>gf :wincmd F<CR>
"
" diff this, diff off
nmap <leader>dft :windo diffthis<CR>
nmap <leader>dfo :diffoff!<CR>

" open window in new tab
nnoremap <leader><CR> :tab split<CR>

" clear highlight on pressing <Esc> in normal mode
nnoremap <Esc><Esc> :nohlsearch<CR>

" Quickly open a markdown buffer for scribble
command! Scratch :tabedit ~/.scratch.md

" Filetype configs
autocmd BufNewFile,BufRead *.yml.tpl,*.yaml.tpl setlocal filetype=yaml

autocmd FileType python setlocal colorcolumn=88
" autocmd FileType python,yaml,sh,zsh setlocal cinkeys-=0# indentkeys-=0#
" autocmd FileType yaml,helm setlocal foldmethod=indent foldcolumn=0 foldlevel=99

autocmd FileType yaml,sh,zsh setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python,markdown,vim,json setlocal ts=4 sts=4 sw=4 expandtab

autocmd filetype text,markdown setlocal wrap

if !has('nvim')
    exec 'source ~/.vim/vimrc.d/plugins.vimrc'
endif
