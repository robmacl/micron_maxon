#
# Makefile for Unix platforms
#
# compiler flags:  -O          - optimize code for execution speed
#
                                 
CC = cc
CLIBS = -L. -lmnpak -lm
CFLAGS = -O
CALOBS = cal_main.o ecalmain.o cal_tran.o cal_eval.o cal_util.o matrix.o
MINPACKOBS = dpmpar.o enorm.o fdjac2.o lmdif.o lmpar.o qrfac.o qrsolv.o
MINPACKLIB = libmnpak.a

#########################################

asap_cal:		asap_cal.c $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) asap_cal.c $(CALOBS) $(CLIBS) -o asap_cal

ccal_fo:	ccal_fo.c $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) ccal_fo.c $(CALOBS) $(CLIBS) -o ccal_fo

nccal:		nccal.c $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) nccal.c $(CALOBS) $(CLIBS) -o nccal

nccal_fo:	nccal_fo.c $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) nccal_fo.c $(CALOBS) $(CLIBS) -o nccal_fo

ecal:		ecal.c $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) ecal.c $(CALOBS) $(CLIBS) -o ecal

xfd2xfu:	xfd2xfu.c $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) xfd2xfu.c $(CALOBS) $(CLIBS) -o xfd2xfu

wc2ic:          wc2ic.c $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) wc2ic.c $(CALOBS) $(CLIBS) -o wc2ic

ic2wc:	        ic2wc.c $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) ic2wc.c $(CALOBS) $(CLIBS) -o ic2wc

csyn:	        csyn.c gasdev.o $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) csyn.c gasdev.o $(CALOBS) $(CLIBS) -o csyn

ncsyn:	        ncsyn.c gasdev.o $(CALOBS) $(MINPACKLIB)
	$(CC) $(CFLAGS) ncsyn.c gasdev.o $(CALOBS) $(CLIBS) -o ncsyn

#########################################

cal_main.o:	cal_main.h cal_main.c
	$(CC) $(CFLAGS) -c cal_main.c

ecalmain.o:	cal_main.h ecalmain.c
	$(CC) $(CFLAGS) -c ecalmain.c

cal_tran.o:	cal_main.h cal_tran.c
	$(CC) $(CFLAGS) -c cal_tran.c

cal_eval.o:	cal_main.h cal_eval.c
	$(CC) $(CFLAGS) -c cal_eval.c

cal_util.o:	cal_main.h cal_util.c
	$(CC) $(CFLAGS) -c cal_util.c

matrix.o:	matrix/matrix.h matrix/matrix.c
	$(CC) $(CFLAGS) -c matrix/matrix.c

gasdev.o:	gasdev.c
	$(CC) $(CFLAGS) -c gasdev.c

$(MINPACKLIB):   minpack/f2c.h \
                 minpack/dpmpar.c \
                 minpack/enorm.c \
                 minpack/fdjac2.c \
                 minpack/lmdif.c \
                 minpack/lmpar.c \
                 minpack/qrfac.c \
                 minpack/qrsolv.c
	$(CC) $(CFLAGS) -c minpack/*.c
	ar rvc $(MINPACKLIB) $(MINPACKOBS)
	ranlib $(MINPACKLIB)
	/bin/rm $(MINPACKOBS)

#########################################

all:	asap_cal \
	ccal_fo \
	nccal \
	nccal_fo \
	ecal \
	xfd2xfu \
	wc2ic \
	ic2wc \
	csyn \
	ncsyn

clean:
	/bin/rm -f \
	*.a \
	*.o \
	asap_cal \
	ccal_fo \
	nccal \
	nccal_fo \
	ecal \
	xfd2xfu \
	wc2ic \
	ic2wc \
	csyn \
	ncsyn

lint:
	lint -Imatrix -Iminpack *.c matrix/*.c minpack/*.c
