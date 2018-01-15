repo_path = ektar

name = jupyter-ldap
ver = $(shell cat VERSION)

ifdef http_proxy
        PROXY=--build-arg http_proxy=$(http_proxy) --build-arg https_proxy=$(http_proxy)
else
        PROXY=
endif

.PHONY: help dbuild dpush

help:
	@echo "dbuild - build docker"
	@echo "dpush - push to public repo"

dbuild: Dockerfile VERSION
	docker build $(PROXY) \
	-t $(repo_path)/$(name):$(ver) -t $(repo_path)/$(name):latest ./

dpush: dbuild
	docker push $(repo_path)/$(name):$(ver)
	docker push $(repo_path)/$(name):latest
