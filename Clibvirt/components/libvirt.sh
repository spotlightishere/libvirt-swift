#!/bin/bash

function compile_libvirt() {
	# cflags=$1
	
	echo "hi"
	
	cd $build_dir
	echo Building in $build_dir.
	# 
	# # libvirt via git provides autogen.sh, which we will now invoke.
	# # It's assumed that you have all of the autotools installed - please do, if you don't already!
	# 
	# # We don't want libvirtd.
	# CFLAGS="${cflags}" $libvirt_dir/autogen.sh --enable-static --prefix="${build_dir}"
}