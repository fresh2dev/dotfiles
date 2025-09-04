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
  Plug 'https://github.com/folke/lazy.nvim', { 'commit': '6c3bda4aca61a13a9c63f1c1d1b16b9d3be90d7a' }
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
Plug 'https://github.com/tpope/vim-fugitive', { 'commit': 'd3e2b58dec75fc6012fecc82ce0d33a45ed0560e' }

" automatically `cd` to git root.
autocmd VimEnter * silent! Gcd

" Quit fugitive with `q`:
autocmd FileType fugitive,fugitiveblame,floggraph nmap <buffer> q gq
" always delete hidden buffers of these types,
" so git never waits for them to close.
autocmd FileType gitcommit,gitrebase set bufhidden=delete
autocmd FileType git nmap <buffer> q :close<CR>
" `<CR>` opens blame in new split:
autocmd FileType fugitiveblame nmap <buffer> <CR> o
" `O` opens a vsplit in Fugitive (overrides opening in tab)
autocmd FileType fugitive nmap <buffer> O gO
" `dt` opens a diff in vsplit in a new tab
autocmd FileType fugitive nmap <buffer> <silent> dt :Gtabedit <Plug><cfile><Bar>Gvdiffsplit \| wincmd l<CR>

let g:fugitive_no_maps = 1
let g:fugitive_legacy_commands = 0

