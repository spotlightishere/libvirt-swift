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
