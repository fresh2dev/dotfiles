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
" `dt` opens a diff in vsplit in a new tab
autocmd FileType fugitive nmap <buffer> <silent> dt :Gtabedit <Plug><cfile><Bar>Gvdiffsplit \| wincmd l<CR>

let g:fugitive_no_maps = 1
let g:fugitive_legacy_commands = 0

cnoreabbrev <expr> g  (getcmdtype() ==# ':' && getcmdline() ==# 'g')  ? 'G'  : 'g'
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

" Git-related mappings
" Open Fugitive with git log split right.
nnoremap <leader>gg :Git \| vertical Git log --graph --oneline --decorate \| wincmd p \| normal i<CR>
nnoremap <leader>gG :0Git \| normal i<CR>
" Open new tab containing Fugitive with git log split bottom.
nnoremap <leader>gt :tabnew \| 0Git \| Git log --graph --oneline --decorate \| wincmd p \| normal i<CR>
" Close all windows and open Fugitive with git log split bottom.
nnoremap <leader>go :only \| 0Git \| Git log --graph --oneline --decorate \| wincmd p \| normal i<CR>
nnoremap <leader>gO :%bd \| 0Git \| Git log --graph --oneline --decorate \| wincmd p \| normal i<CR>
" nnoremap <leader>gE :bd1 \| 0Git \| Git log --graph --oneline --decorate \| wincmd p \| :5<CR>
nnoremap <leader>gb :Git blame -s<CR>
nnoremap <leader>gl :0Git log --graph --oneline --decorate<CR>
nnoremap <leader>gL :0Git log --graph --oneline --decorate --all<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gW :Gwrite!<CR>
nnoremap <leader>gd :tab split \| Gvdiffsplit \| wincmd l<CR>
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

Plug 'https://github.com/rhysd/conflict-marker.vim', { 'commit': '62742b2ffe7a433988759c67b5c5a22eff74a14b' }

let g:conflict_marker_enable_mappings = 0

nnoremap ]x :ConflictMarkerNextHunk<CR>
nnoremap [x :ConflictMarkerPrevHunk<CR>

nnoremap <leader>dG :diffget<CR>
nnoremap <leader>dgh :ConflictMarkerOurselves<CR>
nnoremap <leader>dgl :ConflictMarkerThemselves<CR>
nnoremap <leader>dga :ConflictMarkerBoth<CR>
nnoremap <leader>dgA :ConflictMarkerBoth!<CR>
nnoremap <leader>dgd :ConflictMarkerNone<CR>

" Heuristically set buffer options
Plug 'https://github.com/tpope/vim-sleuth', { 'commit': '1cc4557420f215d02c4d2645a748a816c220e99b' }

"vim-bbye (provides :Bdelete)
Plug 'https://github.com/moll/vim-bbye', { 'commit': '25ef93ac5a87526111f43e5110675032dbcacf56' }

"vim-symlink (follow symlinks)
Plug 'https://github.com/aymericbeaumet/vim-symlink', { 'commit': 'fec2d1a72c6875557109ce6113f26d3140b64374' }

"vim-qf
" Slightly better quickfix behavior (auto-open, auto-resize, auto-quit, allow `dd`, etc.)
Plug 'https://github.com/romainl/vim-qf', { 'commit': '7e65325651ff5a0b06af8df3980d2ee54cf10e14' }

" nnoremap <leader>tqf <Plug>(qf_qf_toggle_stay)
" nnoremap <leader>tll <Plug>(qf_loc_toggle_stay)
nnoremap gq <Plug>(qf_qf_switch)

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

Plug 'https://github.com/thinca/vim-qfreplace', { 'commit': '707a895f9f86eeed106f64da0bd9fa07b3cd9cee' }

autocmd FileType qf nnoremap <buffer> cc :Qfreplace<CR>

let g:qfreplace_no_save = 1

Plug 'https://github.com/yssl/QFEnter', { 'commit': '1e4bf00b264e0f1541401c28c4b63ace5bb3d2be' }

let g:qfenter_keymap = {}
let g:qfenter_keymap.open = ['<CR>', '<2-LeftMouse>']
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.hopen = ['<C-o>']
let g:qfenter_keymap.topen = ['<C-t>']

" Enable cfilter (https://neovim.io/doc/user/quickfix.html#%3ACfilter)
packadd cfilter
cnoreabbrev <expr> cfilter  (getcmdtype() ==# ':' && getcmdline() ==# 'cfilter')  ? 'Cfilter'  : 'cfilter'

"skywind3000/asyncrun.vim
Plug 'https://github.com/skywind3000/asyncrun.vim', { 'commit': '09b8117fe607941c0abff39b194074e40a3dee88' }

let g:asyncrun_open = 10
let g:asyncrun_last = 2
let g:asyncrun_trim = 1

command! -bar -nargs=* Rg :execute 'AsyncRun! rg --vimgrep' <q-args> | normal gq
command! -bar -nargs=* RgFile :execute 'AsyncRun! rg --vimgrep' <q-args> '"%"' | normal gq

command! -bar -nargs=* RuffCheck :execute 'AsyncRun! ruff check --output-format=concise' <q-args> | normal gq
command! -bar -nargs=* RuffCheckFile :execute 'AsyncRun! ruff check --output-format=concise "%"' <q-args> | normal gq

command! -bar -nargs=* PyTest :execute 'AsyncRun! pytest -vvv' <q-args> | normal gq
command! -bar -nargs=* PyTestFile :execute 'AsyncRun! pytest -vvv "%"' <q-args> | normal gq

command! -bar -nargs=* Aider :execute 'AsyncRun! -mode=terminal aider --git "%"' <q-args> | normal gq
command! -bar -nargs=* AiderFile :execute 'AsyncRun! -mode=terminal aider --no-git --file "%"' <q-args> | normal gq
command! -bar -nargs=* AiderDo :execute 'AsyncRun! -mode=terminal aider --git --message "Complete each request specified in each TODO comment" "%"' <q-args> | normal gq
command! -bar -nargs=* AiderDoFile :execute 'AsyncRun! -mode=terminal aider --no-git --message "Complete each request specified in each TODO comment" --file "%"' <q-args> | normal gq

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
Plug 'https://github.com/tpope/vim-eunuch', { 'commit': '6c6af39aa0a25223389607338ae965c5dfc7c972' }

" fix: https://github.com/tpope/vim-eunuch/issues/95#issuecomment-1183890098
let g:eunuch_no_maps = 1

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

" " vim-signature
" Plug 'https://github.com/kshenoy/vim-signature', { 'commit': '6bc3dd1294a22e897f0dcf8dd72b85f350e306bc' }
"
" " Only set global marks
" " let g:SignatureIncludeMarks = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
" let g:SignatureDeleteConfirmation = 1
" let g:SignaturePurgeConfirmation = 1
" let g:SignatureEnabledAtStartup = 1
" let g:SignatureDeferPlacement = 0
" let g:SignatureMap = {
"       \ 'Leader'             :  "m",
"       \ 'PlaceNextMark'      :  "",
"       \ 'ToggleMarkAtLine'   :  "m<CR>",
"       \ 'PurgeMarksAtLine'   :  "",
"       \ 'DeleteMark'         :  "dm",
"       \ 'PurgeMarks'         :  "",
"       \ 'PurgeMarkers'       :  "",
"       \ 'GotoNextLineAlpha'  :  "']",
"       \ 'GotoPrevLineAlpha'  :  "'[",
"       \ 'GotoNextSpotAlpha'  :  "`]",
"       \ 'GotoPrevSpotAlpha'  :  "`[",
"       \ 'GotoNextLineByPos'  :  "]'",
"       \ 'GotoPrevLineByPos'  :  "['",
"       \ 'GotoNextSpotByPos'  :  "]`",
"       \ 'GotoPrevSpotByPos'  :  "[`",
"       \ 'GotoNextMarker'     :  "]-",
"       \ 'GotoPrevMarker'     :  "[-",
"       \ 'GotoNextMarkerAny'  :  "]=",
"       \ 'GotoPrevMarkerAny'  :  "[=",
"       \ 'ListBufferMarks'    :  "",
"       \ 'ListBufferMarkers'  :  ""
"       \ }
"
" " this only deletes buffer-local marks (a-z)
" " nnoremap dM :delmarks! \| delmarks A-Z \| wshada! \| SignatureRefresh<CR>
" nnoremap gm :SignatureListGlobalMarks<CR>

" vim-bookmarks
Plug 'https://github.com/MattesGroeger/vim-bookmarks', { 'commit': '9cc5fa7ecc23b052bd524d07c85356c64b92aeef' }

let g:bookmark_no_default_key_mappings = 1

let g:bookmark_auto_save = 1
let g:bookmark_save_per_working_dir = 1

let g:bookmark_highlight_lines = 1
let g:bookmark_center = 1
let g:bookmark_disable_ctrlp = 1

let g:bookmark_show_warning = 1
let g:bookmark_show_toggle_warning = 1

" nmap mm <Plug>BookmarkToggle
nmap <leader>mm <Plug>BookmarkToggle
nmap <leader>mi <Plug>BookmarkAnnotate
nmap <leader>mn <Plug>BookmarkNext
nmap <leader>mp <Plug>BookmarkPrev
nmap <leader>mx <Plug>BookmarkClear
nmap <leader>mX <Plug>BookmarkClearAll
nmap <leader>mq :doautocmd BufEnter<CR><Plug>BookmarkShowAll
nmap gm <leader>mq
" nmap <Leader>kk <Plug>BookmarkMoveUp
" nmap <Leader>jj <Plug>BookmarkMoveDown
" nmap <Leader>g <Plug>BookmarkMoveToLine

" -----------------------------------------------------------------------------|
"                         __        __        ___  __   __          ___        |
"        \  / |  |\/| __ /__` |  | |__) \  / |__  |__) /__` | \  / |__         |
"         \/  |  |  |    .__/ \__/ |__)  \/  |___ |  \ .__/ |  \/  |___        |
"        - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -       |
"                                                                              |
" `-` for substitute                                                           |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/svermeulen/vim-subversive', { 'commit': '6286cda3f9222bfd490fe34a00a2d8cd4925adec' }

" let g:subversivePreserveCursorPosition = 1
" let g:subversivePromptWithCurrent = 1
" let g:subversivePromptWithActualCommand = 1

nnoremap s <plug>(SubversiveSubstitute)
xnoremap s <plug>(SubversiveSubstitute)
nnoremap ss <plug>(SubversiveSubstituteLine)
nnoremap S <plug>(SubversiveSubstituteToEndOfLine)

nnoremap - <plug>(SubversiveSubstituteWordRange)
xnoremap - <plug>(SubversiveSubstituteRange)

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

"vim-edgemotion
Plug 'https://github.com/haya14busa/vim-edgemotion', { 'commit': '8d16bd92f6203dfe44157d43be7880f34fd5c060' }

map gj <Plug>(edgemotion-j)
map gk <Plug>(edgemotion-k)
nnoremap gh ^
vnoremap gh ^
nnoremap gl $
vnoremap gl g_

"targets.vim
Plug 'https://github.com/wellle/targets.vim', { 'commit': '642d3a4ce306264b05ea3219920b13ea80931767' }

"matchup
Plug 'https://github.com/andymass/vim-matchup', { 'commit': '5fb083de1e06fdd134c6ad8d007d4b5576b25ba7' }
let g:loaded_matchit = 1
let g:matchup_matchparen_offscreen = {'method': 'popup'}
" let g:matchup_matchparen_enabled = 0
" let g:matchup_motion_enabled = 0
" let g:matchup_text_obj_enabled = 0
" let g:matchup_surround_enabled = 0
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_hi_surround_always = 1
let g:matchup_motion_override_Npercent = 0

" vim-zellij-navigator
Plug 'https://gitea.local.hostbutter.net/fresh2dev/zellij.vim', { 'commit': '511f864' }

let g:zelli_navigator_move_focus_or_tab = 1
let g:zellij_navigator_disable_autolock = 1

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

autocmd DirChanged,WinEnter,BufEnter *
      \ if &buftype == '' |
      \ call system('zellij action rename-tab "' . fnamemodify(getcwd(), ':t') . '"') |
      \ endif

if !has("nvim")
  " This plugins are only enabled for vanilla Vim.
  " Plug 'https://github.com/tpope/vim-commentary', { 'commit': 'f67e3e67ea516755005e6cccb178bc8439c6d402' }
  Plug 'https://github.com/machakann/vim-sandwich', { 'commit': '74cf93d58ccc567d8e2310a69860f1b93af19403' }

  Plug 'https://github.com/machakann/vim-highlightedyank', { 'commit': 'fa3f57b097e9521ce41a66b6c7cf5d9adea70ea3' }
  let g:highlightedyank_highlight_duration = 333

  Plug 'https://github.com/junegunn/vim-peekaboo', { 'commit': 'cc4469c204099c73dd7534531fa8ba271f704831' }
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

if !has("nvim")
  " Configure vim-sandwich to use vim-surround mappings.
  runtime macros/sandwich/keymap/surround.vim
endif
