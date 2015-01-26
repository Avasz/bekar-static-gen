SOURCES = $(wildcard src/*.sh)
SUPPORT = AUTHORS LICENSE .version
PKG_NAME = bekar

all: build

build: ${SOURCES}
	mkdir build
	cp -p ${SOURCES} build/
	sed -i '/^trap.*ERR/d' build/*.sh
	sed -i 's/\.\.\///g' build/main.sh

unlink:
	rm -f /usr/local/bin/${PKG_NAME}

uninstall: unlink
	rm -rf /opt/${PKG_NAME}

link: ${SOURCES} ${SUPPORT} unlink
	ln -s "$(PWD)/src/main.sh" /usr/local/bin/${PKG_NAME}

alias: ${SOURCES} ${SUPPORT}
	@echo "add alias into '.bashrc' by adding ..."
	@echo "    alias ${PKG_NAME}='$PWD/main.sh'"

install: build ${SUPPORT} unlink uninstall
	mkdir -p /opt/${PKG_NAME}
	cd build; install -m 755 * -t /opt/${PKG_NAME}/
	cp ${SUPPORT} /opt/${PKG_NAME}/
	ln -s /opt/${PKG_NAME}/main.sh /usr/local/bin/${PKG_NAME}

clean:
	rm -rf build

dist: build
	@echo "create PACKAGE-VERSION.tar.gz"

distclean: clean
	#@echo "erase what ever done by make all, then clean what ever done by ./configure"
