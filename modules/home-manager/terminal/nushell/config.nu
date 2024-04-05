# Nushell Config File
#
# version = "0.91.0"

$env.config = {
    history: {
        file_format: "sqlite" # "sqlite" or "plaintext"
    }
    completions: {
        algorithm: "fuzzy"    # prefix or fuzzy
    }
    filesize: {
        metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
        format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
    }
    cursor_shape: {
        emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert: line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal: blink_block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
    }

    edit_mode: vi # emacs, vi
    shell_integration: true # enables terminal shell integration. Off by default, as some terminals have issues with this.
    render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
    # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this. 
    # Zellij does not modify the term var, so we have to special-case it.
    use_kitty_protocol: ($env.TERM == 'xterm-kitty' and $env.ZELLIJ? == null)
    highlight_resolved_externals: true # true enables highlighting of external commands in the repl resolved by which.
}

alias please = sudo (history | last | get command)
alias la = ls -a
alias ll = ls -l
alias lla = ls -la
alias pyactivate = overlay use ./.venv/bin/activate
alias tmux = tmux -u
# converts all .doc and .docx files in the local directory to pdfs using libreoffice
alias doc2pdf = loffice --convert-to pdf --headless *.docx
#common options for sshfs
alias sshmnt = sshfs -o idmap=user,compression=no,reconnect,follow_symlinks,dir_cache=yes,ServerAliveInterval=15


#look up something on cheat.sh
def cheat [query: string] {
    curl $"cheat.sh/($query)"
}
#look up the weather
def wttr [
    location?: string
    --format (-f): string
] {
    http get $"https://wttr.in/($location)?format=($format)"
}

# parses git log into a nushell table.
def --wrapped git-log [...rest] {
    git log --pretty=%h»¦«%H»¦«%s»¦«%aN»¦«%aE»¦«%aD ...$rest | lines | split column "»¦«" commit full-commit subject name email date | upsert date {|d| $d.date | into datetime}
}

# lists all the authors and how many commits they made in a histogram
def git-authors [] {
    git-log --all | select name date | histogram name
}

# use completions *
