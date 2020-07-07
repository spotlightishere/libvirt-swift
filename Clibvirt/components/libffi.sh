#!/bin/sh
VERSION="3.3"
SOURCE_URL="https://github.com/libffi/libffi/releases/download/v${VERSION}/libffi-${VERSION}.tar.gz"

function compile_libffi() {
  component_name="libffi"

  if [ -f ${prefix_dir}/lib/libffi.a ]; then
    # We're all good here.
    return
  fi

  cflags=$1

  build_dir=$(create_build)
  cd $build_dir
  echo Building in $build_dir.

  CFLAGS=$cflags PKG_CONFIG_PATH="$(pkg_config)" $(work_dir)/${component_name}/configure --prefix=${prefix_dir} --enable-shared=no --enable-static=yes
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
    tar -xvf libffi-${VERSION}.tar.gz -C ${src_dir} --strip-components=1
  fi
}

setup