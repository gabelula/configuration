
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

alias psql=/Applications/Postgres.app/Contents/Versions/9.4/bin/psql
export PATH="/usr/local/bin:$HOME/.gocode/bin:/usr/local/opt/go/libexec/bin:$PATH"
export CC="/usr/local/bin/gcc-4.9"
export GOPATH=$HOME/.gocode

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
