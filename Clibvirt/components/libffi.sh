#!/bin/sh
SOURCE_URL="https://github.com/libffi/libffi/releases/download/v3.3/libffi-3.3.tar.gz"

function compile_libffi() {
	component_name="libffi"
	cflags=$1
	
	build_dir=$(create_build)
	cd $build_dir
	echo Building in $build_dir.
	
	CFLAGS=$clags $(work_dir)/libffi/configure --prefix=${prefix_dir} --enable-shared=no --enable-static=yes
	make
	make install
}

function setup() {
	cd $(work_dir)
	
	src_dir=$(work_dir)/libffi
	if [ ! -d ${src_dir} ]; then
		wget $SOURCE_URL
		mkdir ${src_dir}
		# Extract without version to component name folder
		tar -xvf libffi*.tar.gz -C ${src_dir} --strip-components=1
	fi
}

setup