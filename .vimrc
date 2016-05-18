"""""""""""""""""""""""""
"--- BEFORE STARTING ---"
"""""""""""""""""""""""""

"UPGRADE VIM
"brew install macvim --with-override-system-vim
"
"INSTALL SELECTA
"brew install selecta
"
"INSTALL YCM
"cd ~/.vim/bundle/YouCompleteMe
"./install.py --clang-completer

""""""""""""""""
"--- Plugins---"
""""""""""""""""
" ----- List of Plugins -----{{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" COLORS
Plugin 'altercation/vim-colors-solarized'   " adds solarized colorscheme
Plugin 'morhetz/gruvbox'                    " adds gruvbox theme

" PLUGINS
Plugin 'tmhedberg/matchit'                  " extends matching on %
Plugin 'ecomba/vim-ruby-refactoring'        " refactoring ruby
Plugin 'geoffharcourt/vim-ruby-private-method-extract'
Plugin 'kana/vim-textobj-user'              " adds custom textobjs
Plugin 'nelstrom/vim-textobj-rubyblock'     " adds rubyblock text obj
Plugin 'tpope/vim-fugitive'                 " gives integrated git commands
Plugin 'tpope/vim-surround'                 " surround a selection with char
Plugin 'tpope/vim-sensible'                 " basic vim defaults which are nice
Plugin 'tpope/vim-endwise'                  " closes several blocks automatically
Plugin 'tpope/vim-abolish'                  " support for case switching
Plugin 'tpope/vim-repeat'                   " support for . repeating last command
Plugin 'airblade/vim-gitgutter'             " adds git stati to the gutter
Plugin 'ck3g/vim-change-hash-syntax'        " allows hashrocket -> json convert
Plugin 'jgdavey/vim-blockle'                " switch block types for ruby
Plugin 'tomtom/tcomment_vim'                " allows commenting of chunks
Plugin 'Raimondi/delimitMate'               " closes delimeters automatically
Plugin 'itchyny/lightline.vim'              " adds clean light powerline
Plugin 'Valloric/YouCompleteMe'             " autocomplete contextually
Plugin 'scrooloose/syntastic'               " syntax highlighting
Plugin 'scrooloose/nerdtree'                " adds file browser
Plugin 'Yggdroot/indentLine'                " adds indent line characters
Plugin 'SirVer/ultisnips'                   " adds snippets for autocomplete

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
"}}}

"""""""""""""""""""""""
"--- PLUGIN CONFIG---"
"""""""""""""""""""""""

" ----- Key Mappings -----{{{
"-- Leader Declaration
let mapleader = "\<Space>"

"-- Hotkey for changing hash syntax
noremap <leader>hh :ChangeHashSyntax <cr>

"-- NERD Tree
noremap <C-n> :NERDTreeToggle<CR>

"-- Toggle Syntastic
nnoremap <leader>st :SyntasticToggleMode <cr>

"-- Open snippets file
nnoremap <leader>use :UltiSnipsEdit<CR>

" }}}

" ----- Configuration -----{{{
" ----------------
" NERD Tree config
" ----------------
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" ----------------
" Syntastic Config
" ----------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
highlight SyntasticErrorSign guifg=white guibg=red
highlight SyntasticError guibg=#2f0000

" ------------------
" Indent line config
" ------------------
let g:indentLine_enabled = 1
let g:indentLine_color_term = 239
let g:indentLine_char = "|"

" ---------------
" vim-tags config
" ---------------
let g:vim_tags_auto_generate = 1

" ------------------
" delimitMate config
" ------------------
let delimitMate_expand_cr = 1

" ----------------
" ultisnips config
" ----------------
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.

let g:UltiSnipsExpandTrigger="<C-j>"
let g:UltiSnipsJumpForwardTrigger="<C-j>"
let g:UltiSnipsJumpBackwardTrigger="<C-k>""

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" }}}

""""""""""""""""""""
"--- Misc Config ---"
""""""""""""""""""""
" ------ Basic Config -----{{{
"-- Change split locations
set splitbelow
set splitright

"-- Use indents of 2 spaces, and have them copied down lines
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

"-- Color Scheme
syntax enable
set background=dark

let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

"-- Set invisibles to show
set listchars=tab:--,trail:-
set list

