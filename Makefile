CC=g++
CFLAGS=-c -g -O0 -Iinclude -Wall -Wextra
LDFLAGS=-lpthread

TARGET = udtcat
PREFIX = $(DESTDIR)/usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1
MANFILE= $(TARGET).1

all: $(TARGET)

$(TARGET): udt-wrapper.o udtcat.o libudt.a
	#$(CC) $(LDFLAGS) udt-wrapper.o udtcat.o -o udtcat
	g++ -lpthread udt-wrapper.o udtcat.o -o udtcat /root/udt/udt4/src/libudt.a -I/root/udtcat/udt-src

libudt.a:
	cd /root/udt/udt4/src/ && make
	cd /root/udt/udt4/src/ && cp libudt.a /root/udtcat

udt-wrapper.o: udt-wrapper.cpp
	$(CC) $(CFLAGS)  udt-wrapper.cpp -I/root/udtcat/udt-src

udtcat.o: udtcat.c
	$(CC) $(CFLAGS)  udtcat.c

install:
	install -D $(TARGET) $(BINDIR)/$(TARGET)
	install -D $(MANFILE) $(MANDIR)

install-strip:
	install -D -s $(TARGET) $(BINDIR)/$(TARGET)
	install -D $(MANFILE) $(MANDIR) 

uninstall:
	-rm -f $(BINDIR)/$(TARGET) $(MANDIR)/$(MANFILE)

clean:
	-rm -rf *.o *.a $(TARGET)
	cd /root/udt/udt4/src/ && make clean

.PHONY : all clean install install-strip uninstall
