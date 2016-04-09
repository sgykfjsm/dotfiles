set nocompatible
filetype off

"--------------------------------
" golang
"--------------------------------
filetype plugin indent off
exe "set rtp+=" . globpath($GOPATH, "src/github.com/golang/lint/misc/vim")
set rtp+=$GOPATH/src/github.com/nsf/gocode/vim
set completeopt=menu,preview
filetype plugin indent on
" # For Omni Completion
" $ mkdir -p ${GOPATH}/bin
" $ go get github.com/nsf/gocode
" $ ${GOPATH}/src/github.com/nsf/gocode/vim/update.sh
"

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

Plugin 'VundleVim/Vundle.vim'

" basic config
Plugin 'tpope/vim-sensible.git'

" completition
Plugin 'Shougo/neocomplete.vim'

" neocomplcacheのsinpet補完
Plugin 'https://github.com/Shougo/neosnippet'
Plugin 'Shougo/neosnippet-snippets.git'

" JavaScript
Plugin 'JavaScript-syntax'

" coffee script
Plugin 'kchmck/vim-coffee-script'

" minibufe:pl.vim : タブエディタ風にバッファ管理ウィンドウを表示
Plugin 'minibufexpl.vim'

Plugin 'thinca/vim-quickrun'

Plugin 'banyan/recognize_charcode.vim'

" NerdTree
Plugin 'scrooloose/nerdtree'

" color scheme
Plugin 'w0ng/vim-hybrid'

" indent guide
Plugin 'nathanaelkane/vim-indent-guides'

" html5
Plugin 'othree/html5.vim'

" vimでgit
Plugin 'git://github.com/tpope/vim-fugitive.git'

" A Vim plugin which shows a git diff in the gutter
Plugin 'airblade/vim-gitgutter'

" HTML/CSS
Plugin 'mattn/emmet-vim.git'

" golang
Plugin 'fatih/vim-go'
Plugin 'Blackrush/vim-gocode'
Plugin 'majutsushi/tagbar'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/unite-outline'
Plugin 'dgryski/vim-godef'
Plugin 'vim-jp/vim-go-extra'

" snippets (fork from honza/vim-snippets.git)
Plugin 'sgykfjsm/vim-snippets'

" syntax
Plugin 'scrooloose/syntastic'

" A better JSON for Vim
Plugin 'elzr/vim-json'

" Add additional support for Ansible in VIM
Plugin 'chase/vim-ansible-yaml'
Plugin 'avakhov/vim-yaml'

" statusline
Plugin 'itchyny/lightline.vim'

Plugin 'tmux-plugins/vim-tmux'

Plugin 'Shougo/vimproc'
Plugin 'Shougo/vimshell'

" python
Plugin 'nvie/vim-flake8'
Plugin 'davidhalter/jedi-vim'
" after intall jedi-vim...
" cd ~/.vim/bundle/jedi-vim
" git submodule update --init
Plugin 'kevinw/pyflakes-vim'
" after intall pyflakes-vim...
" cd cd ~/.vim/bundle/pyflakes-vim/
" git submodule update --init

"
Plugin 'tpope/vim-surround.git'

Plugin 'nginx.vim'

filetype plugin indent on

"-------------------------------------------------------------------------------
" 基本設定 Basics
"-------------------------------------------------------------------------------
let mapleader = ","              " キーマップリーダー
set scrolloff=5                  " スクロール時の余白確保
set textwidth=0                  " 一行に長い文章を書いていても自動折り返しをしない
set nobackup                     " バックアップ取らない
set autoread                     " 他で書き換えられたら自動で読み直す
set noswapfile                   " スワップファイル作らない
set hidden                       " 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq           " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                     " ビープをならさない
set browsedir=buffer             " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set showmode                     " 現在のモードを表示
set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
set modelines=0                  " モードラインは無効
set history=10000

" OSのクリップボードを使用する
set clipboard+=unnamed
" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

" Ev/Rvでvimrcの編集と反映
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC

set helpfile=$VIMRUNTIME/doc/help.txt

" ファイルタイプ判定をon
filetype plugin on

"----------------------------
" カラー関連 Colors
"----------------------------
" ターミナルタイプによるカラー設定
if &term =~ "xterm-256color" || "screen-256color"
  " 256色
  set t_Co=256
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-color"
  set t_Co=8
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

let g:hybrid_use_Xresources = 1
set background=dark
colorscheme hybrid

" ハイライト on
syntax enable
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c

" http://qiita.com/koara-local/items/57b5f2847b3506a6485b
hi clear CursorLine

