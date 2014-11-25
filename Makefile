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
TEST_EXEC := $(wildcard test*.out)
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

# rule to link program
$(PROG): $(OBJS)
	$(QUIET_LINK)$(LD) $(OBJS) $(LDFLAGS) $(LINKEDOBJS) $(ELDFLAGS) $(CPPFLAGS) -o $(PROG)

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
	$(RM) $(OBJS) $(OBJS_TESTS)

cleanTests:
	$(RM) $(OBJS_TESTS) $(TEST_EXEC) $(wildcard *.output)

# tests
# .PHONY: test_name
# test_name: $(OBJS_MINUS_MAIN)
# 	$(QUIET_CC)$(CC) $(CCFLAGS) $(ECCFLAGS) test_name.cpp $(OBJS_MINUS_MAIN) $(LINKEDOBJS) $(ELDFLAGS) -o test_name.out

# compile tests
# .PHONY: compile_tests
# compile_tests: test_name

# generate expected output for tests
# .PHONY: test_get_expected_output
# test_get_expected_output:
# 	./test_name.out > test_name.expected

# .PHONY: run_tests
# run_tests: compile_tests
# run_tests:
# 	./test_name.out > test_name.output
# 	diff test_name.output test_name.expected
