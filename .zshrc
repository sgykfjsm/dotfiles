# users generic .zshrc file for zsh(1)

## Environment variable configuration
#
# LANG
# http://curiousabt.blog27.fc2.com/blog-entry-65.html
export LANG=ja_JP.UTF-8

## Online Help
#
unalias run-help > /dev/null 2>&1
autoload run-help
HELPDIR=/usr/local/share/zsh/help

## Backspace key
#
bindkey "^?" backward-delete-char

################################
# Color
################################
DEFAULT=$'%{\e[1;0m%}'
RESET="%{${reset_color}%}"
GREEN="%{${fg[green]}%}"
BLUE="%{${fg[blue]}%}"
BLUE_BOLD="%{${fg_bold[blue]}%}"
RED="%{${fg[red]}%}"
CYAN="%{${fg[cyan]}%}"
WHITE="%{${fg[white]}%}"
YELLOW="%{${fg[yellow]}%}"
YELLOW_BOLD="%{${fg_bold[yellow]}%}"

## Default shell configuration
#
# set prompt
# colors enables us to idenfity color by $fg[red].
autoload colors
colors
case ${UID} in
0) # root
    PROMPT="%B${RED}%/#${RESET}%b "
    PROMPT2="%B${RED}%_#${RESET}%b "
    SPROMPT="%B${RED}%r is correct? [n,y,a,e]:${RESET}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
        PROMPT="${CYAN}$(echo ${HOST%%.*} | tr '[a-z]' '[A-Z]') ${PROMPT}"
    ;;
*)
#
# Prompt
#
setopt prompt_subst
# 改行のない出力をプロンプトで上書きするのを防ぐ
unsetopt promptcr

# Show git branch when you are in git repository
# http://d.hatena.ne.jp/mollifier/20100906/p1
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "[+]"
  zstyle ':vcs_info:git:*' unstagedstr "[!]"
  zstyle ':vcs_info:git:*' formats '(%s)-[%b] %c%u'
  zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a] %c%u'
fi

function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    psvar[2]=$(_git_not_pushed)
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

function _git_not_pushed()
{
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
    head="$(git rev-parse HEAD)"
    for x in $(git rev-parse --remotes)
    do
      if [ "$head" = "$x" ]; then
        return 0
      fi
    done
    echo "[*]"
  fi
  return 0
}

GIT_PROMPT=" ${RESET}%1(v|%F${CYAN}%1v%2v%f|)${vcs_info_git_pushed}${RESET}${WHITE}${RESET}"

