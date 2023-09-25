#!/bin/sh

apt-get install -y jq

GIT_USERNAME=$(jq -r '.username' /vagrant/config/git_config.json)
GIT_EMAIL=$(jq -r '.email' /vagrant/config/git_config.json)
IDENTITY_FILENAME=$(jq -r '.identity_filename' /vagrant/config/git_config.json)

git config --global user.name "$GIT_USERNAME"
git config --global user.name "$GIT_EMAIL"

# Gitのデフォルトブランチ名をmainに変更する（Gitがアップデートされたら削除する）
git config --global init.defaultBranch main

# SSHKEYを生成
ssh-keygen -t rsa -C "$GIT_EMAIL" -f "$HOME/.ssh/$IDENTITY_FILENAME" -N ""

cat ~/.ssh/$IDENTITY_FILENAME.pub

cat << EOF >> ~/.ssh/config
Host git github.com
  HostName github.com
  IdentityFile ~/.ssh/$IDENTITY_FILENAME
  User git
EOF

# Git completion settings
sudo mkdir /usr/local/etc/bash_completion.d
sudo curl -o /usr/local/etc/bash_completion.d/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
sudo curl -o /usr/local/etc/bash_completion.d/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

cat << "EOF" >> ~/.bashrc

source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true

if [ $UID -eq 0 ]; then
    PS1='\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\] \w\[\033[31m\]$(__git_ps1)\[\033[00m\]\n\\$ '
else
    PS1='\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\] \w\[\033[31m\]$(__git_ps1)\[\033[00m\]\n\\$ '
fi
EOF

source ~/.bashrc
