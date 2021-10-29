pkg_name=rq
pkg_origin=core
pkg_version=1.0.2
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="\
Record Query is a tool for doing record analysis and transformation. It's \
used for performing queries on streams of records in various formats.\
"
pkg_upstream_url="https://github.com/dflemstr/rq"
pkg_license=('Apache-2.0')
pkg_source=https://github.com/dflemstr/rq/releases/download/v${pkg_version}/rq-v${pkg_version}-x86_64-unknown-linux-gnu.tar.gz
pkg_shasum=b870456796c27f358090a5e68944d912beb4280bc7010912cb3d6753f2da936c
pkg_deps=(
  core/glibc
  core/gcc-libs
)
pkg_build_deps=(
  core/patchelf
)
pkg_bin_dirs=(bin)

do_build() {
	return 0
}

do_install() {
	mv "${HAB_CACHE_SRC_PATH}/rq" "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"
	cp "${HAB_CACHE_SRC_PATH}/${pkg_dirname}/rq" "${pkg_prefix}/bin"
}

do_strip() {
  do_default_strip

  # Patching the binary after stripping unneeded symbols because strip does not
  # like the modifications patchelf makes
  patchelf \
    --interpreter "$(pkg_path_for core/glibc)/lib/ld-linux-x86-64.so.2" \
    --set-rpath "${LD_RUN_PATH}" \
    "${pkg_prefix}/bin/rq"
}
