#!/bin/sh
VERSION="3.6"
# TODO: migrate to upstream libffi once libffi/libffi#565 and similar are merged
SOURCE_URL="https://ftp.gnu.org/gnu/nettle/nettle-${VERSION}.tar.gz"

function compile_nettle() {
  component_name="nettle"

  if [ -f ${prefix_dir}/lib/libnettle.a ]; then
    # We're all good here.
    return
  fi

  cflags=$1

  build_dir=$(create_build)
  cd $build_dir
  echo Building in $build_dir.

  # Trust me here? :)
  # TODO: edit
  CFLAGS=$cflags PKG_CONFIG_PATH="$(pkg_config)" $(work_dir)/${component_name}/configure --prefix=${prefix_dir} \
    --host=aarch64-apple-darwin20.0.0 --build=$(target_triple) --target=$(target_triple) \
    --enable-shared=no --enable-static=yes
  make
  make install
}

function setup() {
  cd $(work_dir)

  src_dir=$(work_dir)/nettle
  if [ ! -d ${src_dir} ]; then
    wget $SOURCE_URL
    mkdir ${src_dir}
    # Extract without version to component name folder
    tar -xvf nettle-${VERSION}.tar.gz -C ${src_dir} --strip-components=1
  fi
}

setup