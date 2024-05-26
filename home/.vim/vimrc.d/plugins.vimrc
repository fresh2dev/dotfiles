if &compatible
  set nocompatible
endif

" https://stackoverflow.com/a/18734557
" let $THIS_DIR = fnamemodify(resolve(expand('<sfile>:p')), ':h')
if empty($VIM_HOME) | let $VIM_HOME = $HOME."/.vim"      | endif
exec 'set runtimepath+=' . $VIM_HOME


if has('nvim')
    let g:python3_host_prog = $VIM_HOME . '/.venv/bin/python3'
else
    let $PYTHONPATH = join(glob($VIM_HOME . '/.venv/lib/python*/site-packages', 1, 1), ":") . ':' . $PYTHONPATH
endif

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
if !filereadable(expand($VIM_HOME.'/autoload/plug.vim'))
  if has('win32')
    !powershell -NoProfile -c "Invoke-WebRequest https://raw.githubusercontent.com/junegunn/vim-plug/0.13.0/plug.vim -UseBasicParsing | New-Item -Force $env:VIM_HOME/autoload/plug.vim"
  else
    silent !curl -fLo "$VIM_HOME/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/0.13.0/plug.vim
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:plug_window = 'enew'

call plug#begin($VIM_HOME.'/plugged')

command! PlugSync :PlugClean!|PlugInstall

" -----------------------------------------------------------------------------|
"                                ___       __    ___         ___               |
"               \  / |  |\/| __ |__  |  | / _` |  |  | \  / |__                |
"                \/  |  |  |    |    \__/ \__> |  |  |  \/  |___               |
"               - - - - - - - - - - - - - - - - - - - - - - - - -              |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/tpope/vim-fugitive', { 'commit': 'a83135b55b018a891e0803199c3d418010a404d8' }

let g:fugitive_no_maps = 1
let g:fugitive_legacy_commands = 0

" -----------------------------------------------------------------------------|
"                                      ___       __   __                       |
"                     \  / |  |\/| __ |__  |    /  \ / _`                      |
"                      \/  |  |  |    |    |___ \__/ \__>                      |
"                     - - - - - - - - - - - - - - - - - -                      |
"                                                                              |
" -----------------------------------------------------------------------------|
" Plug 'https://github.com/rbong/vim-flog', { 'commit': 'bb1fda0cac110aef3f1c0ac00be813377b2b9bf0' }

"gv.vim
Plug 'https://github.com/junegunn/gv.vim', { 'commit': 'b6bb6664e2c95aa584059f195eb3a9f3cb133994' }

" Shortcut [git] view log of visual selection
" Shortcut! :GV!<CR> [git] show commits for the current file
" Shortcut! :GV?<CR> [git] fill loclist with commits for the current file or line

" -----------------------------------------------------------------------------|
"                                  __   __   __  ___  ___  __                  |
"                 \  / |  |\/| __ |__) /  \ /  \  |  |__  |__)                 |
"                  \/  |  |  |    |  \ \__/ \__/  |  |___ |  \                 |
"                 - - - - - - - - - - - - - - - - - - - - - - -                |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/airblade/vim-rooter', { 'commit': '1353fa47ee3a81083c284e28ff4f7d92655d7c9e' }

" Shortcut! :RooterToggle<cr> toggle vim-rooter

let g:rooter_patterns = ['.git']
let g:rooter_cd_cmd = 'lcd'
let g:rooter_buftypes = ['']
let g:rooter_silent_chdir = 0
let g:rooter_resolve_links = 0

"vim-bbye
Plug 'https://github.com/moll/vim-bbye', { 'commit': '25ef93ac5a87526111f43e5110675032dbcacf56' }
"vim-symlink
Plug 'https://github.com/aymericbeaumet/vim-symlink', { 'commit': 'fec2d1a72c6875557109ce6113f26d3140b64374' }

" -----------------------------------------------------------------------------|
"                          __   ___      ___     __   __        ___  __  ___   |
"  \  / |  |\/| __ | |\ | |  \ |__  |\ |  |  __ /  \ |__)    | |__  /  `  |    |
"   \/  |  |  |    | | \| |__/ |___ | \|  |     \__/ |__) \__/ |___ \__,  |    |
"  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/michaeljsmith/vim-indent-object', { 'commit': '5c5b24c959478929b54a9e831a8e2e651a465965' }

""vim-commentary
Plug 'https://github.com/tpope/vim-commentary', { 'commit': 'f67e3e67ea516755005e6cccb178bc8439c6d402' }

" -----------------------------------------------------------------------------|
"                               __   __  ___  __   ___  ___                    |
"                    |  | |\ | |  \ /  \  |  |__) |__  |__                     |
"                    \__/ | \| |__/ \__/  |  |  \ |___ |___                    |
"                    - - - - - - - - - - - - - - - - - - - -                   |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/mbbill/undotree', { 'commit': '0e11ba7325efbbb3f3bebe06213afa3e7ec75131' }

nnoremap U :UndotreeToggle<CR>

" -----------------------------------------------------------------------------------|
"                         __               __       ___  ___  __                     |
" \  / |  |\/| __ |__| | / _` |__| |    | / _` |__|  |  |__  |  \ \ /  /\  |\ | |__/ |
"  \/  |  |  |    |  | | \__> |  | |___ | \__> |  |  |  |___ |__/  |  /~~\ | \| |  \ |
" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -|
"                                                                                    |
" -----------------------------------------------------------------------------------|
Plug 'https://github.com/machakann/vim-highlightedyank', { 'commit': 'fa3f57b097e9521ce41a66b6c7cf5d9adea70ea3' }

