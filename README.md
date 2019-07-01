#### What is it?

`eksutils` is a(n experimental) Docker container environment which includes various tools and CLIs aimed at making it easier to consume an existing [Amazon EKS](https://aws.amazon.com/eks/) cluster. 

The [Dockerfile](https://github.com/mreferre/eksutils/blob/master/Dockerfile) for the `eksutils` container is based on an Amazon Linux OS image and it includes:
- the [AWS CLI](https://aws.amazon.com/cli) 
- the [AWS CDK](https://github.com/awslabs/aws-cdk)
- the native `kubectl` [kubernetes client](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- the [IAM Authenticator for AWS](https://github.com/kubernetes-sigs/aws-iam-authenticator)
- the [helm tool](https://github.com/helm/helm)
- the [eksctl tool](https://github.com/weaveworks/eksctl)
- the [eksuser tool](https://github.com/prabhatsharma/eksuser/)
- the [kubecfg tool](https://github.com/ksonnet/kubecfg)
- the [ksonnet tool] (https://github.com/ksonnet/ksonnet)
- the [k9s tool](https://k9ss.io/)
- the VI editor (just in case) 

`eksutils` includes the client side tooling and its dependencies as documented here in the [Amazon EKS Getting Started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html). While this was built specifically for EKS, `eksutils` can also be used as a standard AWS CLI.

#### What's the version of the utilities included?

With exception of the IAM Authenticator and the eksuser util, all the other utilities are installed using the *latest version* available at the time of the docker build. For this reason the date for the build is going to be used as the `tag` for the container image. A few utilities (e.g. the IAM Authenticator) have releases that are fixed and are defined in the [Dockerfile](https://github.com/mreferre/eksutils/blob/master/Dockerfile).

#### How can I use it?

The only pre-requisite for this to work is a Docker runtime. 

You have a few options. They cover common use cases but you can mix and match them based on your own needs.

##### Option #1

`docker run -it --rm mreferre/eksutils:latest`

Use this option if:

*  you want to keep your identities and configurations *inside* the container.
*  you are running the container on a host that isn't configured with AWS credentials or doesn't have a valid `.kube/config`. 

If you use this option you need to make sure you configure your AWS credentials (via `aws configure`) as well as your `.kube/config` (via `aws eks update-kubeconfig --name cluster_name`) before you can start using it. Note that, with this docker setup, the configurations will be lost when we stop the container.  

##### Option #2

`docker run -it --rm -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube mreferre/eksutils:latest` 

Use this option if:

* you want to decouple your identities and configurations from the container. 
* you want to keep your identities and configurations *outside* the container, on your docker host (e.g. your laptop).
* you are running the container on a host that IS configured with AWS credentials and a valid `.kube/config`. 

If the configurations already exist you are good to go. If they do not exist on your host you need to make sure you configure your AWS credentials (via `aws configure`) as well as your `.kube/config` (via `aws eks update-kubeconfig --name cluster_name`) before you can start using it. Note that, with this docker setup, the configurations will be persisted on the docker host when you stop the container. 

##### Option #3

`docker run -it --rm --network host -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube mreferre/eksutils:latest`

Use this option if:

* you want the whole experience of option #2. 
* you want, in addition, the ability to connect to the host network stack (e.g. to proxy to the Kubernetes dashboard).  

##### Option #4  

`docker run -it --rm -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube -v $HOME/environment:/environment mreferre/eksutils:latest` 

Use this option if:

* you want the whole experience of option #2. 
* you want, in addition, the ability to map a local folder into `eksutils` (in this example the Cloud9 environment).

##### Option #5  

`docker run -it --rm -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube -v $HOME/environment:/environment -v /var/run/docker.sock:/var/run/docker.sock mreferre/eksutils:latest` 

Use this option if:

* you want the whole experience of option #4. 
* you want, in addition, the possibility to run DinD (Docker in Docker) for use cases that require running `docker build` (for example).