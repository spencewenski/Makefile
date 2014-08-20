# compiler
CC = g++
# linker
LD = g++
# compiler flags
CFLAGS = -std=c++11 -Wall -Wextra -pedantic -Wvla -c
# linker flags
LDFLAGS = -pedantic -Wall
# erase files command
RM = rm -f
# list of object files
OBJS = test.o
# list of dependency files
DEPS = $(OBJS:.o=.d)
# executable name
PROG = test

# use quiet output
ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	QUIET_CC       	= @echo '   ' CC $<;
	QUIET_LINK		= @echo '   ' LD $<;
	export V
endif
endif

# top-level rule
all: release
# debug rule
debug: CFLAGS += -g
debug: $(PROG)
# optimize rule
opt: CFLAGS += -O3
opt: release
# uncomment the following line to treat warnings as errors
# release: CFLAGS += -Werror
release: $(PROG)
# gprof rule
gprof: CFLAGS += -g -pg
gprof: $(PROG)
# uncomment the following line to delete object files and .d files automatically
# release: clean

# rule to link program
$(PROG): $(OBJS)
	$(QUIET_LINK)$(LD) $(LDFLAGS) $(OBJS) -o $(PROG)

# rule to compile object files and automatically generate dependency files
%.o: %.cpp
	$(QUIET_CC)$(CC) $(CFLAGS) $< -MMD > $*.d

# include dependency files
-include $(DEPS)

clean:
	$(RM) $(OBJS) $(DEPS)

cleanAll:
	$(RM) $(PROG) $(OBJS) $(DEPS)

cleanObj:
	$(RM) $(OBJS)