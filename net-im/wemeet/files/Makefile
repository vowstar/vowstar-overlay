TARGET_LIB := libQWidgetFix.so

CFLAGS := -fPIC -Wall -Wextra -O2 -g -D_GNU_SOURCE
CPPFLAGS := -fPIC -Wall -Wextra -O2 -g -D_GNU_SOURCE
LDFLAGS := -shared -ldl

RM := rm -f

C_SRCS := $(wildcard *.c)
CPP_SRCS := $(wildcard *.cpp)
OBJS += $(patsubst %.c, %.o, $(notdir $(C_SRCS)))
OBJS += $(patsubst %.cpp, %.o, $(notdir $(CPP_SRCS)))

.PHONY: all
all: ${TARGET_LIB}

$(TARGET_LIB): $(OBJS)
	$(CC) ${LDFLAGS} -o ./$@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.cpp
	$(CXX) $(CPPFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	-${RM} ${TARGET_LIB} ${OBJS} $(C_SRCS:.c=.d) $(CPP_SRCS:.cpp=.d)
