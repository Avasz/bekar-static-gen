SOURCES = $(wildcard src/*.sh) $(wildcard src/*.func)
SUPPORT = AUTHORS LICENSE .version
PKG_NAME = bekar

all: build

# fixing .version path
build: config ${SOURCES}
	mkdir build
	cp -p ${SOURCES} build/
	sed -i 's/\.\.\///g' build/main.sh

unlink:
	rm -f /usr/local/bin/${PKG_NAME}

uninstall: unlink
	rm -rf /opt/${PKG_NAME}

link: config ${SOURCES} ${SUPPORT} unlink
	ln -s "$(PWD)/src/main.sh" /usr/local/bin/${PKG_NAME}

alias: config ${SOURCES} ${SUPPORT}
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

config:
	@echo "first run $ ./configure"

#@echo "erase what ever done by make all, then clean what ever done by ./configure"
distclean: clean
	rm -rf config depend
