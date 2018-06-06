#### What is it?

`eksutils` is a(n experimental) Docker container environment which includes various tools and CLIs aimed at making it easier to consume an existing [Amazon EKS](https://aws.amazon.com/eks/) cluster. 

The [Dockerfile](https://github.com/mreferre/eksutils/blob/master/Dockerfile) for the `eksutils` container is based on an Amazon Linux OS image and it includes:
- the [AWS CLI](https://aws.amazon.com/cli) 
- the native `kubectl` [kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- the [Heptio Authenticator for AWS](https://github.com/heptio/authenticator)
- the VI editor (just in case) 

`eksutils` includes the client side tooling and its dependencies as documented here in the [Amazon EKS Getting Started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html). While this was built specifically for EKS, `eksutils` can also be used as a standard AWS CLI.

#### What's the version of the utilities included?

With exception of the Heptio Authenticator, all the other utilities are installed using the *latest version* available at the time of docker build time. For this reason the date for the build is going to be used as the `tag` for the container image. The Heptio Authenticator version instead is hard wired in the [Dockerfile](https://github.com/mreferre/eksutils/blob/master/Dockerfile).

The latest container build has a tag of `06-may-2018` and this is the current version of the tools included:
- AWS CLI: `aws-cli/1.15.33 Python/2.7.14 Linux/4.9.87-linuxkit-aufs botocore/1.10.33`
- kubectl: `v1.10.4`
- Heptio Authenticator: `2018-06-05` 

#### How can I use it?

The only pre-requisite for this to work is a Docker runtime. 

If you want to host your configuration files inside the container you can start the image using the following syntax:
`docker run -it mreferre/eksutils:latest` 
This is useful if you want to keep your identities and configurations *inside* the container.   

If you want to host your configuration files inside the container you can start the image using the following syntax:
`docker run -it -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube mreferre/eksutils:latest` 
This is useful if you want to decouple your identities and configurations from the container; start the container with this syntax if you want to keep your identities and configurations *outside* the container, on your docker host (e.g. your laptop).     

From there you can follow the [Amazon EKS Getting Started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html) and configure both the AWS CLI as well as the Kubernetes config file. 

