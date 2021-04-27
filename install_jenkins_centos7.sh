#!/bin/bash -x

set -e # exit on an error

ERROR(){
    /bin/echo -e "\e[101m\e[97m[ERROR]\e[49m\e[39m $@"
}

WARNING(){
    /bin/echo -e "\e[101m\e[97m[WARNING]\e[49m\e[39m $@"
}

INFO(){
    /bin/echo -e "\e[104m\e[97m[INFO]\e[49m\e[39m $@"
}

exists() {
    type $1 > /dev/null 2>&1
}

#Centos 7

JAVA_PATH='openjdk-8-jre-headless'
USER_NAME='admin'
USER_PASSWORD='admin'

PLUGIN_NAME=("parameterized-trigger" "rebuild" "BlueOcean" "Build-token-root" "EmailExt-Template" "File-Parameters" "Generic-Webhook-Trigger" "Git-Parameter" "Localization-zh-cn" "workflow-aggregator" "Pipeline-Utility-Steps" "SSH")


function install_jenkins {
    yum install wget -y
    wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    yum upgrade -y
    yum install jenkins java-1.8.0-openjdk-devel -y
    systemctl daemon-reload
    systemctl start jenkins
    sleep 30
}

function config_jenkins {
# Open firewall
#   ufw allow 8080
# Get initial password
    initial_password=$(cat /var/lib/jenkins/secrets/initialAdminPassword)
# Get jenkins CLI
    path_to_jenkins='/var/lib/jenkins/jenkins-cli.jar'
    if [ ! -f $path_to_jenkins ]; then
       wget http://localhost:8080/jnlpJars/jenkins-cli.jar -O $path_to_jenkins
    else
       INFO "CLI exist.."
    fi
# Jenkins version
    echo 2.0 > /var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion
# Create admin user
    echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount("'$USER_NAME'","'$USER_PASSWORD'")' |java -jar /var/lib/jenkins/jenkins-cli.jar -auth admin:$initial_password -s http://localhost:8080/ groovy =
    systemctl restart jenkins
}


function plugins_install {
#   sed 's/false/true/' /var/lib/jenkins/jenkins.CLI.xml
    sed -i 's/<denyAnonymousReadAccess>true<\/denyAnonymousReadAccess>/<denyAnonymousReadAccess>false<\/denyAnonymousReadAccess>/g' /var/lib/jenkins/config.xml
    systemctl restart jenkins
    sleep 20
    systemctl status jenkins

# Install plugins
    for i in ${PLUGIN_NAME[@]};do
       java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ -auth $USER_NAME:$USER_PASSWORD install-plugin $i 
    done
    systemctl restart jenkins
}

function main {
    install_jenkins
    config_jenkins
    plugins_install
}

main
