#!/bin/sh
VERSION="6.2.0"
# TODO: migrate to upstream libffi once libffi/libffi#565 and similar are merged
SOURCE_URL="https://gmplib.org/download/gmp/gmp-${VERSION}.tar.xz"

function compile_gmp() {
  component_name="gmp"

  if [ -f ${prefix_dir}/lib/libgmp.a ]; then
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

  src_dir=$(work_dir)/gmp
  if [ ! -d ${src_dir} ]; then
    wget $SOURCE_URL
    mkdir ${src_dir}
    # Extract without version to component name folder
    tar -xvf gmp-${VERSION}.tar.xz -C ${src_dir} --strip-components=1
    cd ${src_dir}
    echo $(pwd)
    # TODO: remove patch after applied or resolved upstream
    # see also: https://github.com/Homebrew/homebrew-core/pull/57315
    wget https://raw.githubusercontent.com/Homebrew/formula-patches/c53834b4/gmp/6.2.0-arm.patch
    patch -p1 < 6.2.0-arm.patch
    autoreconf
  fi
}

setup