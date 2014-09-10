# compiler
CC := g++
# linker
LD := g++
# main compiler flags
CFLAGS := -std=c++11 -Wall -Wextra -pedantic -Wvla
# extra compiler flags
ECFLAGS :=
# main linker flags
LDFLAGS := -pedantic -Wall
# extra linker flags
ELDFLAGS :=
# erase files command
RM := rm -f
# executable name
PROG := a.out
# source files
SOURCES := $(wildcard *.c *.cpp *.cc)
# pre-compiled object files to link against
LINKEDOBJS :=
# object files for each source file
OBJS := $(patsubst %.c, %.o, $(filter %.c, $(SOURCES)))
OBJS += $(patsubst %.cpp, %.o, $(filter %.cpp, $(SOURCES)))
OBJS += $(patsubst %.cc, %.o, $(filter %.cc, $(SOURCES)))
# dependency files
DEPS = $(OBJS:%.o=%.d)

# use quiet output
ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	QUIET_CC		= @echo '   ' CC $<;
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
	$(QUIET_LINK)$(LD) $(LINKEDOBJS) $(OBJS) $(LDFLAGS) $(ELDFLAGS) -o $(PROG)

# rule to compile object files and automatically generate dependency files
COMPILE = $(QUIET_CC)$(CC) $(CFLAGS) $(ECFLAGS) -c $< -MMD > $*.d
# compile .c files
.c.o:
	$(COMPILE)
# compile .cpp files
.cpp.o:
	$(COMPILE)
# compile .cc files
.cc.o:
	$(COMPILE)

# include dependency files
-include $(DEPS)

.PHONY: clean
clean:
	$(RM) $(OBJS) $(DEPS)

.PHONY: cleanAll
cleanAll:
	$(RM) $(PROG) $(OBJS) $(DEPS)

.PHONY: cleanObj
cleanObj:
	$(RM) $(OBJS)