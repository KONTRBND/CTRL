UID := $(shell id -u)
GID := $(shell id -g)

.PHONY: firmware
firmware:
	docker run \
		--rm \
		-v "$(PWD):/work" \
		--user $(UID):$(GID) \
		zmkfirmware/zmk-build-arm:4.1-branch \
		/work/build-firmware.sh

.PHONY: clean
clean:
	rm -rf build/

.PHONY: clean-all
clean-all:
	rm -rf .west build modules zephyr zmk
