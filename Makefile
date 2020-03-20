

all: build push

build:
	docker build -t allamand/eksutils .

push:
	docker push allamand/eksutils
