#!/bin/sh
VERSION="6.5.0"
SOURCE_URL="https://libvirt.org/sources/libvirt-${VERSION}.tar.xz"

function compile_libvirt() {
  component_name="libvirt"

  if [ -f ${prefix_dir}/lib/libvirt.a ]; then
    # We're all good here.
    return
  fi


  cflags=$1
  ldflags=$2

  build_dir=$(create_build)
  cd $build_dir
  echo Building in $build_dir.
  
  CFLAGS=$cflags LDFLAGS=$ldflags PKG_CONFIG_PATH="$(pkg_config)" $(work_dir)/${component_name}/configure --prefix=${prefix_dir} \
    --enable-shared=no --enable-static=yes \
    --with-libvirtd=no --without-storage-lvm \
    --without-storage-iscsi --without-storage-disk \
    --without-storage-rbd --without-udev \
    --without-capng --without-macvtap \
    --without-network --without-lxc \
    --without-numactl --without-numad \
    --without-netcf --with-init-script=none \
    --without-systemd-daemon --without-firewalld \
    --without-audit --without-selinux \
    --without-apparmor --without-nss-plugin \
    --without-dtrace --without-xen \
    --without-libxl --without-vbox
  make
  make install
}

function setup() {
  cd $(work_dir)

  src_dir=$(work_dir)/libvirt
  if [ ! -d ${src_dir} ]; then
    wget $SOURCE_URL
    mkdir ${src_dir}
    # Extract without version to component name folder
    tar -xvf libvirt-${VERSION}.tar.xz -C ${src_dir} --strip-components=1
    
    # Patch out tools target
    cd ${src_dir}
    sed -i '' 's/include\/libvirt src tools docs/include\/libvirt src docs/' Makefile.am
    autoreconf
  fi
}

setup