augroup vimrc-auto-cursorline
  autocmd!
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  setlocal cursorline
  hi clear CursorLine

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event)
    if a:event ==# 'WinEnter'
      setlocal cursorline
      hi CursorLine term=underline cterm=underline guibg=Grey90 " ADD
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
      hi clear CursorLine " ADD
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          " setlocal nocursorline
          hi clear CursorLine " ADD
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      " setlocal cursorline
      hi CursorLine term=underline cterm=underline guibg=Grey90 " ADD
      let s:cursorline_lock = 1
    endif
  endfunction
augroup END
augroup cch
autocmd! cch
autocmd WinLeave * set nocursorline
autocmd WinEnter, BufRead * set cursorline
augroup END

" インデントガイドの幅
let g:indent_guides_auto_colors = 1
hi IndentGuidesOdd  ctermbg=darkgray
hi IndentGuidesEven ctermbg=darkgrey
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1

"----------------------------
" インデント Indent
"----------------------------
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set cindent      " Cプログラムファイルの自動インデントを始める

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=4 shiftwidth=4 softtabstop=0

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on

  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType eruby      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=4 sts=4 ts=4 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType haskell    setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType twig       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType bats       setlocal sw=4 sts=4 ts=4 et
endif

au BufNewFile,BufRead *.template set filetype=json
au BufNewFile,BufRead .tmux.conf set filetype=tmux | compiler tmux

"----------------------------
" 表示 Apperance
"----------------------------
set showmatch         " 括弧の対応をハイライト
set number            " 行番号表示
set list              " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set display=uhex      " 印字不可能文字を16進数で表示

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" コマンド実行中は再描画しない
set lazyredraw

"----------------------------
" 補完・履歴 Complete
"----------------------------
" Ex-modeでの<C-p><C-n>をzshのヒストリ補完っぽくする
cnoremap <C-p> <Up>
cnoremap <Up>  <C-p>
cnoremap <C-n> <Down>
cnoremap <Down>  <C-n>

"------------------------------------
" 補完にneocomplを使う
" neocomple.vim
"------------------------------------
" Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocompl.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 1
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" 補完が自動で開始される文字数
let g:neocomplete#auto_completion_start_length = 1
"ポップアップメニューで表示される候補の数。初期値は100
let g:neocomplete#max_list = 20

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'perl' : $HOME.'/.vim/dict/perl.dict',
    \ 'php' : $HOME.'/.vim/dict/php.dict',
    \ 'vm' : $HOME.'/.vim/dict/vim.dict'
    \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
" let g:neocomplete#enable_auto_select = 1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" pythonの補完はdavidhalter/jedi-vimでやる
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType ruby       setlocal omnifunc=rubycomplete#Complete
" autocmd FileType go       setlocal omnifunc=gocomplete#Complete

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" let g:neocomplete#sources#omni#input_patterns.go = '\h\w*\.\?'

" ユーザー定義スニペット保存ディレクトリ
let s:vim_snippets = "~/.vim/bundle/vim-snippets/snippets"
let g:neosnippet#snippets_directory = s:vim_snippets
" let g:neosnippet#snippets_directory = s:my_snippets

" Plugin key-mappings.
" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
imap <C-s>     <Plug>(neosnippet_expand_or_jump)
smap <C-s>     <Plug>(neosnippet_expand_or_jump)
xmap <C-s>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"-------------------------------------------------------------------------------
" 検索設定 Search
"-------------------------------------------------------------------------------
set wrapscan   " 最後まで検索したら先頭へ戻る
set ignorecase " 大文字小文字無視
set smartcase  " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索文字をハイライト
"Escの2回押しでハイライト消去
nmap <ESC><ESC> :nohlsearch<CR><ESC>

"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap /r "xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'

" Ctrl-iでヘルプ
nnoremap <C-i>  :<C-u>help<Space>
" カーソル下のキーワードをヘルプでひく
nnoremap <C-i><C-i> :<C-u>help<Space><C-r><C-w><Enter>

" :Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>
" カーソル下の単語をGrepBufferする
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>

" :Gr <args>でカレントディレクトリ以下を再帰的にgrepする
command! -nargs=1 Gr :Rgrep <args> *<Enter><CR>
" カーソル下の単語をgrepする
nnoremap <silent> <C-g><C-r> :<C-u>Rgrep<Space><C-r><C-w> *<Enter><CR>

let Grep_Skip_Dirs = '.svn .git'
let Grep_Skip_Files = '*.bak *~'

"----------------------------
" 移動設定 move
"----------------------------
" カーソルを表示行で移動する。論理行移動は<c-n>,<c-p>
nnoremap h <left>
nnoremap j gj
nnoremap k gk
nnoremap l <right>
nnoremap <down> gj
nnoremap <up>   gk

