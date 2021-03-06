# Copyright (c) 2017-2018, NVIDIA CORPORATION. All rights reserved.

DOCKER   ?= docker
MKDIR    ?= mkdir
REGISTRY ?= nvidia/toolkit

GOLANG_VERSION := 1.10.3
VERSION        := 1.0.5
DIST_DIR       := $(CURDIR)/dist

.NOTPARALLEL:
.PHONY: all

all: ubuntu18.04 ubuntu16.04 debian10 debian9 centos7 amzn2 amzn1 opensuse-leap15.1

push%:
	docker push "$(REGISTRY)/$*"

ubuntu%: ARCH := amd64
ubuntu%:
	$(DOCKER) build --pull \
		--build-arg GOLANG_VERSION="$(GOLANG_VERSION)" \
		--build-arg VERSION_ID="$*" \
		--build-arg PKG_VERS="$(VERSION)" \
		--build-arg PKG_REV="1" \
		--tag "$(REGISTRY)/ubuntu$*" \
		--file docker/Dockerfile.ubuntu .
	$(MKDIR) -p $(DIST_DIR)/$@/$(ARCH)
	$(DOCKER) run --cidfile $@.cid "$(REGISTRY)/ubuntu$*"
	$(DOCKER) cp $$(cat $@.cid):/dist/. $(DIST_DIR)/$@/$(ARCH)/
	$(DOCKER) rm $$(cat $@.cid) && rm $@.cid

debian%: ARCH := amd64
debian%:
	$(DOCKER) build --pull \
		--build-arg GOLANG_VERSION="$(GOLANG_VERSION)" \
		--build-arg VERSION_ID="$*" \
		--build-arg PKG_VERS="$(VERSION)" \
		--build-arg PKG_REV="1" \
		--tag "$(REGISTRY)/debian$*" \
		--file docker/Dockerfile.debian .
	$(MKDIR) -p $(DIST_DIR)/$@/$(ARCH)
	$(DOCKER) run --cidfile $@.cid "$(REGISTRY)/debian$*"
	$(DOCKER) cp $$(cat $@.cid):/dist/. $(DIST_DIR)/$@/$(ARCH)/
	$(DOCKER) rm $$(cat $@.cid) && rm $@.cid

centos%: ARCH := x86_64
centos%:
	$(DOCKER) build --pull \
		--build-arg GOLANG_VERSION="$(GOLANG_VERSION)" \
		--build-arg VERSION_ID="$*" \
		--build-arg PKG_VERS="$(VERSION)" \
		--build-arg PKG_REV="2" \
		--tag "$(REGISTRY)/centos$*" \
		--file docker/Dockerfile.centos .
	$(MKDIR) -p $(DIST_DIR)/$@/$(ARCH)
	$(DOCKER) run --cidfile $@.cid "$(REGISTRY)/centos$*"
	$(DOCKER) cp $$(cat $@.cid):/dist/. $(DIST_DIR)/$@/$(ARCH)/
	$(DOCKER) rm $$(cat $@.cid) && rm $@.cid

amzn%: ARCH := x86_64
amzn%:
	$(DOCKER) build --pull \
		--build-arg GOLANG_VERSION="$(GOLANG_VERSION)" \
		--build-arg VERSION_ID="$*" \
		--build-arg PKG_VERS="$(VERSION)" \
		--build-arg PKG_REV="2.amzn$*" \
		--tag "$(REGISTRY)/amzn$*" \
		--file docker/Dockerfile.amzn .
	$(MKDIR) -p $(DIST_DIR)/$@/$(ARCH)
	$(DOCKER) run --cidfile $@.cid "$(REGISTRY)/amzn$*"
	$(DOCKER) cp $$(cat $@.cid):/dist/. $(DIST_DIR)/$@/$(ARCH)/
	$(DOCKER) rm $$(cat $@.cid) && rm $@.cid

opensuse-leap%: ARCH := x86_64
opensuse-leap%:
	$(DOCKER) build --pull \
		--build-arg GOLANG_VERSION="$(GOLANG_VERSION)" \
		--build-arg VERSION_ID="$*" \
		--build-arg PKG_VERS="$(VERSION)" \
		--build-arg PKG_REV="1" \
		--tag "$(REGISTRY)/opensuse-leap$*" \
		--file docker/Dockerfile.opensuse-leap .
	$(MKDIR) -p $(DIST_DIR)/$@/$(ARCH)
	$(DOCKER) run --cidfile $@.cid "$(REGISTRY)/opensuse-leap$*"
	$(DOCKER) cp $$(cat $@.cid):/dist/. $(DIST_DIR)/$@/$(ARCH)/
	$(DOCKER) rm $$(cat $@.cid) && rm $@.cid
