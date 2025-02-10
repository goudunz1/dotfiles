# vim: fdm=marker :


################################################################################
# File: .bashrc
# Author: goudunz1
# Email: goudunz1@outlook.com
# Description:
#   Please source this runtime file instead of executing it.
#   It is designed to be backward compatiable with some POSIX shells like dash
#   on purpose.
# Referrence:
# - https://gist.github.com/zachbrowne
# - https://github.com/ohmybash/oh-my-bash
# - https://github.com/nicksp/dotfiles
################################################################################


################################################################################
# Environment Variables {{{

# default editor: vim
export EDITOR=vim
export VISUAL=vim

# Chinese
#export LANG=zh_CN.UTF-8
#export LC_ALL=zh_CN.UTF-8
#export LC_LANG=zh_CN.UTF-8

# pyenv {{{
export PYENV_ROOT=~/.pyenv
command -v pyenv > /dev/null || if [ -d $PYENV_ROOT ]; then
    export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init -)"
fi
# }}}

# venv {{{
export VENV_ROOT=~/.venv
command -v activate > /dev/null || if [ -d $VENV_ROOT ]; then
    activate() {
        . "$VENV_ROOT/$1/bin/activate"
    }
fi
# }}}

# node.js (nvm) {{{
export NVM_DIR=~/.nvm
command -v nvm > /dev/null || if [ -d $NVM_DIR ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" > /dev/null
    [ -n "$BASH_VERSION" ] && [ -s "$NVM_DIR/bash_completion" ] && \
        . "$NVM_DIR/bash_completion" > /dev/null
fi
# }}}

# Android SDK {{{
export ANDROID_HOME=/opt/android-sdk
command -v adb > /dev/null || if [ -d $ANDROID_HOME ]; then

    # Android Emulator & Platform Tools
    export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

    # Native Development Kit
    NDK="$ANDROID_HOME/ndk"
    NDK_VER=$(ls -1A $NDK | tail -n 1 | sed "s/\\///g" 2>/dev/null)
    if [ -n $NDK_VER ]; then
        export PATH="$PATH:$NDK/$NDK_VER"
    fi

    # Command Line Tools
    CTOOLS="$ANDROID_HOME/cmdline-tools"
    CTOOLS_VER=$(ls -1A $CTOOLS | tail -n 1 | sed "s/\\///g" 2>/dev/null)
    if [ -n $CTOOLS_VER ]; then
        export PATH="$PATH:$CTOOLS/$CTOOLS_VER"
    fi

    # Build Tools
    BTOOLS="$ANDROID_HOME/build-tools"
    BTOOLS_VER=$(ls -1A $BTOOLS | tail -n 1 | sed "s/\\///g" 2>/dev/null)
    if [ -n $BTOOLS_VER ]; then
        export PATH="$PATH:$BTOOLS/$BTOOLS_VER"
    fi
fi
# }}}

# }}}
################################################################################


# Exit now if not running interactively
if [ $(expr index $- i) -eq 0 ]; then
    return
fi


################################################################################
# Terminal Options {{{

# Disable ctrl-S, leaving it for i-search
stty -ixon

# }}}
################################################################################


################################################################################
# Pseudo-commands {{{
################################################################################

# List processes running on a provided port
# You may need root to list daemons
portchk() { # {{{
    if [ "$#" -eq 0 ]; then
        echo "Usage: $(basename "$0") <port_number>"
        return
    fi
    lsof -ni4TCP:"$1"
} # }}}

# Kill the process running on the provided port
portkill() { # {{{
    if [ "$#" -eq 0 ]; then
        echo "Usage: $(basename "$0") <port_number>"
        return
    fi

    port_num="$(lsof -ti4TCP:"$1")"
    if [ $? -eq 0 ]; then
        kill -15 "$port_num"
    fi
} # }}}

# Show current network connections to the port
connchk() { # {{{
    if [ "$#" -eq 0 ]; then
        echo "Usage: $(basename "$0") <port_number>"
        return
    fi

    netstat -napl | grep ":$1" | \
    awk "{print \$5}" | cut -d ":" -f 1 | \
    sort | uniq -c | sort -n | sed -e 's/^ *//' -e 's/ *\$//'
} # }}}

# Purge all .DS_Store recursively under PWD
fuckdsstore() { # {{{
    find . -name .DS_Store -delete
} # }}}



# Count all files (recursively) in the current folder
fcnt() { # {{{
    for t in files links directories; do
        echo $(find . -type ${t:0:1} | wc -l) $t;
    done 2> /dev/null
} # }}}

# Monitor all logs in /var/log
# You may need root perm to see more!
logmon() { # {{{
    find /var/log -type f -exec file {} \; | grep 'text' | \
    cut -d ' ' -f 1 | sed -e 's/:$//g' | grep -v '[0-9]$' | \
    xargs tail -n 10 -f
} # }}}

# List programs sorted by CPU usage
topcpu() { # {{{
    ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10
} # }}}

# Lazy archive extraction
extract() { # {{{
    if [ "$#" -eq 0 ]; then
        echo "Usage: $(basename "$0") <ar1> [<ar2> <ar3> ...]"
        return
    fi

    for a in $*; do
        if [ -f $a ] ; then
            case $a in
                *.tar.bz2) tar xvjf $a     ;;
                *.tar.gz)    tar xvzf $a     ;;
                *.bz2)     bunzip2 $a    ;;
                *.rar)     rar x $a        ;;
                *.gz)        gunzip $a     ;;
                *.tar)     tar xvf $a    ;;
                *.tbz2)    tar xvjf $a     ;;
                *.tgz)     tar xvzf $a     ;;
                *.zip)     unzip $a        ;;
                *.Z)         uncompress $a ;;
                *.7z)        7z x $a         ;;
                *)         echo "don't know how to extract '$a'..." ;;
            esac
        else
            echo "'$a' is not a valid file!"
        fi
    done
} # }}}

