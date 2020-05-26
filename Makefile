
TAG=riscv-gnu-toolchain

build_shell:
	docker build -t ${TAG}_shell -f Dockerfile.build .

run_shell:
	docker run --rm -it -v ${RISCV_REPO}:/riscv-gnu-toolchain ${TAG}_shell bash

run_shell_runtime:
	docker run --rm -it -v ${RISCV_REPO}:/riscv-gnu-toolchain ubuntu:20.04 bash

build:
	docker build -t ${TAG} .