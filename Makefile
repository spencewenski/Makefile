# compiler
CC := g++
# linker
LD := g++
# preprocessor flags
CPPFLAGS :=
# main compiler flags
CCFLAGS := -std=c++11 -Wall -Wextra -pedantic -Wvla
# extra compiler flags
ECCFLAGS := 
# main linker flags
LDFLAGS := -pedantic -Wall
# extra linker flags
ELDFLAGS := 
# erase files command
RM := rm -f
# executable name
PROG := a.out
# executables for test cases
# TEST_PROG := $(wildcard test*.out)
TEST_PROG := test.out
# test source files
TEST_SOURCES := $(wildcard test*.c test*.cpp)
# test object files
TEST_OBJS := $(patsubst %.c, %.o, $(filter %.c, $(TEST_SOURCES)))
TEST_OBJS += $(patsubst %.cpp, %.o, $(filter %.cpp, $(TEST_SOURCES)))
# test dependency files
TEST_DEPS = $(TEST_OBJS:%.o=%.d)
# source files
SOURCES := $(wildcard *.c *.cpp)
SOURCES := $(filter-out $(wildcard test*), $(SOURCES))
# pre-compiled object files to link against
LINKEDOBJS := 
# object files for each source file
OBJS := $(patsubst %.c, %.o, $(filter %.c, $(SOURCES)))
OBJS += $(patsubst %.cpp, %.o, $(filter %.cpp, $(SOURCES)))
# all objects except for main.o
OBJS_MINUS_MAIN := $(filter-out main.o, $(OBJS))
# dependency files
DEPS = $(OBJS:%.o=%.d)

# use quiet output
ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	QUIET_CC		= @echo '   ' CC $@;
	QUIET_LINK		= @echo '   ' LD $@;
	export V
endif
endif

# top-level rule
all: $(PROG)
# debug rule
debug: CCFLAGS += -g
debug: $(PROG)
# optimize rule
opt: CCFLAGS += -O3
opt: $(PROG)
# uncomment the following line to treat warnings as errors
release: opt
release: CPPFLAGS += -D NDEBUG
release: $(PROG)
# gprof rule
gprof: CCFLAGS += -g -pg
gprof: $(PROG)
# uncomment the following line to delete object files and .d files automatically
# release: clean
# test rule TODO: support different build types
test: test_build
test: test_run
# build all the tests and then run them
test_build: $(TEST_PROG)
test_run:
	./$(TEST_PROG)

# rule to link program
$(PROG): $(OBJS)
	$(QUIET_LINK)$(LD) $(OBJS) $(LDFLAGS) $(LINKEDOBJS) $(ELDFLAGS) $(CPPFLAGS) -o $(PROG)

$(TEST_PROG): $(OBJS_MINUS_MAIN) $(TEST_OBJS)
	$(QUIET_LINK)$(LD) $(TEST_OBJS) $(OBJS_MINUS_MAIN) $(LINKEDOBJS) $(ELDFLAGS) $(CPPFLAGS) -o $(TEST_PROG)

# rule to compile object files and automatically generate dependency files
define cc-command
	$(QUIET_CC)$(CC) $(CCFLAGS) $(ECCFLAGS) $(CPPFLAGS) -c $< -MMD > $*.d
endef
# compile .c files
.c.o:
	$(cc-command)
# compile .cpp files
.cpp.o:
	$(cc-command)
# compile .cc files
.cc.o:
	$(cc-command)

# include dependency files
-include $(DEPS)
-include $(TEST_DEPS)

# clean up targets
.PHONY: clean cleanAll cleanObj cleanTests
# remove object files and dependency files, but keep the executable
clean:
	$(RM) $(OBJS) $(DEPS)

# remove all generated files
cleanAll: cleanTests
cleanAll:
	$(RM) $(PROG) $(OBJS) $(DEPS)

# only remove the object files
cleanObj:
	$(RM) $(OBJS)

cleanTests:
	$(RM) $(TEST_PROG) $(TEST_OBJS) $(TEST_DEPS) 
