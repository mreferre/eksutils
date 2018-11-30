FROM amazonlinux:2018.03
MAINTAINER massimo@it20.info

################## BEGIN INSTALLATION ######################

# update the OS
RUN yum update -y 

# setup unzip 
RUN yum install unzip -y  

# setup vi editor (just in case)
RUN yum install vi -y  

# setup pip 
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py

# setup the aws cli (latest at time of docker build)
RUN pip install awscli --upgrade 
RUN pip install awscli

# setup kubectl (latest at time of docker build)
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# setup the heptio authenticator for aws (for Amazon EKS)
RUN curl -o heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/bin/linux/amd64/heptio-authenticator-aws
RUN chmod +x ./heptio-authenticator-aws
RUN mv ./heptio-authenticator-aws /usr/local/bin

# setup the eksuser tool
RUN curl -L -o eksuser-linux-amd64.zip https://github.com/prabhatsharma/eksuser/releases/download/v0.1.0/eksuser-linux-amd64.zip
RUN unzip eksuser-linux-amd64.zip
RUN chmod +x ./binaries/linux/eksuser
RUN mv ./binaries/linux/eksuser /usr/local/bin/eksuser


##################### INSTALLATION END #####################

CMD /bin/sh


