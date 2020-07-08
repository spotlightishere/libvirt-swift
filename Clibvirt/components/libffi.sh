#!/bin/sh
VERSION="25"
# TODO: migrate to upstream libffi once libffi/libffi#565 and similar are merged
SOURCE_URL="https://opensource.apple.com/tarballs/libffi/libffi-${VERSION}.tar.gz"

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

  # Trust me here? :)
  # TODO: edit
  CFLAGS=$cflags PKG_CONFIG_PATH="$(pkg_config)" $(work_dir)/${component_name}/configure --prefix=${prefix_dir} --host=aarch64-apple-darwin20.0.0 --build=$(target_triple)  --target=$(target_triple) 
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
    # Create configure
    cd libffi
    bash autogen.sh
  fi
}

setup