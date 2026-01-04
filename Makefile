UID := $(shell id -u)
GID := $(shell id -g)
CACHE_DIR := $(PWD)/.cache/
CACHE_ZMK_CONFIG := $(CACHE_DIR)/zmk-config

.PHONY: firmware
firmware:
	mkdir -p "$(CACHE_ZMK_CONFIG)"
	docker run \
		--rm \
		-v "$(PWD):/work" \
		-v "$(CACHE_ZMK_CONFIG):/tmp/zmk-config" \
		--user $(UID):$(GID) \
		zmkfirmware/zmk-build-arm:4.1-branch \
		/work/build-firmware.sh

.PHONY: clean
clean:
	rm -rf build/ $(CACHE_DIR)/config

.PHONY: clean-cache
clean-cache:
	rm -rf $(CACHE_DIR)
