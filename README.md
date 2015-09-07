Makefiles
=========
General use makefile  


Features
--------
- Automatic dependency generation
- Quiet compiler output


Using
-----
- Currently only supports projects located in a single directory (i.e. Makefile should be in the same directory as all of the source files)
- There should only be one 'main' function, and it should be located in a file named main.cpp or main.c (i.e. the file's object file should be named main.o)
- Only supports *.cpp and *.c file extensions (can be extended to other extensions by modifying the Makefile)
- Test files should be named as *_test.cpp or *_test.c (can be extended by modifying the Makefile)


Sources
-------
http://users.actcom.co.il/~choo/lupg/tutorials/writing-makefiles/writing-makefiles.html  
http://mad-scientist.net/make/autodep.html  
http://stackoverflow.com
