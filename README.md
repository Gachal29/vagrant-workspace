# vagrant-workspace

## Vagrantfileをclone
```
git clone git@github.com:Gachal29/vagrant-workspace.git {workcpace_name}
```

## vm環境の構築
config.jsonをカスタマイズする場合、`example.config.json`をコピーし`config.json`を修正する。
```
cp example.config.json config.json
```

## git, githubの環境を構築
鍵ファイル名は`git_id_rsa`とする。
```
git config --global user.name "username"
git config --global user.email "email@example.com"

cd ~/.ssh
ssh-keygen -t rsa -C "email@example.com"
```

`config`ファイルを作成し、編集する。
```
touch ~/.ssh/config
```

### configファイルの内容
```
Host git github.com
  HostName github.com
  IdentityFile ~/.ssh/git_id_rsa
  User git
```

`~/.ssh/git_id_rsa.pub`（公開鍵）の内容をgithubへ登録する

## vm-setting-toolsをcloneする
```
git clone git@github.com:Gachal29/vm-setting-tools.git
```