let g:highlightedyank_highlight_duration = 333

" -----------------------------------------------------------------------------|
"                            __        __   __   __             __             |
"           \  / |  |\/| __ /__` |  | |__) |__) /  \ |  | |\ | |  \            |
"            \/  |  |  |    .__/ \__/ |  \ |  \ \__/ \__/ | \| |__/            |
"           - - - - - - - - - - - - - - - - - - - - - - - - - - - -            |
"                                                                              |
" -----------------------------------------------------------------------------|
" Plug 'https://github.com/tpope/vim-surround', { 'commit': '3d188ed2113431cf8dac77be61b842acb64433d9' }

" vim-sandwich
Plug 'https://github.com/machakann/vim-sandwich', { 'commit': '74cf93d58ccc567d8e2310a69860f1b93af19403' }

" Text objects to select a text surrounded by brackets or user-specified characters.
xmap is <Plug>(textobj-sandwich-literal-query-i)
xmap as <Plug>(textobj-sandwich-literal-query-a)
omap is <Plug>(textobj-sandwich-literal-query-i)
omap as <Plug>(textobj-sandwich-literal-query-a)

" Text objects to select the nearest surrounded text automatically.
xmap ib <Plug>(textobj-sandwich-auto-i)
xmap ab <Plug>(textobj-sandwich-auto-a)
omap ib <Plug>(textobj-sandwich-auto-i)
omap ab <Plug>(textobj-sandwich-auto-a)

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
Plug 'https://github.com/tpope/vim-unimpaired', { 'commit': '6d44a6dc2ec34607c41ec78acf81657248580bf1' }

" -----------------------------------------------------------------------------|
"                                 ___                 __                       |
"                \  / |  |\/| __ |__  |  | |\ | |  | /  ` |__|                 |
"                 \/  |  |  |    |___ \__/ | \| \__/ \__, |  |                 |
"                - - - - - - - - - - - - - - - - - - - - - - -                 |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/tpope/vim-eunuch', { 'commit': '67f3dd32b4dcd1c427085f42ff5f29c7adc645c6' }

" -----------------------------------------------------------------------------|
"                __        ___  __        __                                   |
"               /  \ |\ | |__  |  \  /\  |__) |__/  \  / |  |\/|               |
"               \__/ | \| |___ |__/ /~~\ |  \ |  \ . \/  |  |  |               |
"               - - - - - - - - - - - - - - - - - - - - - - - - -              |
"                                                                              |
" -----------------------------------------------------------------------------|
Plug 'https://github.com/catppuccin/nvim', { 'commit': '5e36ca599f4aa41bdd87fbf2c5aae4397ac55074', 'as': 'catppuccin' }

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

nmap - <plug>(SubversiveSubstitute)
nmap -- <plug>(SubversiveSubstituteLine)
nmap _ <plug>(SubversiveSubstituteToEndOfLine)

"is.vim
Plug 'https://github.com/haya14busa/is.vim', { 'commit': 'd393cb346dcdf733fecd7bbfc45b70b8c05e9eb4' }

"targets.vim
"
Plug 'https://github.com/wellle/targets.vim', { 'commit': '642d3a4ce306264b05ea3219920b13ea80931767' }

" TODO: migrate this to neovim
"jpalardy/vim-slime
Plug 'https://github.com/jpalardy/vim-slime', { 'commit': '87988b173b7642e6a5124f9e5559148c4159d076' }

let g:slime_target = !empty($ZELLIJ) ? "zellij" : (has('nvim') ? "neovim" : "vimterminal")

let g:slime_default_config = {"session_id": "current", "relative_pane": "down"}

"disables default bindings
let g:slime_no_mappings = 1

" Shortcut [Slime] Send selection (or motion) to Terminal
xmap <leader>s <Plug>SlimeRegionSend
nmap <leader>s <Plug>SlimeMotionSend
" Shortcut [Slime] Send line to Terminal
nmap <leader>ss <Plug>SlimeLineSend

" Shortcut [Slime] Send Code to Terminal
" xmap <c-c><c-c> <Plug>SlimeRegionSend
" nmap <c-c><c-c> <Plug>SlimeParagraphSend

" vim-zellij-navigator
Plug 'https://gitea.local.hostbutter.net/fresh2dev/zellij.vim.git'

nnoremap <leader>tt :ZellijNewPane<CR>

execute "set <M-f>=\ef"
noremap <M-f> :ZellijNewPane<CR>

execute "set <M-t>=\et"
noremap <M-t> :ZellijNewPaneSplit<CR>

execute "set <M-v>=\ev"
noremap <M-v> :ZellijNewPaneVSplit<CR>

autocmd DirChanged,WinEnter,BufEnter * call system('zellij action rename-tab "' . fnamemodify(getcwd(), ':t') . '"')

"vim-exchange
Plug 'https://github.com/tommcdo/vim-exchange', { 'commit': 'd6c1e9790bcb8df27c483a37167459bbebe0112e' }

" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   `Disable file-type-specific indentation`
"   syntax off            `Disable syntax highlighting`

" Configure vim-sandwich to use vim-surround mappings.
runtime macros/sandwich/keymap/surround.vim

" -----------------------------------------------------------------------------|
"            __   __        __   __   __   __        ___        ___            |
"           /  ` /  \ |    /  \ |__) /__` /  ` |__| |__   |\/| |__             |
"           \__, \__/ |___ \__/ |  \ .__/ \__, |  | |___  |  | |___            |
"           - - - - - - - - - - - - - - - - - - - - - - - - - - - -            |
"                                                                              |
" -----------------------------------------------------------------------------|
silent! colorscheme catppuccin-mocha

set background=dark
