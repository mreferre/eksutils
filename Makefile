

all: build push

build:
	docker build -t allamand/eksutils .

push:
	docker push allamand/eksutils


run:
	docker run -it --rm -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube allamand/eksutils:latest
	docker run -it --rm --network host -v $HOME/.aws:/root/.aws -v $HOME/.kube:/root/.kube allamand/eksutils:latest`
