#!/bin/sh
VERSION="2.1.0"
SOURCE_URL="http://github.com/lloyd/yajl/tarball/${VERSION}"

function compile_yajl() {
  component_name="yajl"

  if [ -f ${prefix_dir}/lib/libyajl_s.a ]; then
    # We're all good here.
    return
  fi

  cflags=$1

  build_dir=$(create_build)
  cd $build_dir
  echo Building in $build_dir.

  CFLAGS=$cflags cmake -DCMAKE_INSTALL_PREFIX=${prefix_dir} $(work_dir)/${component_name}
  make
  make install
}

function setup() {
  cd $(work_dir)

  src_dir=$(work_dir)/yajl
  if [ ! -d ${src_dir} ]; then
    wget $SOURCE_URL
    mv ${VERSION} yajl-${VERSION}.tar
    mkdir ${src_dir}
    # Extract without version to component name folder
    tar -xvf yajl-${VERSION}.tar -C ${src_dir} --strip-components=1
  fi
}

setup