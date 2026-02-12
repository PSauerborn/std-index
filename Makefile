cpu_arch ?= $(shell uname -m)

# Map cpu_arch to docker platform
ifeq ($(cpu_arch),x86_64)
	platform := linux/amd64
else ifeq ($(cpu_arch),amd64)
	platform := linux/amd64
else ifeq ($(cpu_arch),aarch64)
	platform := linux/arm64
else ifeq ($(cpu_arch),arm64)
	platform := linux/arm64
else
	platform := linux/amd64
endif

working_dir ?= $(shell pwd)

.PHONY: run-ci-image
run-ci-image: build-ci-image
	docker run --rm \
		-e CPU_ARCH=$(cpu_arch) \
		-v ${working_dir}/bin:/build/bin \
		std-index-ci

.PHONY: build-ci-image
build-ci-image: run-test-image
	docker build --target build \
		--platform $(platform) \
		-t std-index-ci \
		-f Dockerfile \
		.

.PHONY: run-test-image
run-test-image: build-test-image
	docker run --rm std-index-test

.PHONY: build-test-image
build-test-image:
	docker build --target tests \
		-t std-index-test \
		-f Dockerfile .

.PHONY: scan-secrets
scan-secrets:
	detect-secrets scan \
		--exclude-files '^tests/.*' \
		> .secrets.baseline
	detect-secrets audit .secrets.baseline