" insert mode での移動
inoremap  <c-e> <end>
inoremap  <c-a> <home>
" インサートモードでもhjklで移動（ctrl押すけどね）
inoremap <c-j> <down>
inoremap <c-k> <up>
inoremap <c-h> <left>
inoremap <c-l> <right>

"<space>j, <space>kで画面送り
noremap <space>j <c-f>
noremap <space>k <c-b>

" spaceで次のbufferへ。back-spaceで前のbufferへ
nmap <space><space> <esc>:bn<cr>
nmap <bs><bs> <esc>:bp<cr>

" f2で前のバッファ
map <f2> <esc>:bp<cr>
" f3で次のバッファ
map <f3> <esc>:bn<cr>
" f4でバッファを削除する
map <f4> <esc>:bnext \| bdelete #<cr>
command! Bw :bnext \| bdelete #

"フレームサイズを怠惰に変更する
map <kplus> <c-w>+
map <kminus> <c-w>-

" 前回終了したカーソル行に移動
autocmd bufreadpost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 最後に編集された位置に移動
nnoremap gb '[
nnoremap gp ']

" 対応する括弧に移動
nnoremap ( %
nnoremap ) %

" 最後に変更されたテキストを選択する
nnoremap gc  `[v`]
vnoremap gc <c-u>normal gc<enter>
onoremap gc <c-u>normal gc<enter>

" カーソル位置の単語をyankする
nnoremap vy vawy

" 矩形選択で自由に移動する
set virtualedit+=block

" ctrl-hjklでウィンドウ移動
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" insert mode でjjでesc
inoremap jj <Esc>

"-------------------------------------------------------------------------------
" 編集関連 Edit
"-------------------------------------------------------------------------------
" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" yeでそのカーソル位置にある単語をレジスタに追加
nmap ye :let @"=expand("<cword>")<CR>
" Visualモードでのpで選択範囲をレジスタの内容に置き換える
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Tabキーを空白に変換
set expandtab

" コンマの後に自動的にスペースを挿入
inoremap , ,<Space>
" XMLの閉タグを自動挿入
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END

" Insert mode中で単語単位/行単位の削除をアンドゥ可能にする
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>

" :Ptでインデントモード切替
command! Pt :set paste!
command! NPt :set nopaste!

" インサートモード中に<C-o>でyankした内容をputする
inoremap <C-o> <ESC>:<C-U>YRPaste 'p'<CR>i

" y9で行末までヤンク
nmap y9 y$
" y0で行頭までヤンク
nmap y0 y^

" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
autocmd BufWritePre * :redraw!

" 日時の自動入力
inoremap <expr> ,df strftime('%Y-%m-%d %H:%M:%S')
inoremap <expr> ,dd strftime('%Y-%m-%d')
inoremap <expr> ,dt strftime('%H:%M:%S')

" quickfixウィンドウではq/ESCで閉じる
autocmd FileType qf nnoremap <buffer> q :ccl<CR>
autocmd FileType qf nnoremap <buffer> <ESC> :ccl<CR>

" cwでquickfixウィンドウの表示をtoggleするようにした
function! s:toggle_qf_window()
  for bufnr in range(1,  winnr('$'))
    if getwinvar(bufnr,  '&buftype') ==# 'quickfix'
      execute 'ccl'
      return
    endif
  endfor
  execute 'botright cw'
endfunction
nnoremap <silent> cw :call <SID>toggle_qf_window()<CR>

" 無限undoと編集位置の自動復帰
" 事前にmkdir -p ~/.vim/undoしておくこと
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\""

"-------------------------------------------------------------------------------
" エンコーディング関連 Encoding
"-------------------------------------------------------------------------------
set ffs=unix,dos,mac  " 改行文字
set encoding=utf-8    " デフォルトエンコーディング
setglobal fileencoding=utf-8

" cvsの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp
" 以下のファイルの時は文字コードをutf-8に設定
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType java :set fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

" 編集中のファイルを別名で保存する
" :Rename <保存したいファイル名>
command! -nargs=1 -complete=file Rename f <args> | call delete(expand('#')) | w
"-------------------------------------------------------------------------------
" その他 Misc
"-------------------------------------------------------------------------------

" *.goを保存する際に自動的にフォーマットする。
auto BufWritePre *.go Fmt

" syntax for bats
au BufRead,BufNewFile *.bats set filetype=sh
syn match batsTest              "\v\@test"
syn keyword batsKeyword         run containedin=shExpr contained

hi def link batsTest            Identifier
hi def link batsKeyword         Keyword


