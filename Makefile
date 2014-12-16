PROJECT_NAME=pure_hdl_project1
TCL_FILENAME=project_tcl.tcl
CC=vivado
CFLAGS=-mode batch -source 

all:project_tcl

project_tcl:${TCL_FILENAME} # add .vhd files
	${CC} ${CFLAGS} ${TCL_FILENAME}

clean:
	rm -rf ${PROJECT_NAME}

veryclean:
	rm -rf ${PROJECT_NAME}
	rm *.log
	rm *.jou
	rm *.bit
