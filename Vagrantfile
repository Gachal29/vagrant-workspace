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

def common_script config
    puts "Start Common Settings"

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

        # Requirements AppEngine SDK
        apt-get install -y \
            ca-certificates \
            curl \
            git \
            wget \
        
        # Utility
        apt-get install -y gettext
    EOS

    puts "Finish Common Settings"
end

def python_setup config, dev_tools
    puts "Start Python Settings"

    config.vm.provision :shell, inline: <<-EOS
        # Add deadsnakes repository
        add-apt-repository -y ppa:deadsnakes/ppa
        apt-get update
    EOS

    if dev_tools.any?{ |tool| tool == "python3.9" || tool == "python" || tool == "python3" }
        puts "Python3.9"
        config.vm.provision :shell, inline: <<-EOS
            apt-get install -y \
                python3.9 \
                python3.9-dev \
                python3.9-venv
        EOS
        puts "Finish"
    end

    if dev_tools.any?{ |tool| tool == "python3.10" || tool == "python" || tool == "python3" }
        puts "Python3.10"
        config.vm.provision :shell, inline: <<-EOS
            apt-get install -y \
                python3.10 \
                python3.10-dev \
                python3.10-venv
        EOS
        puts "Finish"
    end

    if dev_tools.any?{ |tool| tool == "python3.11" || tool == "python" || tool == "python3" }
        puts "Python3.11"
        config.vm.provision :shell, inline: <<-EOS
            apt-get install -y \
                python3.11 \
                python3.11-dev \
                python3.11-venv
        EOS
        puts "Finish"
    end

    puts "Finish Python Settings"
end

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

    common_script(config)

    if workspace_config["dev-tools"].any?{ |tool| tool.start_with?("python") }
        python_setup(config, workspace_config["dev-tools"])
    end

    if workspace_config["dev-tools"].include?("nodejs")
        puts "Start NodeJS Settings"
        config.vm.provision :shell, inline: <<-EOS
            # Add NodeJS repository
            curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -

            # NodeJS
            apt-get update
            apt-get install -y nodejs
        EOS
        puts "Finish NodeJS Settings"
    end

    if workspace_config["dev-tools"].include?("db")
        puts "Start DB Settings"
        config.vm.provision :shell, inline: <<-EOS
            # sqlite3
            apt-get install -y sqlite3

            # MySQL
            debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
            debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
            apt-get install -y \
                mysql-server \
                mysql-client \
                libmysqlclient-dev
        EOS
        puts "Finish DB Settings"
    end

    if workspace_config["dev-tools"].include?("memcached")
        puts "Start Memcached Settings"
        config.vm.provision :shell, inline: <<-EOS
            apt-get install -y \
                memcached \
                libmemcached-dev
        EOS
        puts "Finish Memcached Settings"
    end

    if workspace_config["dev-tools"].include?("redis")
        puts "Start Redis Settings"
        config.vm.provision :shell, inline: <<-EOS
            apt-get install -y \
                redis-server \
                redis-tools
        EOS
        puts "Finish Redis Settings"
    end

    if workspace_config["dev-tools"].include?("ngrok")
        puts "Start ngrok Settings"
        config.vm.provision :shell, inline: <<-EOS
            if [ ! -e /usr/local/bin/ngrok ]; then
                wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -O /tmp/ngrok-v3-stable-linux-amd64.tgz
                tar xvzf /tmp/ngrok-v3-stable-linux-amd64.tgz -C /usr/local/bin/
            fi
        EOS
        puts "Finish ngrok Settings"
    end

    config.vm.provision :shell, inline: 'echo "finish provision"'
end

