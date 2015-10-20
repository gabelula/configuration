export PATH=$HOME/bin:/usr/local/bin:$PATH

# We're using 64 bits, right?
# export ARCHFLAGS="-arch x86_64"

# Editor
export EDITOR=vim
export VISUAL=$EDITOR

# Global path for cd (no matter which directory you're in right now)
export CDPATH=.:~:~/Code

# Ignore from history repeat commands, and some other unimportant ones
export HISTIGNORE="&:[bf]g:c:exit"

# Ruby development made easier
export RUBYOPT="rubygems Ilib Itest Ispec"
PREFIX=$HOME
export GEM_HOME=$PREFIX/.gems
export RUBYLIB=$PREFIX/lib/ruby:$PREFIX/lib/site_ruby/1.8

# Use vim to browse man pages. One can use Ctrl-[ and Ctrl-t
# to browse and return from referenced man pages. ZZ or q to quit.
# NOTE: initially within vim, one can goto the man page for the
#       word under the cursor by using [section_number]K.
export MANPAGER='bash -c "vim -MRn -c \"set ft=man nomod nolist nospell nonu\" \
-c \"nm q :qa!<CR>\" -c \"nm <end> G\" -c \"nm <home> gg\"</dev/tty <(col -b)"'

##################### node #################################

export PATH=$PATH:/usr/local/share/npm/bin

### GDAL

export PATH=/Library/Frameworks/GDAL.framework/Programs:$PATH

# Bash completion
if [ -f `brew --prefix`/etc/bash_completion.d/git-completion.bash ]; then
. `brew --prefix`/etc/bash_completion.d/git-completion.bash
fi

if [ -f `brew --prefix`/etc/bash_completion.d/git-prompt.sh ]; then
    . `brew --prefix`/etc/bash_completion.d/git-prompt.sh
fi

################################################################################
#                                                                              #
#                               External Scripts                               #
#                                                                              #
################################################################################

################################################################################
#                                                                              #
#                                    Aliases                                   #
#                                                                              #
################################################################################

# General
alias ll='ls -la'
alias ls='ls -G'
alias c='clear'
alias g='git'
alias st='git status'
alias gl='git log'
alias ..='cd ..'
alias screen='screen -U'
alias retag='ctags --extra=+f -R .'
alias greprc='grep --color=always -r'

# Ruby
alias r='rake'

# Rails 2
alias sg='script/generate'
alias ss='script/server'
alias sc='script/console'
alias sd='script/dbconsole'

# Rails 3
alias rg='script/rails generate'
alias rs='script/rails server'
alias rc='script/rails console'
alias rd='script/rails dbconsole'

# Bundler
alias b='bundle'
alias bx='bundle exec'


################################################################################
#                                                                              #
#                                   Functions                                  #
#                                                                              #
################################################################################

# cd into matching gem directory
cdgem() {
  local gempath=$(gem env gemdir)/gems
  if [[ $1 == "" ]]; then
    cd $gempath
    return
  fi

  local gem=$(ls $gempath | g $1 | sort | tail -1)
  if [[ $gem != "" ]]; then
    cd $gempath/$gem
  fi
}
_cdgem() {
  COMPREPLY=($(compgen -W '$(ls `gem env gemdir`/gems)' -- ${COMP_WORDS[COMP_CWORD]}))
  return 0;
}
complete -o default -o nospace -F _cdgem cdgem;

# Encode the string into "%xx"
urlencode() {
  ruby -e 'puts ARGV[0].split(/%/).map{|c|"%c"%c.to_i(16)} * ""' $1
}

# Decode a urlencoded string ("%xx")
urldecode() {
  ruby -r cgi -e 'puts CGI.unescape ARGV[0]' $1
}

# open mvim for ack search results
ackvim(){
  local pattern=$1; shift
  ack -l --print0 "$pattern" "$@" | xargs -0o mvim -o +/"$pattern"
}

# reverse find
rfind() {
  local target="$1" cwd="$PWD"

  [[ "$target" ]] || { echo "ERROR: missing target" >&2; return 1; }

  while [[ "$cwd" ]]; do
    if [[ -e "$cwd"/"$target" ]]; then
      echo "$cwd"/"$target"
      return 0
    fi
    cwd="${cwd%/*}"
  done
  return 1
}; export -f rfind

load_snapshot() {
  local dumpname=${1:-~/dump.sql.gz}
  local config=$(rfind config/database.yml) || { echo "ERROR: could not find 'config/database.yml'" >&2; return 1; }
  local database=$(ruby -ryaml -e "puts YAML.load_file('$config').fetch('development', {}).fetch('database')")

  [[ -e $dumpname ]] || { echo "ERROR: file '$dumpname' does not exist" >&2; return 1; }

  dropdb "$database" && rake db:create && gzip -d < "$dumpname" | psql "$database"
}

save_snapshot() {
  local dumpname=${1:-~/dump.sql.gz}
  local config=$(rfind config/database.yml) || { echo "ERROR: could not find 'config/database.yml'" >&2; return 1; }
  local database=$(ruby -ryaml -e "puts YAML.load_file('$config').fetch('development', {}).fetch('database')")

  if [[ -e $dumpname ]]; then
    read -p "file '$dumpname' exists, overwrite? " -n 1
    echo
    [[ $REPLY = [Yy] ]] || return 0
  fi

  pg_dump "$database" | gzip > "$dumpname"
}

################################################################################
#                                                                              #
#                                     Prompt                                   #
#                                                                              #
################################################################################

# Prompt in two lines:
#   <hostname> <full path to pwd> (git: <git branch>)
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[01;33m\]$(__git_ps1) - ''\[\033[01;34m\]\$\[\033[00m\] '

# RVM PATH

export RUBY_HEAP_MIN_SLOTS=500000
export RUBY_HEAP_SLOTS_INCREMENT=250000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=50000000

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
