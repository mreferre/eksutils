FROM amazonlinux:2018.03
MAINTAINER massimo@it20.info

################## BEGIN INSTALLATION ######################

# update the OS
RUN yum update -y 

# setup various utils
RUN yum install unzip jq vi less -y  

# setup pip 
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py

# setup the aws cli (latest at time of docker build)
RUN pip install awscli --upgrade 

# setup kubectl (latest at time of docker build)
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# setup the IAM authenticator for aws (for Amazon EKS)
RUN curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator
RUN chmod +x ./aws-iam-authenticator
RUN mv ./aws-iam-authenticator /usr/local/bin

# setup eksctl (latest at time of docker build)
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp 
RUN mv -v /tmp/eksctl /usr/local/bin

# setup the eksuser tool
RUN curl -L -o eksuser-linux-amd64.zip https://github.com/prabhatsharma/eksuser/releases/download/v0.1.0/eksuser-linux-amd64.zip
RUN unzip eksuser-linux-amd64.zip
RUN chmod +x ./binaries/linux/eksuser
RUN mv ./binaries/linux/eksuser /usr/local/bin/eksuser

##################### INSTALLATION END #####################

CMD /bin/sh


