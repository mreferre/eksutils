#### What is it?

`eksutils` is a(n experimental) Docker container environment which includes various tools and CLIs aimed at making it easier to consume an existing [Amazon EKS](https://aws.amazon.com/eks/) cluster. 

The [Dockerfile](https://github.com/mreferre/eksutils/blob/master/Dockerfile) for the `eksutils` container is based on an Amazon Linux OS image and it includes:
- the [AWS CLI](https://aws.amazon.com/cli) 
- the native `kubectl` [kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- the [IAM Authenticator for AWS](https://github.com/kubernetes-sigs/aws-iam-authenticator)
- the [eksuser tool](https://github.com/prabhatsharma/eksuser/blob/master/README.md)
- the VI editor (just in case) 

`eksutils` includes the client side tooling and its dependencies as documented here in the [Amazon EKS Getting Started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html). While this was built specifically for EKS, `eksutils` can also be used as a standard AWS CLI.

#### What's the version of the utilities included?

With exception of the IAM Authenticator and the eksuser util, all the other utilities are installed using the *latest version* available at the time of the docker build. For this reason the date for the build is going to be used as the `tag` for the container image. The IAM Authenticator version instead is hard wired in the [Dockerfile](https://github.com/mreferre/eksutils/blob/master/Dockerfile).

The latest container build has a tag of `06-may-2018` and this is the current version of the tools included:
- AWS CLI: `aws-cli/1.16.67 Python/2.7.14 Linux/4.14.70-67.55.amzn1.x86_64 botocore/1.12.57`
- kubectl: `v1.12.3`
- IAM Authenticator for AWS: `2018-07-26` 
- eksuser: `0.1.0`

#### How can I use it?

The only pre-requisite for this to work is a Docker runtime. 

You have a couple of options. 

##### Option #1

`docker run -it mreferre/eksutils:latest`

Use this option if:

*  you want to keep your identities and configurations *inside* the container.
*  you are running the container on a host that isn't configured with AWS credentials or doesn't have a valid `.kube/config`. 

If you use this option you need to make sure you configure your AWS credentials (via `aws configure`) as well as your `.kube/config` (via `aws eks update-kubeconfig --name cluster_name`) before you can start using it. Note that, with this docker setup, the configurations will be lost when we stop the container.  

##### Option #2

`docker run -it -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube mreferre/eksutils:latest` 

Use this option if:

* you want to decouple your identities and configurations from the container. 
* you want to keep your identities and configurations *outside* the container, on your docker host (e.g. your laptop).
* you are running the container on a host that IS configured with AWS credentials and a valid `.kube/config`. 

If the configurations already exist you are good to go. If they do not exist on your host you need to make sure you configure your AWS credentials (via `aws configure`) as well as your `.kube/config` (via `aws eks update-kubeconfig --name cluster_name`) before you can start using it. Note that, with this docker setup, the configurations will be persisted on the docker host when you stop the container. 

