build:
	docker build -t nicks/addmount .

start: build
	docker run -d --name addmount -p 8080:8080 --privileged --pid=host --rm -v /var/run/docker.sock:/var/run/docker.sock nicks/addmount

stop:
	docker rm --force addmount

push: build
	docker push nicks/addmount
