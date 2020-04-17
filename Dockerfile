ARG FROM_IMAGE=amazonlinux
ARG FROM_TAG=2.0.20200207.1
FROM ${FROM_IMAGE}:${FROM_TAG}

################## SETUP VERSIONS ##########################
ARG USER_NAME="eksutils"
ARG KUBE_RELEASE_VER=v1.17.3
#ARG NODE_VERSION=8.12.0
ARG NODE_VERSION=v12.16.1
ARG IAM_AUTH_VER=0.4.0
ARG EKSUSER_VER=0.1.1
ARG KUBECFG_VER=0.9.1
ARG KSONNET_VER=0.13.1
ARG K9S_VER=0.3.0
ARG DOCKER_COMPOSE_VER=1.25.4
ARG OCTANT_VER=0.10.2
ARG AWSCLI_URL_BASE=awscli.amazonaws.com
ARG AWSCLI_URL_FILE=awscli-exe-linux-x86_64.zip
#https://github.com/aca/go-kubectx/releases
ARG GOKUBECTX_VER=0.1.0
################## SETUP ENV ###############################
ENV USER_NAME $USER_NAME
ENV USER_PASSWORD $USER_PASSWORD
ENV CONTAINER_IMAGE_VER=v1.0.0
### OCTANT
# browser autostart at octant launch is disabled
# ip address and port are modified (to better work with Cloud9)  
ENV OCTANT_DISABLE_OPEN_BROWSER=1
ENV OCTANT_LISTENER_ADDR="0.0.0.0:8080"
### NODE
ENV NVM_DIR /usr/local/nvm
ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH
ENV NODE_VERSION=${NODE_VERSION}
################## BEGIN INSTALLATION ######################

########################################
## begin setup runtime pre-requisites ##
########################################

# setup various utils (latest at time of docker build)
# docker is being installed to support DinD scenarios (e.g. for being able to build)
# httpd-tools include the ab tool (for benchmarking http end points)
RUN yum update -y \
 && yum install -y \
            bsdtar \
            docker \
            git \
            httpd-tools \
            jq \
            less \
            openssl \
            python3 \
            tar \
            unzip \
            vi \
            wget \
            which \
            zsh \
            wget \
            fonts-powerline \
            emacs-nox \
            telnet \
            nc \
            iftop \
            tshark \
            tmux \
            bind-utils \
 && yum clean all \
 && rm -rf /var/cache/yum



## Make python3 default
RUN rm -f /usr/bin/python \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && sed -i 's$#!/usr/bin/python$#!/usr/bin/python2$' /usr/bin/yum

## This will remove intermediate downloads between RUN steps as /tmp is out of the container FS
VOLUME /tmp
WORKDIR /tmp

# Node
RUN mkdir -p ${NVM_DIR} \
 && curl -s https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
 && . $NVM_DIR/nvm.sh \
 && nvm install $NODE_VERSION \
 && nvm alias default $NODE_VERSION \
 && nvm use default

# setup Typescript (latest at time of docker build)
RUN npm install -g typescript

# setup pip (latest at time of docker build)
RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py \ 
   && python get-pip.py
 
########################################
### end setup runtime pre-requisites ###
########################################

# setup the aws cli v2 (latest at time of docker build)
RUN curl -Ls "https://${AWSCLI_URL_BASE}/${AWSCLI_URL_FILE}" -o "awscliv2.zip" \
 && unzip awscliv2.zip \
 && ./aws/install \
 && /usr/local/bin/aws --version

# setup the aws cdk (latest at time of docker build)
RUN npm i -g aws-cdk

# setup kubectl (latest at time of docker build)
RUN curl -sLO https://storage.googleapis.com/kubernetes-release/release/${KUBE_RELEASE_VER}/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# setup the IAM authenticator for aws (for Amazon EKS)
RUN curl -sLo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${IAM_AUTH_VER}/aws-iam-authenticator_${IAM_AUTH_VER}_linux_amd64 \
    && chmod +x ./aws-iam-authenticator \
    && mv ./aws-iam-authenticator /usr/local/bin

# setup Helm (latest at time of docker build)
RUN curl -sLo get_helm.sh https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get \
 && chmod +x get_helm.sh \
 && ./get_helm.sh

# setup eksctl (latest at time of docker build)
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv -v /tmp/eksctl /usr/local/bin

# setup the eksuser tool 
RUN curl -sLo - https://github.com/prabhatsharma/eksuser/releases/download/v${EKSUSER_VER}/eksuser-linux-amd64.zip |bsdtar xf - \
    && chmod +x ./binaries/linux/eksuser \
    && mv ./binaries/linux/eksuser /usr/local/bin/eksuser

# setup kubecfg
RUN curl -sLo kubecfg https://github.com/ksonnet/kubecfg/releases/download/v${KUBECFG_VER}/kubecfg-linux-amd64 \
    && chmod +x kubecfg \
    && mv kubecfg /usr/local/bin/kubecfg

# setup ksonnet 
RUN curl -sLo - https://github.com/ksonnet/ksonnet/releases/download/v${KSONNET_VER}/ks_${KSONNET_VER}_linux_amd64.tar.gz |tar xfz - --strip-components=1 \
   && mv ks /usr/bin/ks

# setup k9s 
RUN curl -sLo - https://github.com/derailed/k9s/releases/download/${K9S_VER}/k9s_${K9S_VER}_Linux_x86_64.tar.gz |tar xfz - \
    && mv k9s /usr/local/bin/k9s 

# setup docker-compose 
RUN curl -sL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose 

# setup Octant
RUN curl -sLo - https://github.com/vmware-tanzu/octant/releases/download/v${OCTANT_VER}/octant_${OCTANT_VER}_Linux-64bit.tar.gz |tar xfz - --strip-components=1 \
 && mv octant /usr/local/bin/octant


# terminal colors with xterm
ENV TERM xterm
# set the zsh theme
ENV ZSH_THEME agnoster

# install oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# install Kubens / Kubectx
RUN curl -sSLO https://github.com/aca/go-kubectx/releases/download/v${GOKUBECTX_VER}/go-kubectx_${GOKUBECTX_VER}_Linux_x86_64.tar.gz \
    && tar zxvf go-kubectx_${GOKUBECTX_VER}_Linux_x86_64.tar.gz \
    && mv kubectx kubens /usr/local/bin/ \
    && rm README.md go-kubectx_${GOKUBECTX_VER}_Linux_x86_64.tar.gz


RUN cd ~/.oh-my-zsh/custom/themes && git clone https://github.com/bhilburn/powerlevel9k.git


RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && yes | ~/.fzf/install

RUN cd ~/.oh-my-zsh/custom/plugins/ \
    && git clone https://github.com/zsh-users/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

##################### INSTALLATION END #####################

RUN useradd -ms /bin/bash $USER_NAME
RUN cp -r ~/.oh-my-zsh /home/$USER_NAME/ \
    && chown -R $USER_NAME:$USER_NAME /home/$USER_NAME
# the user we're applying this too (otherwise it most likely install for root)
USER $USER_NAME
WORKDIR /home/$USER_NAME

COPY .zshrc /root/.zshrc
COPY .zshrc /home/$USER_NAME/.zshrc


CMD ["zsh"]