function _update_venv_info_msg() {
  if [ -n "${VIRTUAL_ENV}" ]; then
      VIRTUAL_ENV_PROMPT=$(echo ${VIRTUAL_ENV%/*} | awk -F"/" -v OFS="/" '{print $(NF - 1), $NF}')
      psvar[2]="((${VIRTUAL_ENV_PROMPT}))"
  fi
}
add-zsh-hook precmd _update_venv_info_msg

    ;;
esac

# PROMPT='${RESET}${GREEN}${WINDOW:+"[$WINDOW]"}${RESET}[%{$fg_bold[green]%}${USER}@%m${RESET}${WHITE}]${RESET} ${WHITE}${WINDOW:+"[$WINDOW]"}${RESET}${RESET}${WHITE}%D{%FT%T.%Z}${RESET} ${RESET}${WHITE}${YELLOW_BOLD}%~${GIT_PROMPT}
# $ '
# RPROMPT=" "

#
# Vi入力モードでPROMPTの色を変える
# http://memo.officebrook.net/20090226.html
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)
    PROMPT='${RESET}${GREEN}${WINDOW:+"[$WINDOW]"}${RESET}[%{$fg_bold[cyan]%}${USER}@%m${RESET}${WHITE}]${RESET} ${WHITE}${WINDOW:+"[$WINDOW]"}${RESET}${RESET}${WHITE}%D{%FT%T.%Z}${RESET} ${RESET}${WHITE}${YELLOW_BOLD}%~${GIT_PROMPT}
$ '
    ;;
    main|viins)
    PROMPT='${RESET}${GREEN}${WINDOW:+"[$WINDOW]"}${RESET}[%{$fg_bold[green]%}${USER}@%m${RESET}${WHITE}]${RESET} ${WHITE}${WINDOW:+"[$WINDOW]"}${RESET}${RESET}${WHITE}%D{%FT%T.%Z}${RESET} ${RESET}${WHITE}${YELLOW_BOLD}%~${GIT_PROMPT}
$ '
    ;;
  esac
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# 直前のコマンドの終了ステータスが0以外のときは赤くする。
# ${MY_MY_PROMPT_COLOR}はprecmdで変化させている数値。
local MY_COLOR="$ESCX"'%(0?.${MY_PROMPT_COLOR}.31)'m
local NORMAL_COLOR="$ESCX"m

# 指定したコマンド名がなく、ディレクトリ名と一致した場合 cd する
setopt auto_cd

# cd でTabを押すとdir list を表示
setopt auto_pushd

# ディレクトリスタックに同じディレクトリを追加しないようになる
setopt pushd_ignore_dups

# コマンドのスペルチェックをする
setopt correct

# コマンドライン全てのスペルチェックをする
setopt correct_all

# 上書きリダイレクトの禁止
setopt no_clobber

# 補完候補リストを詰めて表示
setopt list_packed

# auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示
setopt list_types

# 補完候補が複数ある時に、一覧表示する
setopt auto_list

# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst

# カッコの対応などを自動的に補完する
setopt auto_param_keys

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash

# {a-c} を a b c に展開する機能を使えるようにする
setopt brace_ccl

# シンボリックリンクは実体を追うようになる
#setopt chase_links

# 補完キー（Tab,  Ctrl+I) を連打するだけで順に補完候補を自動で補完する
setopt auto_menu

# sudoも補完の対象
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

# 色付きで補完する
zstyle ':completion:*' list-colors di=34 fi=0
# 補完候補を選択するときにわかりやすくする
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT
# セパレータを設定する
zstyle ':completion:*' list-separator '-->'
zstyle ':completion:*:manuals' separate-sections true

# マッチ種別を別々に表示
zstyle ':completion:*' group-name ''

# 複数のリダイレクトやパイプなど、必要に応じて tee や cat の機能が使われる
setopt multios

# 最後がディレクトリ名で終わっている場合末尾の / を自動的に取り除かない
setopt noautoremoveslash

# beepを鳴らさないようにする
setopt nolistbeep
setopt nobeep

# Match without pattern
# ex. > rm *~398# remove * without a file "398". For test, use "echo *~398"
setopt extended_glob

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes
#   to end of it)
#
bindkey -v

# history command setting
source ~/.zshrc_history_config

# Ctrl+S/Ctrl+Q によるフロー制御を使わないようにする
#setopt NO_flow_control

# ファイル名の展開でディレクトリにマッチした場合末尾に / を付加する
setopt mark_dirs

# コマンド名に / が含まれているとき PATH 中のサブディレクトリを探す
setopt path_dirs

# 戻り値が 0 以外の場合終了コードを表示する
setopt print_exit_value

# コマンドラインがどのように展開され実行されたかを表示するようになる
# setopt xtrace

# ctrl-w, ctrl-bキーで単語移動
bindkey "^W" forward-word
bindkey "^B" backward-word

# back-wordでの単語境界の設定
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars " _-./;@"
zstyle ':zle:*' word-style unspecified

# URLをコピペしたときに自動でエスケープ
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# 勝手にpushd
setopt autopushd

# エラーメッセージ本文出力に色付け
e_normal=`echo -e "¥033[0;30m"`
e_RED=`echo -e "¥033[1;31m"`
e_BLUE=`echo -e "¥033[1;36m"`

function make() {
    LANG=C command make "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot¥sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}
function cwaf() {
    LANG=C command ./waf "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot¥sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}

## Completion configuration
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit

## zsh editor
#
autoload zed

## Prediction configuration
#
autoload predict-on

## Command Line Stack [Esc]-[q]
bindkey -a 'q' push-line

case "${OSTYPE}" in
# MacOSX
darwin*)
    export PATH=$PATH:/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources:~/bin
    ;;
freebsd*)
    case ${UID} in
    0)
        updateports()
        {
            if [ -f /usr/ports/.portsnap.INDEX ]
            then
                portsnap fetch update
            else
                portsnap fetch extract update
            fi
            (cd /usr/ports/; make index)

            portversion -v -l \<
        }
        alias appsupgrade='pkgdb -F && BATCH=YES NO_CHECKSUM=YES portupgrade -a'
        ;;
    esac
    ;;
esac


## terminal configuration
# http://journal.mycom.co.jp/column/zsh/009/index.html
unset LSCOLORS

case "${TERM}" in
xterm)
    export TERM=xterm-color

    ;;
kterm)
    export TERM=kterm-color
    # set BackSpace control character

    stty erase
    ;;

cons25)
    unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad

    # export LS_COLORS='di=01;32:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
    # zstyle ':completion:*' list-colors \
    #     'di=;36;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    ;;

kterm*|xterm*)
    export CLICOLOR=1
    export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    ;;

dumb)
    echo "Welcome Emacs Shell"
    ;;
esac

# コマンドにも色を付ける
source ~/.zsh_tools/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh


export EDITOR=vim
export PATH=$PATH:/sbin:/usr/local/bin

########################
# play framework
########################
export PATH=$PATH:~/local/script/scala/play
export PATH=$PATH:~/.cabal/bin:~/bin/datapipeline-cli
export MANPATH=$MANPATH:/usr/local/share/man

########################
# rbenv
########################
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then
    eval "$(rbenv init -)"
fi

expand-to-home-or-insert () {
        if [ "$LBUFFER" = "" -o "$LBUFFER[-1]" = " " ]; then
                LBUFFER+="~/"
        else
                zle self-insert
        fi
}

# zsh の exntended_glob と HEAD^^^ を共存させる。
# http://subtech.g.hatena.ne.jp/cho45/20080617/1213629154
typeset -A abbreviations
abbreviations=(
  "L"    "| $PAGER"
  "G"    "| grep"

  "HEAD^"     "HEAD\\^"
  "HEAD^^"    "HEAD\\^\\^"
  "HEAD^^^"   "HEAD\\^\\^\\^"
  "HEAD^^^^"  "HEAD\\^\\^\\^\\^\\^"
  "HEAD^^^^^" "HEAD\\^\\^\\^\\^\\^"
)

magic-abbrev-expand () {
  local MATCH
  LBUFFER=${LBUFFER%%(#m)[-_a-zA-Z0-9^]#}
  LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
}

magic-abbrev-expand-and-insert () {
  magic-abbrev-expand
  zle self-insert
}

magic-abbrev-expand-and-accept () {
  magic-abbrev-expand
  zle accept-line
}

no-magic-abbrev-expand () {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N magic-abbrev-expand-and-insert
zle -N magic-abbrev-expand-and-accept
zle -N no-magic-abbrev-expand
bindkey "\r"  magic-abbrev-expand-and-accept # M-x RET はできなくなる
bindkey "^J"  accept-line # no magic
bindkey " "   magic-abbrev-expand-and-insert
bindkey "."   magic-abbrev-expand-and-insert
bindkey "^x " no-magic-abbrev-expand

function rmf(){
   for file in $*
   do
      __rm_single_file $file
   done
}

alias rm=__rm_single_file

function __rm_single_file(){
       [ -d ~/.Trash/ ] || command /bin/mkdir ~/.Trash

       [ $# -eq 1 ] || {
               echo "__rm_single_file: 1 argument required but $# passed."
               exit
        }

        [ -e $1 ] || {
               echo "No such file or directory: $file"
               exit
        }

        BASENAME=`basename $1`
        NAME=$BASENAME
        COUNT=0
        while [ -e ~/.Trash/$NAME ]
        do
               COUNT=$(($COUNT+1))
               NAME="$BASENAME.$COUNT"
        done

        command /bin/mv $1 ~/.Trash/$NAME
}

## alias設定
#
[ -f ~/dotfiles/.zshrc.alias ] && source ~/dotfiles/.zshrc.alias

case "${OSTYPE}" in
# Mac(Unix)
darwin*)
    [ -f ~/dotfiles/.zshrc.osx ] && source ~/dotfiles/.zshrc.osx
    ;;
# Linux
linux*)
    [ -f ~/dotfiles/.zshrc.linux ] && source ~/dotfiles/.zshrc.linux
    ;;
esac

autoload -Uz zmv

# less
# required: GNU Source-highlight
# Mac: brew install, Ubuntu: apt-get install, Fedora: yum install source-highlight
export LESS="-MQRSFXWin -P'?f%f .?ltLine %lt:?pt%pt\%:?btByte %bt:-...'"
export LESSCHARSET=utf-8
which src-hilite-lesspipe.sh > /dev/null || \
    export LESSOPEN='| /usr/local/bin/src-hilite-lesspipe.sh %s'

