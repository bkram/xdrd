CC = gcc
CFLAGS = -Wall -pedantic -std=c99 -c -O2
LIBS = -lpthread -lcrypto
LIBS_WIN = $(LIBS) -lws2_32
INSTALL = install -c
TARGET = xdrd

PREFIX = $(DESTDIR)/usr
BINDIR = $(PREFIX)/bin

xdrd:	xdrd.o
	$(CC) -o $(TARGET) xdrd.o $(LIBS)

.PHONY:	windows
windows:	xdrd.o
	$(CC) -o $(TARGET) xdrd.o $(LIBS_WIN)

xdrd.o: xdrd.c xdr-protocol.h
	$(CC) $(CFLAGS) xdrd.c

.PHONY: macOS
macOS: xdrd_x86_64 xdrd_arm64
	lipo -create -output $(TARGET) xdrd_x86_64 xdrd_arm64

xdrd_x86_64: xdrd.c xdr-protocol.h
	$(CC) -arch x86_64 $(CFLAGS) -o xdrd_x86_64 xdrd.c $(LIBS)

xdrd_arm64: xdrd.c xdr-protocol.h
	$(CC) -arch arm64 $(CFLAGS) -o xdrd_arm64 xdrd.c $(LIBS)

.PHONY:	clean
clean:
	rm -f *.o $(TARGET) xdrd_x86_64 xdrd_arm64

.PHONY:	install
install:	xdrd
	$(INSTALL) $(TARGET) $(BINDIR)/$(TARGET)

.PHONY:	uninstall
uninstall:
	rm -f $(BINDIR)/$(TARGET)
