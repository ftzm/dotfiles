# completion.zsh

_tdp_complete() {
    local word completions
    print $1
    completions="$(python /home/matt/dev/tdp/tdp.py pp)"
    reply=( "${(ps:\n:)completions}" )
}

compctl -K _tdp_complete tdp
