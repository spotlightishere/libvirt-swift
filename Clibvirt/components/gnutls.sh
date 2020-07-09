#!/bin/sh
VERSION="0.23.20"
# TODO: migrate to upstream libffi once libffi/libffi#565 and similar are merged
SOURCE_URL="https://github.com/p11-glue/p11-kit/releases/download/${VERSION}/p11-kit-${VERSION}.tar.xz"

function compile_p11kit() {
  component_name="p11-kit"

  if [ -f ${prefix_dir}/lib/libp11-kit.dylib ]; then
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
    --without-libtasn1
  make
  make install
}

function setup() {
  cd $(work_dir)

  src_dir=$(work_dir)/p11-kit
  if [ ! -d ${src_dir} ]; then
    wget $SOURCE_URL
    mkdir ${src_dir}
    # Extract without version to component name folder
    tar -xvf p11-kit-${VERSION}.tar.xz -C ${src_dir} --strip-components=1
  fi
}

setup