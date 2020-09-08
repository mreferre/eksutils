#!/bin/bash
# this script checks the versions of the tools and utilities installed

errorcheck() {
   if [ $? != 0 ]; then
          logger "red" "Unrecoverable generic error found checking [$1]. Exiting."
      exit 1
   fi
}

logger() {
  LOG_TYPE=$1
  MSG=$2

  COLOR_OFF="\x1b[39;49;00m"
  case "${LOG_TYPE}" in
      green)
          # Green
          COLOR_ON="\x1b[32;01m";;
      blue)
          # Blue
          COLOR_ON="\x1b[36;01m";;
      yellow)
          # Yellow
          COLOR_ON="\x1b[33;01m";;
      red)
          # Red
          COLOR_ON="\x1b[31;01m";;
      default)
          # Default
          COLOR_ON="${COLOR_OFF}";;
      *)
          # Default
          COLOR_ON="${COLOR_OFF}";;
  esac

  TIME=$(date +%F" "%H:%M:%S)
  echo -e "${COLOR_ON}${TIME} -- ${MSG} ${COLOR_OFF}"
}

# yum-installed system tools:
logger "green" "checking yum..."
yum version
errorcheck yum
logger "green" "checking git..."
git version
errorcheck git 
logger "green" "checking yarn..."
yarn --version
errorcheck yarn 
logger "green" "checking sudo..."
sudo -V # | head -n 1
errorcheck sudo
logger "green" "checking ab..."
ab -V
errorcheck ab
logger "green" "checking jq..."
jq --version
errorcheck jq
logger "green" "checking less..."
less --version
errorcheck less
logger "green" "checking openssl..."
openssl version
errorcheck openssl
logger "green" "checking python..."
python --version
errorcheck python
logger "green" "checking python3..."
python3 --version
errorcheck python3
logger "green" "checking tar..."
tar --version # | head -n 1
errorcheck tar
logger "green" "checking unzip..."
unzip # | head -n 1
errorcheck unzip
logger "green" "checking vi..."
vi --version # | head -n 1
errorcheck vi
logger "green" "checking wget..."
wget --version # | head -n 1
errorcheck wget
logger "green" "checking which..."
which --version # | head -n 1
errorcheck which
logger "green" "checking figlet..."
figlet -v # | head -n 1
errorcheck figlet

# add-ons tools (pre-requisites for the actual utilities) 
logger "green" "checking pip..."
pip --version
errorcheck pip
logger "green" "checking node..."
node --version
errorcheck node

# utilities
logger "green" "checking aws..."
aws --version
errorcheck aws
logger "green" "checking eb..."
eb --version
errorcheck eb
logger "green" "checking cdk..."
cdk --version
errorcheck cdk8s 
logger "green" "checking cdk8s..."
cdk8s --version
errorcheck cdk 
logger "green" "checking kubectl..."
kubectl version --client=true 
errorcheck kubectl 
logger "green" "checking aws-iam-authenticator..."
aws-iam-authenticator version
errorcheck aws-iam-authenticator
logger "green" "checking helm..."
helm version -c 
errorcheck helm 
logger "green" "checking eksctl..."
eksctl version 
errorcheck eksctl 
logger "green" "checking eksuser..."
eksuser version 
errorcheck eksuser
logger "green" "checking kubecfg..."
kubecfg version 
errorcheck kubecfg
logger "green" "checking ks..."
ks version 
errorcheck ks
logger "green" "checking k9s..."
k9s version
errorcheck k9s
logger "green" "checking docker..."
docker --version
errorcheck docker
logger "green" "checking docker-compose..."
docker-compose --version
errorcheck docker-compose
logger "green" "checking docker-ecs..."
export DOCKER_CLI_EXPERIMENTAL=enabled && docker ecs version
errorcheck docker-ecs
logger "green" "checking kind..."
kind --version
errorcheck kind
logger "green" "checking octant..."
octant version 
errorcheck octant 
logger "green" "checking glooctl..."
glooctl version 
errorcheck glooctl
logger "green" "checking kubectx..."
kubectx -h
errorcheck kubectx
logger "green" "checking kubens..."
kubens -h
errorcheck kubens
logger "green" "checking bat..."
bat --version
errorcheck bat
logger "green" "checking code-server..."
code-server --version
errorcheck code-server