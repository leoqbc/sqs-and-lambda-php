## Git aliases
## /git-aliases
##PS1 Com git branch
gbranch()
{
    if [ -d .git ]; then
    local ref_branch=$(git symbolic-ref --short HEAD 2> /dev/null)
    echo BRANCH ["${ref_branch:-}"];
    fi
}

machine_name()
{
    echo "\${MACHINE_NAME}"
}

PS1="
\[\e[91m\]`machine_name` | \u\[\e[38;5;208m\]@\[\e[92m\]\h:\[\e[96m\]\$PWD\[\e[35m\] | \$(date +"%Y-%m-%d_%H:%M:%S" | sed 's/\//-/g')
\[\e[38;5;208m\]\`gbranch\` \[\e[92m\]\$(pwd)
\[\e[38;5;26m\][\$(whoami) \\$]~>\[\e[0m\] "


## Manter essa linha para que seja renomeado o título do terminal
## O título da aba é o nome da pasta
PS1="\[\e]0;${debian_chroot:+($debian_chroot)} \w\a\]$PS1"

if [ -f ~/bash_aliases.sh ]; then
    . ~/bash_aliases.sh
fi
