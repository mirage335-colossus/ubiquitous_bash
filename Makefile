MKDIR_P = mkdir -p
DESTDIR ?= /

all:

directories:
	${MKDIR_P} $(DESTDIR)usr/bin/

install: directories

	install -Dm755 ubiquitous_bash.sh $(DESTDIR)usr/bin/ubiquitous_bash.sh