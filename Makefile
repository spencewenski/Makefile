# compiler
CXX ?= g++
# linker
LD ?= g++
# preprocessor flags
CPPFLAGS :=
# main compiler flags
CXXFLAGS := -std=c++11 -Wall -Wextra -pedantic -Wvla
# extra compiler flags
EXXFLAGS :=
# code coverage compile flags
CODE_COVERAGE_CXX_FLAGS :=
# main linker flags
LDFLAGS :=
# extra linker flags
ELDFLAGS :=
# code coverage linker flags
CODE_COVERAGE_LD_FLAGS :=
# libraries
LIBS :=
# erase files command
RM := rm -f

# test executable
TEST_PROG := test.out
# test source files
TEST_SOURCES := $(wildcard *_test.c *_test.cpp)
# test object files
TEST_OBJS := $(patsubst %.c, %.o, $(filter %.c, $(TEST_SOURCES)))
TEST_OBJS += $(patsubst %.cpp, %.o, $(filter %.cpp, $(TEST_SOURCES)))
# test dependency files
TEST_DEPS = $(TEST_OBJS:%.o=%.d)

# executable
PROG := a.out
# source files
SOURCES := $(wildcard *.c *.cpp)
SOURCES := $(filter-out $(TEST_SOURCES), $(SOURCES))
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
	QUIET_CXX		= @echo '   ' CC $@;
	QUIET_LINK		= @echo '   ' LD $@;
	export V
endif
endif

# top-level rule
all: $(PROG)

# compile the program in debug mode
debug: CXXFLAGS += -g
debug: $(PROG)

# compile the program with compiler optimization
opt: CXXFLAGS += -O3
opt: $(PROG)

# compile release ready code
release: CPPFLAGS += -D NDEBUG
release: opt
# uncomment the following line to automatically clean up unneeded generated files
release: cleanAllExceptMainExec

# compile the program for gprof profiling
gprof: CXXFLAGS += -g -pg
gprof: $(PROG)

# rule to link program
$(PROG): $(OBJS)
	$(QUIET_LINK)$(CXX) $(LDFLAGS) $(CPPFLAGS) $(ELDFLAGS) $(OBJS) $(LINKEDOBJS) -o $(PROG) $(LIBS)

# rule to compile object files and automatically generate dependency files
define cc-command
	$(QUIET_CXX)$(CXX) $(CXXFLAGS) $(EXXFLAGS) $(CPPFLAGS) -c $< -MMD > $*.d
endef
# compile .c files
.c.o:
	$(cc-command)
# compile .cpp files
.cpp.o:
	$(cc-command)

# include dependency files
-include $(DEPS)
-include $(TEST_DEPS)

# clean up targets
.PHONY: clean cleanObj cleanAllObj cleanTests cleanAllExceptMainExec cleanAll

# remove object files and dependency files, but keep the executable
clean:
	$(RM) $(OBJS) $(DEPS)

# only remove the object files
cleanObj:
	$(RM) $(OBJS)

# remove the test objects
cleanAllObj: cleanObj
cleanAllObj:
	$(RM) $(TEST_OBJS)

# remove all generated test files
cleanTests:
	$(RM) $(TEST_PROG) $(TEST_OBJS) $(TEST_DEPS)
	
# remove all generated files except for the main executable
cleanAllExceptMainExec: cleanTests
cleanAllExceptMainExec: clean
cleanAllExceptMainExec: cleanCodeCoverage

# remove all generated files
cleanAll: cleanAllExceptMainExec
cleanAll:
	$(RM) $(PROG)

cleanGoogleTest:
	$(RM) gtest*.o gtest*.a gmock*.o gmock*.a
