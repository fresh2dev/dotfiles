if &compatible
  set nocompatible
endif

if empty($MYVIMRC)
  let $MYVIMRC = $HOME . "/.vimrc"
endif

if has('nvim')
  " Neovim can have distinct configurations using $NVIM_APPNAME
  " Using vim-plug, install plugins into Neovim's native plugin dir.
  let $VIM_HOME = stdpath('data')
  " let g:plug_home = $VIM_HOME.'/site/pack/plugged/start'
else
  " If using Vim, set VIM_HOME to "$MYVIMRC.parent / .vim"
  let $VIM_HOME = fnamemodify(resolve(expand($MYVIMRC.':p')), ':h') . "/.vim"
endif
exec 'set runtimepath+=' . $VIM_HOME
let g:plug_home = $VIM_HOME.'/plugged'

" -----------------------------------------------------------------------------|
"                                      __             __                       |
"                     \  / |  |\/| __ |__) |    |  | / _`                      |
"                      \/  |  |  |    |    |___ \__/ \__>                      |
"                     - - - - - - - - - - - - - - - - - -                      |
"                                                                              |
"                                                                              |
"                                                                              |
"                                                                              |
"                                                                              |
"                                                                              |
"                                                                              |
" -----------------------------------------------------------------------------|
" Install https://github.com/junegunn/vim-plug
if !filereadable(expand($VIM_HOME.'/autoload/plug.vim'))
  if has('win32')
    !powershell -NoProfile -c "Invoke-WebRequest https://raw.githubusercontent.com/junegunn/vim-plug/0.13.0/plug.vim -UseBasicParsing | New-Item -Force $env:VIM_HOME/autoload/plug.vim"
  else
    silent !curl -fLo "$VIM_HOME/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/0.13.0/plug.vim
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:plug_window = 'enew'

call plug#begin(g:plug_home)

" Lazy.nvim
if has("nvim")
  Plug 'https://github.com/folke/lazy.nvim', { 'commit': '48b52b5cfcf8f88ed0aff8fde573a5cc20b1306d' }
  command! PlugSync :PlugClean!|PlugInstall|silent! Lazy sync
else
  command! PlugSync :PlugClean!|PlugInstall
endif

" -----------------------------------------------------------------------------|
"                                ___       __    ___         ___               |
"               \  / |  |\/| __ |__  |  | / _` |  |  | \  / |__                |
"                \/  |  |  |    |    \__/ \__> |  |  |  \/  |___               |
"               - - - - - - - - - - - - - - - - - - - - - - - - -              |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/tpope/vim-fugitive', { 'commit': '0444df68cd1cdabc7453d6bd84099458327e5513' }

" automatically `cd` to git root.
autocmd VimEnter * silent! Gcd

" Quit fugitive with `q`:
" autocmd FileType fugitive,fugitiveblame nmap <buffer> q gq
autocmd FileType fugitive,fugitiveblame,floggraph nmap <buffer> q gq
autocmd FileType git nmap <buffer> q :close<CR>
" `<CR>` opens blame in new split:
autocmd FileType fugitiveblame nmap <buffer> <CR> o
" `O` opens a vsplit in Fugitive (overrides opening in tab)
autocmd FileType fugitive nmap <buffer> O gO

let g:fugitive_no_maps = 1
let g:fugitive_legacy_commands = 0

