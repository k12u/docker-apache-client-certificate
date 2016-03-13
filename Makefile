IMAGE = kanboard/apache-client-certificate
TAG = latest
CONTAINER = client-certificate

image:
	@ docker build -t $(IMAGE):$(TAG) .

push:
	@ docker push $(IMAGE):$(TAG)

run:
	@ docker run --rm --name $(CONTAINER) -p 443:443 -t $(IMAGE):$(TAG)

destroy:
	@ docker rmi $(IMAGE):$(TAG)

all:
	destroy image push
