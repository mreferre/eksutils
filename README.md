#### What is it?

`eksutils` is a(n experimental) container shell environment which includes various tools and CLIs aimed at making it easier to consume an existing [Amazon EKS](https://aws.amazon.com/eks/) cluster. Note the utility today contains client tools that go beyond mere EKS and has evolved to support other container orchestrators (e.g. ECS), container runtimes (e.g. Docker) and the AWS platform in general (e.g. CDK).

The [Dockerfile](https://github.com/mreferre/eksutils/blob/master/Dockerfile) for the `eksutils` container is based on an Amazon Linux OS image and it includes the following tools and utilities:
- [Oh My Zsh](https://ohmyz.sh/) 
- [AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) 
- [AWS CDK](https://github.com/awslabs/aws-cdk)
- [CDK8s](https://cdk8s.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [IAM Authenticator for AWS](https://github.com/kubernetes-sigs/aws-iam-authenticator)
- [helm version 3](https://github.com/helm/helm)
- [eksctl](https://github.com/weaveworks/eksctl)
- [eksuser](https://github.com/prabhatsharma/eksuser/)
- [kubecfg](https://github.com/ksonnet/kubecfg)
- [ksonnet](https://github.com/ksonnet/ksonnet)
- [k9s](https://k9ss.io/)
- [docker](https://docs.docker.com/engine/)
- [docker-compose](https://docs.docker.com/compose/)
- [docker-ecs](https://docs.docker.com/engine/context/ecs-integration/)
- [kind](https://kind.sigs.k8s.io/)
- [Octant](https://github.com/vmware-tanzu/octant)
- [glooctl](https://docs.solo.io/gloo/latest/)
- [kubectx](https://github.com/ahmetb/kubectx/)
- [kubens](https://github.com/ahmetb/kubectx/)
- [bat](https://github.com/sharkdp/bat/)
- [VS Code server](https://github.com/cdr/code-server)
- additional utils: unzip, jq, vi, wget, less, git, which and httpd-tools (and more, just in case) 

`eksutils` includes the client side tooling and its dependencies as documented here in the [Amazon EKS Getting Started guide](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html). While this was built specifically for EKS, `eksutils` can also be used as a standard AWS CLI.

#### What's the version of the utilities included?

The way it works right now is that most utils are installed at a specific version driven by the variables set at the beginning of the Dockerfile. 

The tool has not yet landed on a final strategy though. An alternative approach would be to grab the latest versions of the utilities at every build by querying `releases/latest` in each repo and downloaded the latest release of the binary.  

The container image now ships with a script called `utilsversions.sh` that prints, when possible, the versions of the tools and utilities available in the container. You can run the script interactively at any point when you are inside the container by launching `/utilsversions.sh` or you can print it by running the following command:
```
docker run --rm mreferre/eksutils:latest /utilsversions.sh
```

#### How can I use it?

The only pre-requisite for this to work is a Docker runtime. 

You have a few options. They cover common use cases but you can mix and match them based on your own needs. Have also a look at the `Scenarios` section below. 

A note on the shell: all options listed are interactive and, by default, they use `/bin/sh`. Recently `Oh My Zsh` has been added to the image and you can, experimentally, override the the shell command by using `/usr/bin/zsh` (or start the shell once you run the container).

##### Option #1
```
docker run -it --rm mreferre/eksutils:latest
```
Use this option if:

*  you want to keep your identities and configurations *inside* the container.
*  you are running the container on a host that isn't configured with AWS credentials or doesn't have a valid `.kube/config`. 

If you use this option you need to make sure you configure your AWS credentials (via `aws configure`) as well as your `.kube/config` (via `aws eks update-kubeconfig --name cluster_name`) before you can start using it. Note that, with this docker setup, the configurations will be lost when we stop the container.  

##### Option #2
```
docker run -it --rm -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube mreferre/eksutils:latest` 
```
Use this option if:

* you want to decouple your identities and configurations from the container. 
* you want to keep your identities and configurations *outside* the container, on your docker host.
* you are running the container on a host that IS configured with AWS credentials and a valid `.kube/config`. 

If the configurations already exist you are good to go. If they do not exist on your host you need to make sure you configure your AWS credentials (via `aws configure`) as well as your `.kube/config` (via `aws eks update-kubeconfig --name cluster_name`) before you can start using it. Note that, with this docker setup, the configurations will be persisted on the docker host when you stop the container. 

##### Option #3
```
docker run -it --rm --network host -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube mreferre/eksutils:latest`
```
Use this option if:

* you want the whole experience of option #2. 
* you want, in addition, the ability to connect to the host network stack.  

##### Option #4  
```
docker run -it --rm --network host -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube -v $HOME/myfolder:/myfolder mreferre/eksutils:latest
```
Use this option if:

* you want the whole experience of option #3. 
* you want, in addition, the ability to map a local folder into `eksutils`.

##### Option #5  
```
docker run -it --rm --network host -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube -v $HOME/environment:/environment -v /var/run/docker.sock:/var/run/docker.sock mreferre/eksutils:latest` 
```
Use this option if:

* you want the whole experience of option #4. 
* you want, in addition, the possibility to run DinD (Docker in Docker) for use cases that require running `docker build` (for example).

#### Scenarios

The above options are raw capabilities. Hereafter I am going to discuss how I am using `eksutils` with different client scenarios. 

##### Cloud9 

99 out 100 times I use `eksutils` in my [Cloud9](https://aws.amazon.com/cloud9/) environment. This is because I usually deploy in different regions and the AWS backbone is faster than my ADSL to each of those regions. Also the Internet bandwidth is "slightly" better.  
I typically disable the Cloud9 [temporary managed credentials](https://docs.aws.amazon.com/cloud9/latest/user-guide/auth-and-access-control.html#auth-and-access-control-temporary-managed-credentials) and I instead assign manually an IAM role to the EC2 instance backing my environment. I also like to map the "environment" folder in my `eksutils` container. I like to map the `.kube` folder to persist my eks cluster configurations and pointers and I also map the `.aws` folder. Given I am using IAM roles assigned to the instance I only use this to map the REGION (which I have previously configured once with the `aws configure` command).  
```
docker run -it --rm --network host -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube -v $HOME/environment:/environment mreferre/eksutils:latest
```
Note I am using the `--network host` flag. This is due the fact that AWS [made changes](https://aws.amazon.com/blogs/security/defense-in-depth-open-firewalls-reverse-proxies-ssrf-vulnerabilities-ec2-instance-metadata-service/) to the Instance Metadata Service (IMDSv2) that prevent some operations to work behind a NAT. This flag puts you directly on the Cloud9 instance host network. This also allows the user to pre-view applications (e.g. `kubectl proxy`, Octant, etc.) without having to expose these services via port mapping. Just keep in mind how [previewing applications on Cloud9 works](https://docs.aws.amazon.com/cloud9/latest/user-guide/app-preview.html). It's actually quite cool and useful once you "own" it. 

##### MacOS 

I rarely use `eksutils` from my Mac laptop but sometimes I do. When I do it, this is how I start it:
```
docker run -it --rm -p 8080:8080 -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube mreferre/eksutils:latest`
```
Note I map the `.aws` directory and the `.kube` directory here too. In this case mapping the `.aws` direcory is useful if you intend to save your IAM credentials with `aws configure`. If you don't and you prefer to only enter them ephimerally every time `eksutils` is launched then omit that mapping. It's more work but definitely more secured. I don't usually map other directories but it's definitely an option. Note also that MacOS doesn't support `--network host` so I start it by mapping the port 8080 (in case I want to start `kubectl proxy`, Octant, VS Code server or any other service). 

##### Linux

For the most part this would be similar to the Cloud9 scenario. The exception may be that you may want to avoid using the `--network host` flag and instead exporting a specific port (e.g. 8080). 

##### Windows

Feel free to contribute here if you have a pattern that works for you.
