PROJECT_NAME=pure_hdl_project1
TCL_FILENAME=project_tcl.tcl
CC=vivado
CFLAGS=-mode batch -source
TOP_ENTITY_NAME=frequency_divider

all:project_tcl

project_tcl:${TCL_FILENAME} # add .vhd files
	${CC} ${CFLAGS} ${TCL_FILENAME}

sim:
	xvhdl hdl_sources/*.vhd
	xelab --debug all ${TOP_ENTITY_NAME}
	xsim ${TOP_ENTITY_NAME} -gui

clean:
	rm -rf ${PROJECT_NAME}

veryclean:
	rm -rf ${PROJECT_NAME}
	rm -rf xsim.dir/
	rm *.log *.jou *.pb *.wdb 
	rm *.bit