cnoreabbrev <expr> g  (getcmdtype() ==# ':' && getcmdline() ==# 'g')  ? 'G'  : 'g'
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

" Git-related mappings
" Open Fugitive with git log split right.
nnoremap <leader>gg :Git \| vertical Git log --graph --oneline --decorate \| wincmd p \| :5<CR>
" Open new tab containing Fugitive with git log split bottom.
nnoremap <leader>gt :tabnew \| 0Git \| Git log --graph --oneline --decorate \| wincmd p \| :5<CR>
" Close all windows and open Fugitive with git log split bottom.
nnoremap <leader>go :only \| 0Git \| Git log --graph --oneline --decorate \| wincmd p \| :5<CR>
nnoremap <leader>gO :%bd \| 0Git \| Git log --graph --oneline --decorate \| wincmd p \| :5<CR>
" nnoremap <leader>gE :bd1 \| 0Git \| Git log --graph --oneline --decorate \| wincmd p \| :5<CR>
nnoremap <leader>gb :Git blame -s<CR>
nnoremap <leader>gl :0Git log --graph --oneline --decorate<CR>
nnoremap <leader>gL :0Git log --graph --oneline --decorate --all<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gd :Gvdiffsplit<CR>
" "Git Revisions" Populate quickfix with past revisions of current file.
nnoremap <leader>gr :1,$GcLog!<CR>
xnoremap <leader>gr :GcLog!<CR>
nnoremap <leader>gss :Git stash save<CR>
nnoremap <leader>gsp :Git stash pop<CR>
nnoremap <leader>gsa :Git stash apply<CR>
nnoremap <leader>gsx :Git stash clear<CR>
nnoremap <leader>gS :Git fetch --all \| Git pull \| Git fetch origin main:main \| Git rebase main<CR>
nnoremap <leader>gp :Git push -u origin<CR>
nnoremap <leader>gP :Git push -fu origin<CR>

" Heuristically set buffer options
Plug 'https://github.com/tpope/vim-sleuth', { 'commit': '1cc4557420f215d02c4d2645a748a816c220e99b' }

"vim-bbye (provides :Bdelete)
Plug 'https://github.com/moll/vim-bbye', { 'commit': '25ef93ac5a87526111f43e5110675032dbcacf56' }

"vim-symlink (follow symlinks)
Plug 'https://github.com/aymericbeaumet/vim-symlink', { 'commit': 'fec2d1a72c6875557109ce6113f26d3140b64374' }

"vim-qf
" Slightly better quickfix behavior (auto-open, auto-resize, auto-quit, allow `dd`, etc.)
Plug 'https://github.com/romainl/vim-qf', { 'commit': '7e65325651ff5a0b06af8df3980d2ee54cf10e14' }

nnoremap <leader>tqf <Plug>(qf_qf_toggle_stay)
nnoremap <leader>tll <Plug>(qf_loc_toggle_stay)
nnoremap gq <Plug>(qf_qf_switch)

let g:qf_mapping_ack_style = 0
let g:qf_window_bottom = 1
let g:qf_loclist_window_bottom = 1
let g:qf_auto_open_quickfix = 1
let g:qf_auto_open_loclist = 1
let g:qf_auto_resize = 1
let g:qf_max_height = 10
let g:qf_auto_quit = 1
let g:qf_save_win_view = 1
let g:qf_nowrap = 1
let g:qf_shorten_path = 0

autocmd FileType qf nnoremap <buffer> dd :.Reject<CR>
autocmd FileType qf xnoremap <buffer> dd :Reject<CR>
autocmd FileType qf nnoremap <buffer> D :Reject<CR>

" Enable cfilter (https://neovim.io/doc/user/quickfix.html#%3ACfilter)
packadd cfilter
cnoreabbrev <expr> cfilter  (getcmdtype() ==# ':' && getcmdline() ==# 'cfilter')  ? 'Cfilter'  : 'cfilter'

" -----------------------------------------------------------------------------|
"                          __   ___      ___     __   __        ___  __  ___   |
"  \  / |  |\/| __ | |\ | |  \ |__  |\ |  |  __ /  \ |__)    | |__  /  `  |    |
"   \/  |  |  |    | | \| |__/ |___ | \|  |     \__/ |__) \__/ |___ \__,  |    |
"  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/michaeljsmith/vim-indent-object', { 'commit': '5c5b24c959478929b54a9e831a8e2e651a465965' }

" Easy-align
Plug 'https://github.com/junegunn/vim-easy-align', { 'commit': '9815a55dbcd817784458df7a18acacc6f82b1241' }
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" -----------------------------------------------------------------------------|
"                               __   __  ___  __   ___  ___                    |
"                    |  | |\ | |  \ /  \  |  |__) |__  |__                     |
"                    \__/ | \| |__/ \__/  |  |  \ |___ |___                    |
"                    - - - - - - - - - - - - - - - - - - - -                   |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/mbbill/undotree', { 'commit': '0e11ba7325efbbb3f3bebe06213afa3e7ec75131' }

nnoremap U :UndotreeToggle<CR>

" -----------------------------------------------------------------------------|
"                            __        __   __   __             __             |
"           \  / |  |\/| __ /__` |  | |__) |__) /  \ |  | |\ | |  \            |
"            \/  |  |  |    .__/ \__/ |  \ |  \ \__/ \__/ | \| |__/            |
"           - - - - - - - - - - - - - - - - - - - - - - - - - - - -            |
"                                                                              |
" -----------------------------------------------------------------------------|
" Plug 'https://github.com/tpope/vim-surround', { 'commit': '3d188ed2113431cf8dac77be61b842acb64433d9' }

" -----------------------------------------------------------------------------|
"                                  __   ___  __   ___      ___                 |
"                 \  / |  |\/| __ |__) |__  |__) |__   /\   |                  |
"                  \/  |  |  |    |  \ |___ |    |___ /~~\  |                  |
"                 - - - - - - - - - - - - - - - - - - - - - - -                |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/tpope/vim-repeat', { 'commit': '24afe922e6a05891756ecf331f39a1f6743d3d5a' }

" -----------------------------------------------------------------------------|
"                              __   ___       __     __        ___             |
"             \  / |  |\/| __ /__` |__  |\ | /__` | |__) |    |__              |
"              \/  |  |  |    .__/ |___ | \| .__/ | |__) |___ |___             |
"             - - - - - - - - - - - - - - - - - - - - - - - - - - -            |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/tpope/vim-sensible', { 'commit': '3e878abfd6ddc6fb5dba48b41f2b72c3a2f8249f' }

"unimpaired
" Plug 'https://github.com/tpope/vim-unimpaired', { 'commit': '6d44a6dc2ec34607c41ec78acf81657248580bf1' }

" -----------------------------------------------------------------------------|
"                                 ___                 __                       |
"                \  / |  |\/| __ |__  |  | |\ | |  | /  ` |__|                 |
"                 \/  |  |  |    |___ \__/ | \| \__/ \__, |  |                 |
"                - - - - - - - - - - - - - - - - - - - - - - -                 |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/tpope/vim-eunuch', { 'commit': '67f3dd32b4dcd1c427085f42ff5f29c7adc645c6' }

" -----------------------------------------------------------------------------|
"                               __       ___            __   __                |
"              \  / |  |\/| __ /  ` |  |  |  |     /\  /__` /__`               |
"               \/  |  |  |    \__, \__/  |  |___ /~~\ .__/ .__/               |
"              - - - - - - - - - - - - - - - - - - - - - - - - -               |
"                                                                              |
" original delete `d` behavior exists with new mapping `m`                     |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/svermeulen/vim-cutlass', { 'commit': '7afd649415541634c8ce317fafbc31cd19d57589' }

nnoremap m d
xnoremap m d
nnoremap mm dd
nnoremap M D

" -----------------------------------------------------------------------------|
"                         __        __        ___  __   __          ___        |
"        \  / |  |\/| __ /__` |  | |__) \  / |__  |__) /__` | \  / |__         |
"         \/  |  |  |    .__/ \__/ |__)  \/  |___ |  \ .__/ |  \/  |___        |
"        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -       |
"                                                                              |
" `-` for substitute                                                           |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/svermeulen/vim-subversive', { 'commit': '6286cda3f9222bfd490fe34a00a2d8cd4925adec' }

" nmap - <plug>(SubversiveSubstitute)
" nmap -- <plug>(SubversiveSubstituteLine)
" nmap _ <plug>(SubversiveSubstituteToEndOfLine)
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

"vim-exchange
Plug 'https://github.com/tommcdo/vim-exchange', { 'commit': 'd6c1e9790bcb8df27c483a37167459bbebe0112e' }

"vim-asterisk
Plug 'https://github.com/haya14busa/vim-asterisk', { 'commit': '77e97061d6691637a034258cc415d98670698459' }

map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)

"targets.vim
Plug 'https://github.com/wellle/targets.vim', { 'commit': '642d3a4ce306264b05ea3219920b13ea80931767' }

" vim-zellij-navigator
Plug 'https://gitea.local.hostbutter.net/fresh2dev/zellij.vim', { 'commit': '09c21b8ae429bbab575b003e9c750019f2c6d1f7' }

let g:zelli_navigator_move_focus_or_tab = 0
let g:zellij_navigator_disable_autolock = 0

" Open ZelliJ floating pane.
nnoremap <leader>zjf :ZellijNewPane<CR>
" Open ZelliJ pane below.
nnoremap <leader>zjo :ZellijNewPaneSplit<CR>
" Open ZelliJ pane to the right.
nnoremap <leader>zjv :ZellijNewPaneVSplit<CR>

" Open floating Zellij pane with `Alt+f`.
execute "set <M-t>=\ef"
noremap <M-t> :ZellijNewPane<CR>
" Open Zellij pane below with `Alt+t`.
execute "set <M-o>=\et"
noremap <M-o> :ZellijNewPaneSplit<CR>
" Open Zellij pane to the right with `Alt+v`.
execute "set <M-v>=\ev"
noremap <M-v> :ZellijNewPaneVSplit<CR>

" Run command in new ZelliJ floating pane.
nnoremap <leader>zjrf :execute 'ZellijNewPane ' . input('Command: ')<CR>
" Run command in new ZelliJ pane below.
nnoremap <leader>zjro :execute 'ZellijNewPaneSplit ' . input('Command: ')<CR>
" Run command in new ZelliJ pane to the right.
nnoremap <leader>zjrv :execute 'ZellijNewPaneVSplit ' . input('Command: ')<CR>

" Run `ruff` Python linter in new ZelliJ pane below.
nnoremap <leader>zjrr :execute 'ZellijNewPaneSplit ruff check "' . expand('%') . '"'<CR>
nnoremap <leader>zjrR :ZellijNewPaneSplit ruff check<CR>

autocmd DirChanged,BufEnter *
      \ if &buftype == '' |
      \ call system('zellij action rename-tab "' . fnamemodify(getcwd(), ':t') . '"') |
      \ endif

if !has("nvim")
  " This plugins are only enabled for vanilla Vim.
  Plug 'https://github.com/tpope/vim-commentary', { 'commit': 'f67e3e67ea516755005e6cccb178bc8439c6d402' }
  " Plug 'https://github.com/machakann/vim-sandwich', { 'commit': '74cf93d58ccc567d8e2310a69860f1b93af19403' }

  Plug 'https://github.com/machakann/vim-highlightedyank', { 'commit': 'fa3f57b097e9521ce41a66b6c7cf5d9adea70ea3' }
  let g:highlightedyank_highlight_duration = 333

  " "auto-pairs
  " Plug 'https://github.com/jiangmiao/auto-pairs', { 'commit': '39f06b873a8449af8ff6a3eee716d3da14d63a76' }
  " let g:AutoPairsShortcutToggle = ''
else
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * lua require'vim.highlight'.on_yank { { higroup = 'Visual', timeout = 333 } }
  augroup END
endif

" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()

" You can revert the settings after the call like so:
"   filetype indent off   `Disable file-type-specific indentation`
"   syntax off            `Disable syntax highlighting`

" if !has("nvim")
"   " Configure vim-sandwich to use vim-surround mappings.
"   runtime macros/sandwich/keymap/surround.vim
" endif