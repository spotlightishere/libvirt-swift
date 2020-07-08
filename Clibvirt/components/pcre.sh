#!/bin/sh
VERSION="8.44"
SOURCE_URL="https://ftp.pcre.org/pub/pcre/pcre-${VERSION}.tar.gz"

function compile_pcre() {
  component_name="pcre"

  if [ -f ${prefix_dir}/lib/libpcre.a ]; then
    # We're all good here.
    return
  fi

  cflags=$1
  ldflags=$2

  build_dir=$(create_build)
  cd $build_dir
  echo Building in $build_dir.

  CFLAGS=$cflags LDFLAGS=$ldflags PKG_CONFIG_PATH="$(pkg_config)" $(work_dir)/${component_name}/configure --prefix=${prefix_dir} --enable-shared=no --enable-static=yes
  make
  make install
}

function setup() {
  cd $(work_dir)

  src_dir=$(work_dir)/pcre
  if [ ! -d ${src_dir} ]; then
    wget $SOURCE_URL
    mkdir ${src_dir}
    # Extract without version to component name folder
    tar -xvf pcre-${VERSION}.tar.gz -C ${src_dir} --strip-components=1
  fi
}

setup