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