let g:ansible_options = {'ignore_blank_lines': 0}

" Better :sign interface symbols
let g:syntastic_error_symbol = 'x'
let g:syntastic_warning_symbol = '!'

"---------------------------
" http://qiita.com/tomoemon/items/cc29b414a63e08cd4f89
command! JsonFormat
  \ :execute '%!python -m json.tool'
  \ | :execute '%!python -c "import re,sys;chr=__builtins__.__dict__.get(\"unichr\", chr);sys.stdout.write(re.sub(r\"\\u[0-9a-f]{4}\", lambda x: chr(int(\"0x\" + x.group(0)[2:], 16)), sys.stdin.read()))"'
  \ | :%s/ \+$//ge
  \ | :1

" --------------------------
" URLリンクをブラウザで開く
" http://d.hatena.ne.jp/shunsuk/20110508/1304865150
" --------------------------
function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
  echo s:uri
  if s:uri != ""
    exec "!open \"" . s:uri . "\""
  else
    echo "No URI found in line."
  endif
endfunction

nnoremap <Space>w :call HandleURI()<CR>
"----------------------------
" プラグインごとの設定 Plugins
"
"----------------------------
" lightline
"----------------------------
source ~/dotfiles/.vimrc.lightline

"----------------------------
" MiniBufExplorer
"----------------------------
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize = 10

":MtでMiniBufExplorerの表示トグル
command! Mt :TMiniBufExplorer

"----------------------------
" quickrun.vim
"----------------------------
let g:quickrun_config = {'*': {'hook/time/enable': '1', 'split': ''}}
set splitbelow

"----------------------------
" vim-coffee-script
"----------------------------
" 自動プレビュー
" au BufWritePost *.coffee :CoffeeCompile watch vert
" 自動コンパイル
au BufWritePost *.coffee silent CoffeeMake! -b | cwindow | redraw!

"----------------------------
" NERDTree
"----------------------------
source ~/dotfiles/.vimrc.NREDTree

"---------------------------
" syntastic
"" pyflakes-vim
"" http://qiita.com/tekkoc/items/923d7a7cf124e63adab5
"---------------------------
let g:syntastic_json_checkers=['jsonlint']
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
let g:syntastic_mode_map = {
            \ 'mode': 'active',
            \ 'active_filetypes': ['php', 'coffeescript', 'sh', 'vim', 'go', 'md', 'markdown'],
            \ 'passive_filetypes': ['html', 'haskell', 'python'],
            \ }

"---------------------------
" vim-json
"---------------------------
let g:vim_json_syntax_conceal = 0

"---------------------------
" 'modsound/mac_notify-vim'
"---------------------------
function! s:weather_report()
  let l:weather = system("curl --silent http://weather.livedoor.com/forecast/rss/area/130010.xml
  \ | grep '<description>'
  \ | sed -e 's/<description>//g'
  \ | sed -e 's|</description>||g' | head -n 3 | tail -n 1")
  exec "MacNotifyExpand l:weather"
endfunction
command! WeatherReport call s:weather_report()


"---------------------------
" http://qiita.com/shiena/items/870ac0f1db8e9a8672a7
"---------------------------
" for golang {{{
set path+=$GOPATH/src/**
let g:gofmt_command = 'goimports'
au BufWritePre *.go Fmt
au BufNewFile,BufRead *.go set sw=4 noexpandtab ts=4 completeopt=menu,preview
au FileType go compiler go
" }}}

"-------------------------------------------------------------------------------
" jedi-vim
" http://qiita.com/tekkoc/items/923d7a7cf124e63adab5
"-------------------------------------------------------------------------------
" rename用のマッピングを無効にしたため、代わりにコマンドを定義
command! -nargs=0 JediRename :call jedi#rename()

" pythonのrename用のマッピングがquickrunとかぶるため回避させる
let g:jedi#rename_command = ""
let g:jedi#documentation_command = "K"

"-------------------------------------------------------------------------------
" vim-go
"-------------------------------------------------------------------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"-------------------------------------------------------------------------------
" vim-gitgutter
"-------------------------------------------------------------------------------
" let g:gitgutter_realtime = 0
" let g:gitgutter_eager = 0
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '*'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = 'w'

let g:syntastic_error_symbol = 'x'
let g:syntastic_warning_symbol = '!'
let g:syntastic_style_error_symbol = 'S'
let g:syntastic_style_warning_symbol = 'S'
highlight SyntasticErrorLine guibg=#000000

"-------------------------------------------------------------------------------
" nginx
"-------------------------------------------------------------------------------
au BufRead,BufNewFile */nginx/* if &ft == '' | setfiletype nginx | endif

