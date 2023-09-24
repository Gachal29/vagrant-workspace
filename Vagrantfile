require "fileutils"
require "json"

CONFIG_FILE = "config.json"
CONFIG_EXAMPLE = "example.config.json"

if File.exist?(CONFIG_FILE)
    puts "Using %s" % [CONFIG_FILE]
else
    puts "Config file is not found. Copy %s from %s" % [CONFIG_FILE, CONFIG_EXAMPLE]
end

workspace_config = {}
File.open(CONFIG_FILE) do |f|
    workspace_config = JSON.load(f)
end

puts "[config]"
puts workspace_config

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/jammy64"
    config.vm.network "private_network", ip: workspace_config["ip_address"]
    config.vm.network "forwarded_port", guest: 22, host: workspace_config["forwarded_port"], id: "ssh"
    config.vm.provider :virtualbox do |vb|
        vb.memory = workspace_config["memory"]
    end
    config.ssh.forward_agent = true
    config.disksize.size = workspace_config["disksize"]

    if workspace_config["synced_folder_host"] && workspace_config["synced_folder_guest"]
        config.vm.synced_folder workspace_config["synced_folder_host"], workspace_config["synced_folder_guest"]
    end

    config.vm.provision :shell, inline: <<-EOS
        export DEBIAN_FRONTEND=noninteractive
        apt-get update
        apt-get install -y \
            curl \
            ca-certificates \
            apt-transport-https \
            gnupg \
            gnupg-agent \
            software-properties-common \
            sudo
        
        # Add deadsnakes repository
        add-apt-repository -y ppa:deadsnakes/ppa

        # Add NodeJS repository
        curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -

        # Add Docker repository
        install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        chmod a+r /etc/apt/keyrings/docker.gpg
        echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

        # Update package list
        apt-get install --allow-unauthenticated
        
        # Generic development
        apt-get install -y \
            tree \
            zip \
            unzip \
            build-essential \
            language-pack-ja-base \
            language-pack-ja

        # Japanese locale
        update-locale LANG=ja_JP.UTF-8

        # Set timezone
        timedatectl set-timezone Asia/Tokyo

        # Python development
        apt-get install -y \
            python3.9 \
            python3.9-dev \
            python3.9-venv \
            python3.10 \
            python3.10-dev \
            python3.10-venv \
            python3.11 \
            python3.11-dev \
            python3.11-venv

        # NodeJS development
        apt-get install -y nodejs

        # Requirements AppEngine SDK
        apt-get install -y \
            ca-certificates \
            curl \
            git \
            wget \
        
        # Utility
        apt-get install -y \
            gettext \
            sqlite3 \
        
        # MySQL development
        debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
        debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
        apt-get install -y \
            mysql-server \
            mysql-client \
            libmysqlclient-dev
        
        # Memcached
        apt-get install -y \
            memcached \
            libmemcached-dev
        
        # Redis
        apt-get install -y \
            redis-server \
            redis-tools
        
        # Docker
        apt-get install -y \
            docker-ce \
            docker-ce-cli \
            containerd.io \
            docker-buildx-plugin \
            docker-compose-plugin
        groupadd -f docker
        usermod -aG docker vagrant

        # check docker enabled
        systemctl list-unit-files --state=enabled | grep docker
        if [ $? = 1 ]; then
            systemctl enable containerd.service
        fi

        # ngrok
        if [ ! -e /usr/local/bin/ngrok ]; then
            wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -O /tmp/ngrok-v3-stable-linux-amd64.tgz
            tar xvzf /tmp/ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin/
        fi

        # end
        echo finish provision
    EOS

    config.vm.provision :shell, :path => "./scripts/git-completion-settings.sh"
end
