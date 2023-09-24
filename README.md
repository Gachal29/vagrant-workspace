# vagrant-workspace

## Vagrantfileをclone
```
git clone git@github.com:Gachal29/vagrant-workspace.git {workcpace_name}
```

## vm環境の構築
config.jsonをカスタマイズする場合、`example.config.json`をコピーし`config.json`を修正する。
```
cd workspace
cp example.config.json config.json
```

vmの起動
```
vagrant up
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

## vmへのssh接続設定
workspaceのvagrantを起動した状態で以下を実行し、出力結果をホスト側のconfigファイルへ追記する
```
cd workspace
vagrant ssh-config
```

### vagrant ssh-configの出力結果（例）
`Host`の値を書き換える
```
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile ~~~/private_key
  IdentitiesOnly yes
  LogLevel FATAL
  ForwardAgent yes
  PubkeyAcceptedKeyTypes +ssh-rsa
  HostKeyAlgorithms +ssh-rsa
```
