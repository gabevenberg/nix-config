# Nushell Environment Config File
#
# version = "0.91.0"
# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "> " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| ": " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# home managers path, shell aliases, and env vars are not applied to nushell.
use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
path add ($env.HOME | path join ".cargo " "bin")
path add ($env.HOME | path join ".local" "bin")
path add ($env.HOME | path join ".nix-profile" "bin")
path add ('/opt')
$env.PATH = ($env.PATH | uniq)

$env.EDITOR = nvim
$env.VISUAL = nvim
$env.PIPENV_VENV_IN_PROJECT = 1
$env.POETRY_VIRTUALENVS_IN_PROJECT = 1
$env.XDG_DATA_HOME = ( $env.HOME | path join ".local" "share" )
$env.PASSWORD_STORE_DIR = ($env.XDG_DATA_HOME | path join "password-store")

$env.NU_LIB_DIRS = [
    ...
    $nu.default-config-dir
]
