alias df='df -h'
alias rs='rsync -Pavzir'

alias ls='ls -G'
alias grep='grep --color=auto'

alias sshp='ssh -i ~/.ssh/devops.pem -l ubuntu -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null'
alias sshs='ssh -i ~/.ssh/tkt-integration.pem -l ubuntu -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null'
alias mysqlp='mysql -h readonly1.mysql.ticketea.com -P 3307 -u readonly -p ticketea'

alias backoffice='cd ~/ticketea/backoffice && workon backoffice'
alias afrodita='cd ~/ticketea/afrodita && workon afrodita'
alias heracles='cd ~/ticketea/heracles && workon heracles'
alias nemesis='cd ~/ticketea/nemesis && workon nemesis'
alias devops='cd ~/ticketea/devops && workon devops'
alias hades='cd ~/ticketea/hades && workon hades'
alias thor='cd ~/ticketea/thor && workon thor'
alias odin='cd ~/ticketea/odin && workon odin'

alias devproxy='cd ~/ticketea/devproxy'

alias api='cd ~/ticketea/api'

alias meld='/Applications/Meld.app/Contents/MacOS/Meld'

alias make='gmake'
