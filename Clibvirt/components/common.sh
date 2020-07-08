#!/bin/sh

function create_prefix() {
  prefix_dir=$(prefix_dir)
  mkdir -p $prefix_dir

  echo $prefix_dir
}

function create_build() {
  build_dir=$(work_dir)/${component_name}-${platform}-${arch}
  mkdir -p $build_dir

  echo $build_dir
}

function work_dir() {
  echo ${source_dir}/work
}

function prefix_dir() {
  echo ${source_dir}/prefixes/${platform}-${arch}
}

function pkg_config() {
  echo ${source_dir}/prefixes/${platform}-${arch}/lib/pkgconfig
}

# Outputs a triple similar to arm64-apple-darwin20.0.0.
function host_triple() {
  echo $(clang -v 2>&1 | grep Target | sed 's/Target: //')
}

# Outputs a triple similar to x86_64-apple-darwin20.0.0, or whatever $arch is defined as in scope.
function target_triple() {
  # TODO: remove
  if [ $arch = "arm64" ]; then
    echo "aarch64-apple-darwin$(uname -r)"
  fi
  
  echo "${arch}-apple-darwin$(uname -r)"
}