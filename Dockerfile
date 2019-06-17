FROM amazonlinux:2018.03
MAINTAINER massimo@it20.info

################## BEGIN INSTALLATION ######################

########################################
## begin setup runtime pre-requisites ##
########################################

# update the OS
RUN yum update -y 

# setup various utils (latest at time of docker build)
# docker is being installed to support DinD scenarios (e.g. for being able to build)
RUN yum install unzip jq vi wget less git which docker -y  

# setup Node (8.11)
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.11.3
WORKDIR $NVM_DIR
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# setup Typescript (latest at time of docker build)
RUN npm install -g typescript

# setup pip (latest at time of docker build)
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \ 
   && python get-pip.py

########################################
### end setup runtime pre-requisites ###
########################################

# setup the aws cli (latest at time of docker build)
RUN pip install awscli --upgrade 

# setup the aws cdk (latest at time of docker build)
RUN npm i -g aws-cdk

# setup kubectl (latest at time of docker build)
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

# setup the IAM authenticator for aws (for Amazon EKS) (0.4.0)
RUN curl -L -o aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.4.0/aws-iam-authenticator_0.4.0_linux_amd64 \
    && chmod +x ./aws-iam-authenticator \
    && mv ./aws-iam-authenticator /usr/local/bin

# setup Helm (latest at time of docker build)
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
RUN chmod +x get_helm.sh \
    && ./get_helm.sh 

# setup eksctl (latest at time of docker build)
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp \
    && mv -v /tmp/eksctl /usr/local/bin

# setup the eksuser tool (0.1.1)
RUN curl -L -o eksuser-linux-amd64.zip https://github.com/prabhatsharma/eksuser/releases/download/v0.1.1/eksuser-linux-amd64.zip \
    && unzip eksuser-linux-amd64.zip \
    && chmod +x ./binaries/linux/eksuser \
    && mv ./binaries/linux/eksuser /usr/local/bin/eksuser

# setup kubecfg (0.9.1)
RUN curl -L -o kubecfg https://github.com/ksonnet/kubecfg/releases/download/v0.9.1/kubecfg-linux-amd64 \
    && chmod +x kubecfg \
    && mv kubecfg /usr/local/bin/kubecfg

# setup k9s (0.3.0)
RUN curl -L -O https://github.com/derailed/k9s/releases/download/0.3.0/k9s_0.3.0_Linux_x86_64.tar.gz \
    && tar -zxvf k9s_0.3.0_Linux_x86_64.tar.gz \
    && mv k9s /usr/local/bin/k9s 

##################### INSTALLATION END #####################

WORKDIR /

CMD /bin/sh

