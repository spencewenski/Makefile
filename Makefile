# compiler
CC = g++
# linker
LD = g++
# warning flags
WFLAGS = -Wall -Wextra -pedantic -Wvla
# compiler flags
CFLAGS = -std=c++11
# linker flags
LDFLAGS = $(CFLAGS)
# erase files command
RM = rm
# list of object files
OBJS = main.o
# list of dependency files
DEPS = $(OBJS:.o=.d)
# executable name
PROG = test

# top-level rule
all: release
# debug rule
debug: CFLAGS += -g
debug: $(PROG)
# release rule
release: CFLAGS += -O3
release: CFLAGS += $(WFLAGS)
release: $(PROG)
# gprof rule
gprof: CFLAGS += -g -pg
gprof: $(PROG)
# uncomment the following line to delete object files automatically
# release: cleanObj

# rule to link program
$(PROG): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $(PROG)

# rule to compile object files and automatically generate dependency files
%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -MMD > $*.d

# include dependency files
-include $(DEPS)

clean:
	$(RM) $(PROG) $(OBJS) $(DEPS)

cleanObj:
	$(RM) $(OBJS)