#!/bin/sh -x -e

source_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
libvirt_dir=${source_dir}/libvirt

# Ensure work directory exists.
mkdir -p ${source_dir}/work

# Load all component helpers
for component_helper in ${source_dir}/components/*.sh; do
  source $component_helper
done

# Compile for macOS
# TODO: refactor to both arches!
# macOS_arches=(arm64 x86_64)
macOS_arches=(arm64)
sysroot="$(xcrun --sdk macosx --show-sdk-path)"
for arch in "${macOS_arches[@]}"; do
  platform="macOS"

  prefix_dir=$(create_prefix)
  standard_cflags="-arch $arch -isysroot ${sysroot} -I$(prefix_dir)/include"
  standard_ldflags="-L$(prefix_dir)/lib"

  # glib is a libvirt requiremet
  compile_libffi "${standard_cflags}"
  compile_pcre "${standard_cflags}" "${standard_ldflags}"
  compile_glib "${standard_cflags}" "${standard_ldflags}"
  
  # yajl is a standalone libvirt requirement
  compile_yajl "${standard_cflags}" "${standard_ldflags}"
  
  # gnutls is a libvirt requirement
  compile_gmp "${standard_cflags}" "${standard_ldflags}"
  compile_p11kit "${standard_cflags}" "${standard_ldflags}"
  # libgmp is required throughout configure. This is yet another hack!
  compile_nettle "${standard_cflags} ${standard_ldflags}" "${standard_ldflags}"
  compile_gnutls "${standard_cflags} ${standard_ldflags}" "${standard_ldflags}"
  # 
  # compile_libvirt "${standard_cflags}" "${standard_ldflags}"
done

# Compile for iOS
sysroot="$(xcrun --sdk iphoneos --show-sdk-path)"
iOS_arches=(arm64 arm64e)
