RELEASE_TAG := v$(shell date +%Y%m%d-%H%M%S-%3N)

build:
	docker build -t galexrt/gameserver:latest .

release:
	git tag $(RELEASE_TAG)
	git push origin $(RELEASE_TAG)

