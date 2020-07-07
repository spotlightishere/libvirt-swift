#!/bin/sh
MAJOR_VERSION="2.65"
MINOR_VERSION="0"
SOURCE_URL="https://download.gnome.org/sources/glib/${MAJOR_VERSION}/glib-${MAJOR_VERSION}.${MINOR_VERSION}.tar.xz"

function compile_glib() {
  component_name="glib"

  if [ -d ${prefix_dir}/lib/glib-2.0 ]; then
    # We're all good here.
    return
  fi

  cflags=$1

  build_dir=$(create_build)
  cd $build_dir
  echo Building in $build_dir.

  CFLAGS=$cflags PKG_CONFIG_PATH="$(pkg_config)" meson $(work_dir)/${component_name} --prefix=${prefix_dir}
  ninja
  ninja install
}

function setup() {
  cd $(work_dir)

  src_dir=$(work_dir)/glib
  if [ ! -d ${src_dir} ]; then
    wget $SOURCE_URL
    mkdir ${src_dir}
    # Extract without version to component name folder
    tar -xvf glib-${MAJOR_VERSION}.${MINOR_VERSION}.tar.xz -C ${src_dir} --strip-components=1
  fi
}

setup