"-- Search config
set incsearch

"-- Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

"-- Line Numbers
set number
" set relativenumber

"-- Highlight over 80 chars
highlight ColorColumn ctermbg=65
call matchadd('ColorColumn', '\%81v', 100)

"-- Set color density for vim
set t_Co=256
" }}}

"""""""""""""""""""
"--- FUNCTIONS ---"
"""""""""""""""""""

"----- Fuzzy Find Files -----{{{

" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.

" IMPORTANT: to make this work, you'll have to brew install selecta

function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    let selection = system(a:choice_command . " | selecta " .  a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  redraw!
  exec a:vim_command . " " . selection
endfunction

" Find all files in all non-dot directories
" starting in the working directory.
" Fuzzy select one of those. Open the selected
let find_cmd = "find . -path ./.bundle -prune -o -path ./public -prune -o -path ./node_modules -prune -o -path ./tmp -prune -o -path ./log -prune -o -path ./.git -prune -o -type f -print"

nnoremap <leader>f :call SelectaCommand(find_cmd, "", ":e")<cr>
nnoremap <leader>hf :sp<cr>:call SelectaCommand(find_cmd, "", ":e")<cr>
nnoremap <leader>vf :vsp<cr>:call SelectaCommand(find_cmd, "", ":e")<cr>
" }}}

"""""""""""""""""""""""
"--- CUSTOM MACROS ---"
"""""""""""""""""""""""

"----- Ease of use -----{{{

"--- Copy to system register
noremap <leader>c "*y

"--- Paste from system register
noremap <leader>v "*p

"--- Quickly yank all lines in the file.
nnoremap <leader>yy :%y+<CR>

"--- Make jk save the file
inoremap jk <esc>:w<CR>

"--- Source vimrc
nnoremap <leader>sv :so $MYVIMRC<CR>

"--- Edit vimrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>

"-- Save quickly!
noremap <leader><CR> :w<CR>

"-- Easy Window Management
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l
" }}}

"----- Operators -----{{{

"-- Inside next parens
onoremap in( :<c-u>normal! f(vi(<cr>

"-- Inside last parens
onoremap il( :<c-u>normal! F)vi(<cr>

"-- Around next parens
onoremap an( :<c-u>normal! f(va(<cr>

"-- Around last parens
onoremap al( :<c-u>normal! F)va(<cr>

"-- Inside next curly brackets
onoremap in{ :<c-u>normal! f{vi{<cr>

"-- Inside last curly brackets
onoremap il{ :<c-u>normal! F}vi{<cr>

"-- Around next curly brackets
onoremap an{ :<c-u>normal! f{va{<cr>

"-- Around last curly brackets
onoremap al{ :<c-u>normal! F}va{<cr>
" }}}

"----- Movement -----{{{

"--- Stronger H (move to SOL)
nnoremap H ^

"--- Stronger L (move to EOL)
nnoremap L $

"--- Stronger K (page up)
nnoremap K <c-u>

"--- Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>
" }}}

"----- Formatting -----{{{

"--- Convert string under cursor into a symbols
"------This should probably be using regex, oh well!
nmap <leader>ss cs"'wds'i:

"--- Format hash rockets to be surrounded by spaces
nmap <leader>hs ^f=i f>a 

"--- Surround with double quote
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>

"--- Surround with single quote
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
" }}}

"----- Autocommands -----{{{

augroup filetype_html
  autocmd!
  "--- Auto format files on enter and save
  autocmd BufWritePre,BufRead *.html :normal gg=G
augroup END

augroup filetype_ruby
  autocmd!
  " "--- Auto format files on enter and save
  " autocmd BufWritePre,BufRead *.rb :normal gg=G
  "
  " "--- Auto remove trailing whitespace
  " autocmd BufWritePre *.rb :%s/\s\+$//e
augroup END

augroup filetype_markdown
  autocmd!
  "--- Apply mapping for editing inside header
  autocmd FileType markdown onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>

  "--- Apply mapping for editing around header
  autocmd FileType markdown onoremap ah :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rg_k0"<cr>
augroup END

augroup filetype_vim
  autocmd!
  "--- Enable fold method for vim files
  autocmd FileType vim setlocal foldmethod=marker
  autocmd BufRead vim :normal zM
augroup END
" }}}
