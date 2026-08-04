CC = gcc -O3 -g

OBJS = nrutil.o file.o frprmn.o linmin.o brent.o f1dim.o mnbrak.o lnsrch.o dfpmin.o

all:		conjgrad

conjgrad:  	$(OBJS) conjgrad.c
		$(CC) $(OBJS) conjgrad.c -lm -o conjgrad

file:  		file.h nrutil.h file.c
		$(CC) file.c -lm -o file

nrutil: 	nrutil.h nrutil.c
		$(CC) nrutil.c -lm -o nrutil

clean:
		rm *.o




