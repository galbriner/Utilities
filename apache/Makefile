INCLUDE = -I/usr/include/httpd -I/usr/include/apr-1
CFLAGS  = -g -fpic $(INCLUDE) -DLINUX=2 -D_REENTRANT -D_GNU_SOURCE -D_LARGEFILE64_SOURCE `GraphicsMagick++-config --cppflags`
LFLAGS  = -shared -W1,-soname,-mod_img_test
LIBS    = `GraphicsMagick++-config --libs`
OBJS    = mod_img_test.o

.cpp.o:
	g++ $(CFLAGS) -c $<

mod_proxy.so: $(OBJS)
	g++ $(LFLAGS) -omod_img_test.so $(OBJS) $(LIBS)

clean:
	rm -f $(OBJS)  mod_img_test.so
