## sheldon
eval "$(sheldon source)"

### 言語設定 https://qiita.com/maejimayuto/items/01216e6255c156fa7bf4
export LANG=ja_JP.UTF-8

# ezaのテーマせってのため
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"

# libpg(psql)
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
# export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"


## auto complate https://qiita.com/maejimayuto/items/01216e6255c156fa7bf4
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
autoload -Uz compinit
compinit -u
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'    # 補完候補で、大文字・小文字を区別しないで補完出来るようにするが、大文字を入力した場合は区別する
zstyle ':completion:*' ignore-parents parent pwd ..    # ../ の後は今いるディレクトリを補間しない
zstyle ':completion:*:default' menu select=1           # 補間候補一覧上で移動できるように
zstyle ':completion:*:cd:*' ignore-parents parent pwd  # 補間候補にカレントディレクトリは含めない

## history https://qiita.com/maejimayuto/items/01216e6255c156fa7bf4
HISTSIZE=1000000
SAVEHIST=1000000
setopt share_history           # 履歴を他のシェルとリアルタイム共有する
setopt hist_ignore_all_dups    # 同じコマンドをhistoryに残さない
setopt hist_ignore_space       # historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks      # historyに保存するときに余分なスペースを削除する
setopt hist_save_no_dups       # 重複するコマンドが保存されるとき、古い方を削除する
setopt inc_append_history      # 実行時に履歴をファイルにに追加していく

# emacs風キーバインド
bindkey -e

# 入力したコマンドが存在せず、かつディレクトリ名と一致するなら、ディレクトリに cd する
# 例： /usr/bin と入力すると /usr/bin ディレクトリに移動
setopt auto_cd

# ghqとfzfの組み合わせ
fzf-src () {
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --reverse --height=50%"
    local root="$(ghq root)"
    local repo="$(ghq list | fzf --prompt="Go to > " --preview="eza --tree --level=2 ${root}/{1}")"
    local dir="${root}/${repo}"
    [ -n "${dir}" ] && z "${dir}"
    zle accept-line
    zle reset-prompt
}
zle -N fzf-src


# コマンド履歴
function select-history() {
    BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
    CURSOR=$#BUFFER
}
zle -N select-history


function create_session_with_ghq() {
    # fzfで選んだghqのリポジトリのpathを取得
    moveto=$(ghq root)/$(ghq list | fzf --prompt="Create new session from > " --preview="eza --tree --level=2 ${root}/{1}" )

    if [[ ! -z ${TMUX} ]]
    then
        # リポジトリ名を取得
        repo_name=`basename $moveto`

        # repositoryが選択されなかった時は実行しない
        if [ $repo_name != `basename $(ghq root)` ]
        then
            # セッション作成（エラーは/dev/nullへ）
            tmux new-session -d -c $moveto -s $repo_name  2> /dev/null

            # セッション切り替え（エラーは/dev/nullへ）
            tmux switch-client -t $repo_name 2> /dev/null
        fi
    fi
}
zle -N create_session_with_ghq


function fzf-tmux-switch-client() {
    local session_name="$(tmux ls -F '#{session_name}' | fzf)"
    tmux switch-client -t "${session_name}"
}
zle -N fzf-tmux-switch-client

bindkey '^L^G' fzf-src
bindkey '^L^L' create_session_with_ghq
bindkey '^L^M' fzf-tmux-switch-client
bindkey '^r' select-history

# 略語展開 エイリアスの代わり
alias rm='trash'
abbr -S --quieter ll='eza -alh --icons'
abbr -S --quieter llt='eza --tree --sort=type --reverse --git-ignore'
abbr -S --quieter dcu='docker-compose up -d'
abbr -S --quieter dcs='docker-compose stop'
abbr -S --quieter dcp='docker-compose ps'
abbr -S --quieter tl='tmux ls'
abbr -S --quieter tskt='tmux switch-client -t'
abbr -S --quieter tka='tmux kill-session -a'
abbr -S --quieter tkt='tmux kill-session -t'
abbr -S --quieter cld='colima status -e'
abbr -S --quieter cla='colima start'
abbr -S --quieter clo='colima stop'

## emacs
# eat shell integration
[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && source "$EAT_SHELL_INTEGRATION_DIR/zsh"


# zoxide. For completions to work, the above line must be added after compinit is called.
eval "$(zoxide init zsh)"