# Searches for text in all files
gtxt() { # {{{
    # -i case-insensitive
    # -I ignore binary files
    # -H causes filename to be printed
    # -r recursive search
    # -n causes line number to be printed
    grep -iIHrn --color=always "$1" . | less -r
} # }}}

# Copy file with a progress bar
cpbar() { # {{{
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 \
    | awk '{
    count += $NF
    if (count % 10 == 0) {
        percent = count / total_size * 100
        printf "%3d%% [", percent
        for (i=0;i<=percent;i=i+2)
            printf "="
            printf ">"
            for (i=percent;i<100;i=i+2)
                printf " "
                printf "]\r"
            }
        }
    END { print "" }' total_size=$(stat -c '%s' "${1}") count=0
} # }}}

# Show CPU usage (percentage)
cpu() { # {{{
    top -bn1 | awk '/Cpu/{ printf("%.2f%%",($2+$4)*100/($2+$4+$8)) }'
    echo
} # }}}

# Copy and go to the directory
cpgo() { # {{{
    if [ -d "$2" ];then
        cp $1 $2 && cd $2
    else
        cp $1 $2
    fi
} # }}}

# Move and go to the directory
mvgo() { # {{{
    if [ -d "$2" ];then
        mv $1 $2 && cd $2
    else
        mv $1 $2
    fi
} # }}}

# Make directory and go to the directory
mdgo() { # {{{
    mkdir -p $1
    cd $1
} # }}}

# Goes up a specified number of directories (eg. up 4)
up() { # {{{
    local d=""
    for i in {1..$1}; do
        d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
} # }}}

