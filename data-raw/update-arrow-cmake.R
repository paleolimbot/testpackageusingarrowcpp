
library(tidyverse)

src_dir <- "data-raw/arrow-apache-arrow-7.0.0/cpp/src/arrow"

if (!dir.exists(src_dir)) {
  curl::curl_download(
    "https://github.com/apache/arrow/archive/refs/tags/apache-arrow-7.0.0.zip",
    "data-raw/arrow.zip"
  )

  unzip("data-raw/arrow.zip", exdir = "data-raw")
}

fs::dir_copy("data-raw/arrow-apache-arrow-7.0.0/cpp", "tools")
