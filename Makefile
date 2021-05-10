TAG := latest

PORT = 8080

build_app:
	docker build -t tombeynon/pinkash:$(TAG) -f Dockerfile .

build_scheduler:
	docker build -t tombeynon/pinkash-scheduler:$(TAG) -f Dockerfile-scheduler .

push_app:
	docker push tombeynon/pinkash:$(TAG)

push_scheduler:
	docker push tombeynon/pinkash-scheduler:$(TAG)

release_app:
	make build_app
	make push_app

release_scheduler:
	make build_scheduler
	make push_scheduler

release:
	make release_app
	make release_scheduler
