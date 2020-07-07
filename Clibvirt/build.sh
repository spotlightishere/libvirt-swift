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
  standard_cflags="-isysroot ${sysroot} -arch ${arch}"

  compile_libffi "${standard_cflags}"
  compile_pcre "${standard_cflags}"
  compile_glib "${standard_cflags}"
  compile_yajl "${standard_cflags}"
  compile_libvirt "${standard_cflags}"
done

# Compile for iOS
sysroot="$(xcrun --sdk iphoneos --show-sdk-path)"
iOS_arches=(arm64 arm64e)
