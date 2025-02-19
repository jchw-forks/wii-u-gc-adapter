CFLAGS  += -Wall -Wextra -pedantic -std=c99 $(shell pkg-config --cflags libusb-1.0 udev)
LDFLAGS += -lpthread -ludev $(shell pkg-config --libs libusb-1.0 udev)

ifeq ($(DEBUG), 1)
	CFLAGS += -O0 -g
	LDFLAGS += -g
else
	CFLAGS += -O2
	LDFLAGS += -s
endif

TARGET = wii-u-gc-adapter
OBJS = wii-u-gc-adapter.o

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

all: $(TARGET)

clean:
	rm -f $(TARGET)
	rm -f $(OBJS)

.PHONY: all clean
