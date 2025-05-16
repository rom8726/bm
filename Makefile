APP_NAME = bm
APP_NAME_BIN = bm-util
VERSION = 0.1.0
ARCH = amd64
BUILD_DIR = target/release
PKG_DIR = $(APP_NAME)_$(VERSION)
DEB_FILE = $(PKG_DIR).deb

all: deb

build:
	cargo build --release

prepare: build
	rm -rf $(PKG_DIR)
	mkdir -p $(PKG_DIR)/DEBIAN
	mkdir -p $(PKG_DIR)/usr/bin
	mkdir -p $(PKG_DIR)/etc/profile.d

	cp $(BUILD_DIR)/$(APP_NAME_BIN) $(PKG_DIR)/usr/bin/$(APP_NAME_BIN)

	echo "Package: $(APP_NAME)" > $(PKG_DIR)/DEBIAN/control
	echo "Version: $(VERSION)" >> $(PKG_DIR)/DEBIAN/control
	echo "Section: utils" >> $(PKG_DIR)/DEBIAN/control
	echo "Priority: optional" >> $(PKG_DIR)/DEBIAN/control
	echo "Architecture: $(ARCH)" >> $(PKG_DIR)/DEBIAN/control
	echo "Maintainer: Roman Chudov <roman.chudov@gmail.com>" >> $(PKG_DIR)/DEBIAN/control
	echo "Description: Simple bookmark tool for navigating the file system" >> $(PKG_DIR)/DEBIAN/control

	echo '#!/bin/sh' > $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo 'bm() {' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '  if [ "$$1" = "-s" ]; then' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '    command bm-util save "$$2"' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '  elif [ "$$1" = "-d" ]; then' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '    command bm-util delete "$$2"' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '  elif [ "$$1" = "-l" ]; then' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '    command bm-util list' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '  else' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '    cd "$$(command bm-util go "$$1")"' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '  fi' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh
	echo '}' >> $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh

	chmod +x $(PKG_DIR)/etc/profile.d/$(APP_NAME).sh

	echo '#!/bin/sh' > $(PKG_DIR)/DEBIAN/postinst
	echo 'chmod +x /etc/profile.d/$(APP_NAME).sh' >> $(PKG_DIR)/DEBIAN/postinst
	echo 'echo "✅ Installed. Please, run: source /etc/profile.d/$(APP_NAME).sh"' >> $(PKG_DIR)/DEBIAN/postinst
	chmod +x $(PKG_DIR)/DEBIAN/postinst

deb: prepare
	dpkg-deb --build $(PKG_DIR)

clean:
	rm -rf $(PKG_DIR) $(DEB_FILE)

install: deb
	sudo dpkg -i $(DEB_FILE)
	sudo chmod +x /etc/profile.d/$(APP_NAME).sh
	@echo "✅ Installed. Please, run: source /etc/profile.d/$(APP_NAME).sh"

.PHONY: all build prepare deb clean install