cnoreabbrev <expr> g  (getcmdtype() ==# ':' && getcmdline() ==# 'g')  ? 'Git'  : 'g'
cnoreabbrev <expr> git (getcmdtype() ==# ':' && getcmdline() ==# 'git') ? 'Git' : 'git'

" Git-related mappings
" Open Fugitive with git log split right.
nnoremap <leader>G :0Git \| normal i<CR>
nnoremap <leader>gg :Git \| vertical Git log --graph --oneline --decorate \| wincmd p \| normal i<CR>
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
nnoremap <leader>gS :Git sync<CR>
nnoremap <leader>gp :Git push -u origin<CR>
nnoremap <leader>gP :Git push -fu origin<CR>

Plug 'https://github.com/nanotee/zoxide.vim', { 'commit': 'b1e70b6fc1682a83929aee63680d2b43456fe9a5' }

let g:zoxide_use_select = 1

cnoreabbrev <expr> z (getcmdtype() ==# ':' && getcmdline() ==# 'z') ? 'Z' : 'z'
cnoreabbrev <expr> zi (getcmdtype() ==# ':' && getcmdline() ==# 'zi') ? 'Zi' : 'zi'

nnoremap <leader>zi :Zi<CR>

Plug 'https://github.com/rhysd/conflict-marker.vim', { 'commit': '62742b2ffe7a433988759c67b5c5a22eff74a14b' }

let g:conflict_marker_enable_mappings = 0

nnoremap ]x :ConflictMarkerNextHunk<CR>
nnoremap [x :ConflictMarkerPrevHunk<CR>

nnoremap <leader>dg :diffget<CR>

" Heuristically set buffer options
Plug 'https://github.com/tpope/vim-sleuth', { 'commit': 'be69bff86754b1aa5adcbb527d7fcd1635a84080' }

" Substitute text with variant-awareness
Plug 'https://github.com/tpope/vim-abolish', { 'commit': 'dcbfe065297d31823561ba787f51056c147aa682' }

"vim-bbye (provides :Bdelete)
Plug 'https://github.com/moll/vim-bbye', { 'commit': '25ef93ac5a87526111f43e5110675032dbcacf56' }

" "vim-symlink (follow symlinks)
" Plug 'https://github.com/aymericbeaumet/vim-symlink', { 'commit': 'fec2d1a72c6875557109ce6113f26d3140b64374' }

"vim-qf
" Slightly better quickfix behavior (auto-open, auto-resize, auto-quit, allow `dd`, etc.)
Plug 'https://github.com/romainl/vim-qf', { 'commit': '7cafff6a9e0a1b54364b26a87f1efe749f8fb96b' }

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
Plug 'https://github.com/skywind3000/asyncrun.vim', { 'commit': 'e17c49c67d1dd847cd1d7d6077a7168816f546cc' }

let g:asyncrun_open = 10
let g:asyncrun_last = 2
let g:asyncrun_trim = 1

command! -bar -nargs=* Rg :execute 'AsyncRun! rg --vimgrep' <q-args> | normal gq
command! -bar -nargs=* RgFile :execute 'AsyncRun! rg --vimgrep' <q-args> '"%"' | normal gq

command! -bar -nargs=* RuffCheck :execute 'AsyncRun! ruff check --output-format=concise' <q-args> | normal gq
command! -bar -nargs=* RuffCheckFile :execute 'AsyncRun! ruff check --output-format=concise "%"' <q-args> | normal gq

command! -bar -nargs=* PyTest :execute 'AsyncRun! pytest -vvv' <q-args> | normal gq
command! -bar -nargs=* PyTestFile :execute 'AsyncRun! pytest -vvv "%"' <q-args> | normal gq

" -----------------------------------------------------------------------------|
"                          __   ___      ___     __   __        ___  __  ___   |
"  \  / |  |\/| __ | |\ | |  \ |__  |\ |  |  __ /  \ |__)    | |__  /  `  |    |
"   \/  |  |  |    | | \| |__/ |___ | \|  |     \__/ |__) \__/ |___ \__,  |    |
"  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/michaeljsmith/vim-indent-object', { 'commit': '8ab36d5ec2a3a60468437a95e142ce994df598c6' }

" Easy-align
Plug 'https://github.com/junegunn/vim-easy-align', { 'commit': '9815a55dbcd817784458df7a18acacc6f82b1241' }
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


" " -----------------------------------------------------------------------------|
" "                               __   __  ___  __   ___  ___                    |
" "                    |  | |\ | |  \ /  \  |  |__) |__  |__                     |
" "                    \__/ | \| |__/ \__/  |  |  \ |___ |___                    |
" "                    - - - - - - - - - - - - - - - - - - - -                   |
" "                                                                              |
" " -----------------------------------------------------------------------------|
" Plug 'https://github.com/mbbill/undotree', { 'commit': '28f2f54a34baff90ea6f4a735ef1813ad875c743' }
"
" nnoremap U :UndotreeToggle<CR>

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
Plug 'https://github.com/tpope/vim-repeat', { 'commit': '65846025c15494983dafe5e3b46c8f88ab2e9635' }

" -----------------------------------------------------------------------------|
"                              __   ___       __     __        ___             |
"             \  / |  |\/| __ /__` |__  |\ | /__` | |__) |    |__              |
"              \/  |  |  |    .__/ |___ | \| .__/ | |__) |___ |___             |
"             - - - - - - - - - - - - - - - - - - - - - - - - - - -            |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/tpope/vim-sensible', { 'commit': '0ce2d843d6f588bb0c8c7eec6449171615dc56d9' }

"unimpaired
" Plug 'https://github.com/tpope/vim-unimpaired', { 'commit': '6d44a6dc2ec34607c41ec78acf81657248580bf1' }

" -----------------------------------------------------------------------------|
"                                 ___                 __                       |
"                \  / |  |\/| __ |__  |  | |\ | |  | /  ` |__|                 |
"                 \/  |  |  |    |___ \__/ | \| \__/ \__, |  |                 |
"                - - - - - - - - - - - - - - - - - - - - - - -                 |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/tpope/vim-eunuch', { 'commit': 'e86bb794a1c10a2edac130feb0ea590a00d03f1e' }
" fix: https://github.com/tpope/vim-eunuch/issues/95#issuecomment-1183890098
let g:eunuch_no_maps = 1

" " auto-insert pairs
" Plug 'https://github.com/cohama/lexima.vim', { 'commit': 'ab621e4756465c9d354fce88cff2bd1aa7887065' }

" Cutlass
Plug 'https://github.com/svermeulen/vim-cutlass', { 'commit': '7afd649415541634c8ce317fafbc31cd19d57589' }
nnoremap d d
xnoremap d d
nnoremap dd dd
nnoremap D D

" Make it so that `dd` only populates the default register
" when the current line is not only whitespace.
function! Smart_dd()
    if match(getline("."), '^\s*$') != -1
        return '"_dd'
    endif
    return "dd"
endfunction

nnoremap <expr> dd Smart_dd()

" " vim-signature
" Plug 'https://github.com/kshenoy/vim-signature', { 'commit': '6bc3dd1294a22e897f0dcf8dd72b85f350e306bc' }
"
" " Only set global marks
" let g:SignatureIncludeMarks = 'ABCDEFGHIJKLNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'  " Excludes `M`
" let g:SignatureDeleteConfirmation = 1
" let g:SignaturePurgeConfirmation = 1
" let g:SignatureEnabledAtStartup = 1
" let g:SignatureDeferPlacement = 0
" let g:SignatureMap = {
"       \ 'Leader'             :  "M",
"       \ 'PlaceNextMark'      :  "",
"       \ 'ToggleMarkAtLine'   :  "MM",
"       \ 'PurgeMarksAtLine'   :  "",
"       \ 'DeleteMark'         :  "",
"       \ 'PurgeMarks'         :  "",
"       \ 'PurgeMarkers'       :  "",
"       \ 'GotoNextLineAlpha'  :  "",
"       \ 'GotoPrevLineAlpha'  :  "",
"       \ 'GotoNextSpotAlpha'  :  "",
"       \ 'GotoPrevSpotAlpha'  :  "",
"       \ 'GotoNextLineByPos'  :  "",
"       \ 'GotoPrevLineByPos'  :  "",
"       \ 'GotoNextSpotByPos'  :  "",
"       \ 'GotoPrevSpotByPos'  :  "",
"       \ 'GotoNextMarker'     :  "",
"       \ 'GotoPrevMarker'     :  "",
"       \ 'GotoNextMarkerAny'  :  "",
"       \ 'GotoPrevMarkerAny'  :  "",
"       \ 'ListBufferMarks'    :  "",
"       \ 'ListBufferMarkers'  :  ""
"       \ }
"
" " this only deletes buffer-local marks (a-z)
" " nnoremap dM :delmarks! \| delmarks A-Z \| wshada! \| SignatureRefresh<CR>
" nnoremap gM :SignatureListGlobalMarks<CR>

" " vim-bookmarks
" Plug 'https://github.com/MattesGroeger/vim-bookmarks', { 'commit': '9cc5fa7ecc23b052bd524d07c85356c64b92aeef' }
"
" let g:bookmark_no_default_key_mappings = 1
"
" let g:bookmark_auto_save = 1
" let g:bookmark_save_per_working_dir = 1
"
" let g:bookmark_highlight_lines = 1
" let g:bookmark_center = 1
" let g:bookmark_disable_ctrlp = 1
"
" let g:bookmark_show_warning = 1
" let g:bookmark_show_toggle_warning = 1
"
" nmap mm <Plug>BookmarkToggle
" nmap mi <Plug>BookmarkAnnotate
" nmap mn <Plug>BookmarkNext
" nmap mp <Plug>BookmarkPrev
" nmap mx <Plug>BookmarkClear
" nmap mX <Plug>BookmarkClearAll
" " see: https://github.com/MattesGroeger/vim-bookmarks/issues/185
" " nmap mq :doautocmd BufEnter<CR><Plug>BookmarkShowAll
" nmap mq <Plug>BookmarkShowAll<Plug>BookmarkShowAll<Plug>BookmarkShowAll
" nmap gm mq
" " nmap <Leader>kk <Plug>BookmarkMoveUp
" " nmap <Leader>jj <Plug>BookmarkMoveDown
" " nmap <Leader>g <Plug>BookmarkMoveToLine

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
Plug 'https://github.com/wellle/targets.vim', { 'commit': '6325416da8f89992b005db3e4517aaef0242602e' }

"matchup
let g:loaded_matchit = 1
Plug 'https://github.com/andymass/vim-matchup', { 'commit': '81313f17443df6974cafa094de52df32b860e1b7' }
let g:matchup_matchparen_offscreen = {'method': 'popup'}
" let g:matchup_matchparen_enabled = 0
" let g:matchup_motion_enabled = 0
" let g:matchup_text_obj_enabled = 0
" let g:matchup_surround_enabled = 0
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_hi_surround_always = 1
let g:matchup_motion_override_Npercent = 100
let g:matchup_treesitter_disable_virtual_text = v:true

" vim-zellij-navigator
Plug 'https://forgejo.local.hostbutter.net/fresh2dev/zellij.vim', { 'commit': 'e5425ea646d57902f0eb68ab58e9abbd16382e10' }

" let g:zelli_navigator_move_focus_or_tab = 1

" " Open Zellij tab with `Alt+n`.
" execute "set <M-n>=\en"
" noremap <M-n> :ZellijNewTab<CR>
" " Open floating Zellij pane with `Alt+f`.
" execute "set <M-t>=\ef"
" noremap <M-t> :ZellijNewPane<CR>
" " Open Zellij pane below with `Alt+t`.
" execute "set <M-o>=\et"
" noremap <M-o> :ZellijNewPaneSplit<CR>
" " Open Zellij pane to the right with `Alt+v`.
" execute "set <M-v>=\ev"
" noremap <M-v> :ZellijNewPaneVSplit<CR>

" Run command in new ZelliJ floating pane.
nnoremap <leader>zjrf :execute 'ZellijNewPane ' . input('Command: ')<CR>
" Run command in new ZelliJ pane below.
nnoremap <leader>zjro :execute 'ZellijNewPaneSplit ' . input('Command: ')<CR>
" Run command in new ZelliJ pane to the right.
nnoremap <leader>zjrv :execute 'ZellijNewPaneVSplit ' . input('Command: ')<CR>

" " Run `ruff` Python linter in new ZelliJ pane below.
" nnoremap <leader>zjrr :execute 'ZellijNewPaneSplit ruff check "' . expand('%') . '"'<CR>
" nnoremap <leader>zjrR :ZellijNewPaneSplit ruff check<CR>

autocmd DirChanged,BufEnter *
  \ call system('zellij action rename-tab "' . fnamemodify(getcwd(), ':t') . '"')

if !has("nvim")
  " These plugins are only enabled for vanilla Vim.

  " Plug 'https://github.com/tpope/vim-commentary', { 'commit': '64a654ef4a20db1727938338310209b6a63f60c9' }
  Plug 'https://github.com/machakann/vim-sandwich', { 'commit': '74cf93d58ccc567d8e2310a69860f1b93af19403' }

  Plug 'https://github.com/machakann/vim-highlightedyank', { 'commit': '285a61425e79742997bbde76a91be6189bc988fb' }
  let g:highlightedyank_highlight_duration = 333

  Plug 'https://github.com/junegunn/vim-peekaboo', { 'commit': 'cc4469c204099c73dd7534531fa8ba271f704831' }

  Plug 'https://github.com/tommcdo/vim-exchange', { 'commit': 'd6c1e9790bcb8df27c483a37167459bbebe0112e' }

  Plug 'https://github.com/svermeulen/vim-subversive', { 'commit': 'cea98a62ded4028118ad71c3e81b26eff2e0b8a0' }
  " let g:subversivePreserveCursorPosition = 1
  " let g:subversivePromptWithCurrent = 1
  " let g:subversivePromptWithActualCommand = 1
  nnoremap s <plug>(SubversiveSubstituteRangeConfirm)
  xnoremap s <plug>(SubversiveSubstituteRangeConfirm)
  nnoremap ss <plug>(SubversiveSubstituteWordRangeConfirm)
  " NOTE: `S` is used by vim-surround for visual selection.
  " nnoremap S <plug>(SubversiveSubvertRangeConfirm)
  " xnoremap S <plug>(SubversiveSubvertRangeConfirm)
  " nnoremap SS <plug>(SubversiveSubvertWordRangeConfirm)

else
  " These subversive mappings are handled by `mini.operators` in neovim.
  nnoremap <leader>p <plug>(SubversiveSubstitute)
  xnoremap <leader>p <plug>(SubversiveSubstitute)
  " nnoremap -- ^<plug>(SubversiveSubstituteLine)
  nmap <leader>pp 0<leader>p$==
  " nmap <leader>P <plug>(SubversiveSubstituteToEndOfLine)
  nmap <leader>P <leader>p$
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

