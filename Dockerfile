FROM amazonlinux:2018.03
MAINTAINER massimo@it20.info

################## BEGIN INSTALLATION ######################

########################################
## begin setup runtime pre-requisites ##
########################################

# update the OS
RUN yum update -y 

# setup various utils (latest at time of docker build)
RUN yum install unzip jq vi wget less git which -y  

# setup Node (latest at time of docker build)
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash && export NVM_DIR="/root/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
RUN nvm install 8.11

# setup Typescript (8.11)
RUN npm install -g typescript

# setup pip (latest at time of docker build)
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py

########################################
### end setup runtime pre-requisites ###
########################################

# setup the aws cli (latest at time of docker build)
RUN pip install awscli --upgrade 

# setup the aws cdk (latest at time of docker build)
RUN npm i -g aws-cdk

# setup kubectl (latest at time of docker build)
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# setup the IAM authenticator for aws (for Amazon EKS) (1.10.3)
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x ./aws-iam-authenticator
RUN mv ./aws-iam-authenticator /usr/local/bin

# setup Helm (latest at time of docker build)
RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
RUN chmod +x get_helm.sh
RUN ./get_helm.sh 

# setup eksctl (latest at time of docker build)
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp 
RUN mv -v /tmp/eksctl /usr/local/bin

# setup the eksuser tool (0.1.1)
RUN curl -L -o eksuser-linux-amd64.zip https://github.com/prabhatsharma/eksuser/releases/download/v0.1.1/eksuser-linux-amd64.zip
RUN unzip eksuser-linux-amd64.zip
RUN chmod +x ./binaries/linux/eksuser
RUN mv ./binaries/linux/eksuser /usr/local/bin/eksuser

# setup kubecfg (0.9.1)
RUN curl -L -o kubecfg https://github.com/ksonnet/kubecfg/releases/download/v0.9.1/kubecfg-linux-amd64
RUN chmod +x kubecfg
RUN mv kubecfg /usr/local/bin/kubecfg

# setup k9s (0.3.0)
RUN curl -L -O https://github.com/derailed/k9s/releases/download/0.3.0/k9s_0.3.0_Linux_x86_64.tar.gz
RUN tar -zxvf k9s_0.3.0_Linux_x86_64.tar.gz 
RUN mv k9s /usr/local/bin/k9s 

##################### INSTALLATION END #####################

CMD /bin/sh