# rot13 cipher
rot13() { # {{{
    if [ $# -eq 0 ]; then
        tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
    else
        echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
    fi
} # }}}

# Trim leading and trailing spaces (for scripts)
trim() { # {{{
    local var=$@
    var="${var#"${var%%[![:space:]]*}"}"    # for leading
    var="${var%"${var##*[![:space:]]}"}"    # for trailing
    echo -n "$var"
} # }}}

# (Un)set HTTP proxy to localhost:<port>
proxy() { # {{{
    if [ $# -eq 1 ]; then
        echo "proxy set to port $1"
        export {HTTP,HTTPS,FTP}_PROXY="127.0.0.1:$1"
    elif [ $# -eq 0 ]; then
        echo "unset proxy"
        export {HTTP,HTTPS,FTP}_PROXY=""
    else
        echo "usage: proxy <port>"
    fi
} # }}}

# Show current network interface IPs
netinfo() { # {{{
    ifconfig | awk '/inet /{print $2}'
} # }}}

# IP address lookup
whatsmyip() { # {{{
    # Internal IP Lookup
    echo -n "Internal IP: "
    ifconfig eth0 | grep "inet " | awk '/inet /{print $2}'
    ifconfig wlan0 | grep "inet " | awk '/inet /{print $2}'

    # External IP Lookup
    echo -n "External IP: "
    wget https://myexternalip.com/raw -O - -q
    echo
}

alias whatismyip="whatsmyip"

# }}}

# View Apache logs
a2log() { # {{{
    if [ -f /etc/httpd/conf/httpd.conf ]; then
        cd /var/log/httpd && \
            ls -xAh && \
            $cmd /var/log/httpd/*_log
    else
        cd /var/log/apache2 && \
            ls -xAh && \
            $cmd /var/log/apache2/*.log
    fi
} # }}}

# Edit Apache configuration
a2cfg () { # {{{
    local cfg
    if [ -f /etc/httpd/conf/httpd.conf ]; then
        cfg=/etc/httpd/conf/httpd.conf
    elif [ -f /etc/apache2/apache2.conf ]; then
        cfg=/etc/apache2/apache2.conf
    fi
    if [ -f "$cfg" ]; then
        $EDITOR $cfg
    else
        echo "Error: Apache config file could not be found."
    fi
} # }}}

# Edit PHP configuration
phpcfg() { # {{{
    local cfg
    if [ -f /etc/php.ini ]; then
        cfg=/etc/php.ini
    elif [ -f /etc/php/php.ini ]; then
        cfg=/etc/php/php.ini
    elif [ -f /etc/php5/php.ini ]; then
        cfg=/etc/php5/php.ini
    elif [ -f /usr/bin/php5/bin/php.ini ]; then
        cfg=/usr/bin/php5/bin/php.ini
    elif [ -f /etc/php5/apache2/php.ini ]; then
        cfg=/etc/php5/apache2/php.ini
    fi
    if [ -f "$cfg" ]; then
        $EDITOR $cfg
    else
        echo "Error: php.ini file could not be found."
    fi
} # }}}

# Edit MySQL configuration
mysqlcfg () { # {{{
    local cfg
    if [ -f /etc/my.cnf ]; then
        cfg=/etc/my.cnf
    elif [ -f /etc/mysql/my.cnf ]; then
        cfg=/etc/mysql/my.cnf
    elif [ -f /usr/local/etc/my.cnf ]; then
        cfg=/usr/local/etc/my.cnf
    elif [ -f /usr/bin/mysql/my.cnf ]; then
        cfg=/usr/bin/mysql/my.cnf
    elif [ -f ~/my.cnf ]; then
        cfg=~/my.cnf
    elif [ -f ~/.my.cnf ]; then
        cfg=~/.my.cnf
    fi
    if [ -f "$cfg" ]; then
        $EDITOR $cfg
    else
        echo "Error: my.cnf file could not be found."
    fi
} # }}}

# }}}
################################################################################


################################################################################
# Shortcuts {{{
# To temporarily bypass an alias, we prefix the command with '\', eg: \ls

alias cp='cp -riv'
alias mv='mv -iv'
alias rm='rm -riv'
alias md='mkdir -p'
alias mkdir='mkdir -p'
alias ps='ps faux | less'        # process forest, BSD style
alias c='clear'
alias cs='clear'
alias cls='clear'
alias q='exit'
alias quit='exit'
alias h='history | less'
alias hist='history | less'
alias p='cat'
alias l='less'
alias f='find . | grep'
alias k='kill'
alias j='jobs'
alias dt='date "+%Y-%m-%d %A %T %Z"'
alias e='$EDITOR'
alias se='sudo $EDITOR'
alias s='sudo -i'
alias t='tree -CAhF --dirsfirst'    # file tree with size & color
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mk='make'
alias g='grep --color=always'
alias grep='grep --color=always'
alias py='python3'
alias dk='docker'
alias dcomp='docker-compose'
alias ks='kubectl'
alias ls='ls --color=always'
alias ll='ls -alhF --color=always'    # list all
alias lfile="ls -l | egrep -v '^d'" # list files only
alias ldir="ls -l | egrep '^d'"     # list directories only
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
alias home='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ,,='cd $OLDPWD'
alias bd='cd $OLDPWD'
alias web='cd /var/www/html'        # cd to web root
alias ports='netstat -nlape --inet' # show open ports
alias df='df -hT'                     # show fs and usage
alias usg='du -sh .'                # disk usage
alias fusg='du -h --max-depth=1'
alias fsort="du -S | sort -n -r | more"
alias apt='sudo apt'
alias apt-get='sudo apt-get'
alias apth='cat /var/log/dpkg.log | less -R'
alias aptl='sudo apt list --installed | less -R'
alias apti='sudo apt install'
alias aptu='sudo apt update'
alias aptg='sudo apt upgrade'
alias aptx='sudo apt purge'
alias aptc='sudo apt autoremove --purge'
alias systemctl='sudo systemctl'
alias sup='sudo systemctl start'
alias sdwn='sudo systemctl stop'
alias srst='sudo systemctl restart'
alias sen='sudo systemctl enable'
alias sdis='sudo systemctl disable'
alias schk='sudo systemctl status'
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'
alias sha1='openssl sha1'
alias sha256='openssl sha256'
alias sha512='openssl sha512'
alias md5='md5sum'
alias b64='base64'
alias hexeditor='hexeditor -n'
alias rdp='xfreerdp /cert:ignore +dynamic-resolution +auto-reconnect /compression-level:2'

# }}}
################################################################################


# Exit now if not bash
if ! [ -n "$BASH_VERSION" ]; then
    return
fi


################################################################################
# Auto Completion {{{



# }}}
################################################################################


################################################################################
# Bash Options {{{

# Fail a pipe if one of its commands fail
set -o pipefail

# See `man readline` for more readline variables
bind "set bell-style visible"              # mute
bind "set colored-completion-prefix on"    # colorize prefix
bind "set colored-stats on"                # colorize file type(stat)
bind "set completion-ignore-case on"       # ignore alphabetical case
bind "set completion-map-case on"          # mix hyphens & underscores
bind "set mark-symlinked-directories on"   # append directory slash for symlinked directories
bind "set menu-complete-display-prefix on" # keep the first candidate to be the prefix itself
bind "set show-all-if-ambiguous on"        # press tab only once
bind 'TAB:menu-complete'                   # tab to circle forward
bind '"\e[Z":menu-complete-backward'       # shift-tab to circle backward
bind '"\C-g":unix-filename-rubout'         # ctrl-g to erase until slash

# }}}
################################################################################


################################################################################
# Prompt String {{{

# pre-defined colors
LIGHTGRAY="\033[1;37m"
WHITE="\033[1;37m"
BLACK="\033[1;30m"
DARKGRAY="\033[1;30m"
RED="\033[1;31m"
LIGHTRED="\033[1;31m"
GREEN="\033[1;32m"
LIGHTGREEN="\033[1;32m"
BROWN="\033[1;33m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
LIGHTBLUE="\033[1;34m"
MAGENTA="\033[1;35m"
LIGHTMAGENTA="\033[1;35m"
CYAN="\033[1;36m"
LIGHTCYAN="\033[1;36m"
NOCOLOR="\033[0m"

# Color for the user, red means root
if [ $EUID -ne 0 ]; then
    USERCOLOR=$GREEN
else
    USERCOLOR=$RED
fi

# PS1 prefix, showing python venv and chroot
PREFIX='${VIRTUAL_ENV:+<$(basename $VIRTUAL_ENV)>-}${debian_chroot:+<$debian_chroot>-}'

# User and host
SSH_IP=`echo $SSH_CLIENT | awk '{ print $1 }'`
SSH2_IP=`echo $SSH2_CLIENT | awk '{ print $1 }'`

if [ $SSH2_IP ]; then
    RHOST=$SSH2_IP
elif [ $SSH_IP ]; then
    RHOST=$SSH_IP
else
    RHOST="\h"
fi

# <user[@host]:pwd>
WORKINGON="<\[${USERCOLOR}\]\u\[${NOCOLOR}\]@\[${CYAN}\]${RHOST:-localhost}\[${NOCOLOR}\]:\[${BLUE}\]\w\[${NOCOLOR}\]>"

__myprompt ()
{
    local exit_code=$?

    if [ ${exit_code} -ne 0 ]; then
        local exit_prompt="<\[${MAGENTA}\]$exit_code\[${NOCOLOR}\]>-"
    fi

    # [[<pyenv>-][<chroot>-]]<date>-<user[@host]:pwd>\n
    PS1="${exit_prompt:-}${PREFIX:-}<\[${BROWN}\]$(date +%a\ %H:%M)\[${NOCOLOR}\]>-${WORKINGON}\n"
}

PROMPT_COMMAND='__myprompt'

# }}}
################################################################################
