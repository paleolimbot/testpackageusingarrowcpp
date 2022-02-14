
library(tidyverse)

src_dir <- "data-raw/arrow-apache-arrow-7.0.0/cpp/src/arrow"

if (!dir.exists(src_dir)) {
  curl::curl_download(
    "https://github.com/apache/arrow/archive/refs/tags/apache-arrow-7.0.0.zip",
    "data-raw/arrow.zip"
  )

  unzip("data-raw/arrow.zip", exdir = "data-raw")
}

source_files <- tibble(
  src = c(
    list.files(src_dir, "\\.cc$", full.names = TRUE),
    list.files(file.path(src_dir, "util"), "\\.cc$", full.names = TRUE),
    list.files(file.path(src_dir, "array"), "\\.cc$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored"), "\\.(cc|cpp)$", full.names = TRUE),
    list.files(file.path(src_dir, "io"), "\\.cc$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored/xxhash"), "\\.c$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored/double-conversion"), "\\.cc$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored/datetime"), "\\.cpp$", full.names = TRUE)
  ) %>%
    str_subset("_(test|benchmark)\\.cc$", negate = TRUE),
  dst = file.path("src", basename(src)) %>%
    str_replace("\\.cpp$", ".cc")
) %>%
  filter(
    !(basename(src) %in% c(
      "benchmark_main.cc",
      "bpacking_avx2.cc",
      "bpacking_avx512.cc",
      "bpacking_neon.cc",
      "compression_brotli.cc",
      "compression_bz2.cc",
      "compression_lz4.cc",
      "compression_snappy.cc",
      "compression_zlib.cc",
      "compression_zstd.cc",
      "test_common.cc",
      "tensor.cc",
      "sparse_tensor.cc"
    ))
  )

header_files <- tibble(
  src = c(
    list.files(src_dir, "\\.h$", full.names = TRUE),
    list.files(file.path(src_dir, "util"), "\\.h$", full.names = TRUE),
    list.files(file.path(src_dir, "array"), "\\.h$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored"), "\\.(h|hpp)$", full.names = TRUE),
    list.files(file.path(src_dir, "io"), "\\.h$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored/xxhash"), "\\.h$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored/portable-snippets"), "\\.h$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored/double-conversion"), "\\.h$", full.names = TRUE),
    list.files(file.path(src_dir, "vendored/datetime"), "\\.h$", full.names = TRUE)
  ) %>%
    str_subset("_(test|benchmark)\\.h$", negate = TRUE),
  dst = file.path("src", "arrow", str_remove(src, ".*?cpp/src/arrow/"))
)

# clean exiting source files
unlink(list.files("src", "\\.cc?$", full.names = TRUE))
unlink("src/arrow", recursive = TRUE)

# copy new source files
stopifnot(all(file.copy(source_files$src, source_files$dst)))

header_dirs <- unique(dirname(header_files$dst))
walk(header_dirs, ~if (!dir.exists(.x)) dir.create(.x, recursive = TRUE))
stopifnot(all(file.copy(header_files$src, header_files$dst)))

# fill in util/config.h
write_file('

#define ARROW_VERSION 0
#define ARROW_VERSION_MAJOR 7
#define ARROW_VERSION_MINOR 0
#define ARROW_VERSION_PATCH 0
#define ARROW_VERSION_STRING "7.0.0"
#define ARROW_SO_VERSION ""
#define ARROW_FULL_SO_VERSION ""
#define ARROW_CXX_COMPILER_ID ""
#define ARROW_CXX_COMPILER_VERSION ""
#define ARROW_CXX_COMPILER_FLAGS ""
#define ARROW_GIT_ID ""
#define ARROW_GIT_DESCRIPTION ""
#define ARROW_PACKAGE_KIND ""
#define ARROW_BUILD_TYPE "inadvisable"

', "src/arrow/util/config.h")
