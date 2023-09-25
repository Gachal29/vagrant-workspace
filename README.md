# vagrant-workspace

## Vagrantfileをclone
```
git clone git@github.com:Gachal29/vagrant-workspace.git {workcpace_name}
cd workspace_name
```

## 設定ファイルの作成
```
cd config
cp example.vagrant_config.json vagrant_config.json
```

### vagrant_config.json 構築環境に合わせて書き換える
- dev_tools
  - 開発に必要なツールを選択する
    - pythonまたはpython3
      - Python3.9, 3.10, 3.11を全てインストール
    - python3.x
      - xでバージョンを指定する。指定したバージョンのみインストールされる
      - 3.9*, 3.10, 3.11
    - nodejs*
      - 18.x
    - db*
      - mysql 8.x
      - sqlite3
    - memcached
    - redis
    - ngrok
    - docker
  - *はデフォルトのconfigファイルでインストールされる
- memory
  - VMで使用可能なメモリ容量
    - 2GB: 2048
    - 4GB: 4096
    - 6GB: 6144
    - 8GB: 8192
  - デフォルト：4096
- disksize
  - データの保存領域
  - デフォルト：50GB
  - プラグインのインストール
    - `vagrant plugin install vagrant-disksize`
- ip_address
  - VMのローカルIP
  - デフォルト：`192.168.33.10`
- forwarded_port
  - sshのポート番号
  - デフォルト：2222
- VMとホストの共有フォルダ
  - 事前にホスト側にディレクトリを作成する必要がある
  - synced_folder_host
    - ホスト側のディレクトリを指定 (相対パス)
    - デフォルト：null
  - synced_folder_guest
    - VM側のディレクトリを指定 (絶対パス)
    - デフォルト：null
  - Vagrantfileに記述していないScriptを実行
    - before_external_script_paths
      - `common_script`より前に実行するScriptファイルのパス
    - after_external_script_paths
      - `common_script`の後に実行するScriptファイルのパス
      - デフォルト：`["./external_scripts/git_setting.sh"]`

## External Script
- Vagrantfileに記述していないScript
  - インストール済みのソフトウェアをアンインストールするなどの処理を実装
- ファイルの配置：`./external_scripts/`

### Scripts
- git_setting.sh
  - git関連の設定を行う
  - `config/example.git_config.json`から`config/git_config.json`を生成する
  ```
  cd config/
  cp example.git_config.json git_config.json
  ```
  - username
    - gitのユーザー名
  - email
    - gitのメールアドレス
  - identity_filename
    - 生成する公開鍵のファイル名

## Vagrantマシンを起動
```
vagrant up
```

Vagrantfileを更新した後はprovisionを行う
```
vagrant up --provision
```
