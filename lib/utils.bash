#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/pemistahl/grex"
TOOL_NAME="grex"
TOOL_TEST="grex --help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  local filename_in_url

  case $(uname | tr '[:upper:]' '[:lower:]') in
    linux*)
      filename_in_url="grex-v${version}-x86_64-unknown-linux-musl.tar.gz"
      ;;
    darwin*)
      filename_in_url="grex-v${version}-x86_64-apple-darwin.tar.gz"
      ;;
    *)
      fail "Platform $(uname | tr '[:upper:]' '[:lower:]') is not supported"
      ;;
  esac

  url="$GH_REPO/releases/download/v${version}/${filename_in_url}"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  local release_file="$install_path/$TOOL_NAME-$version.tar.gz"
  (

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"

    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file"
    tar -xvzf "$release_file" -C "$install_path" && mv "$install_path/$tool_cmd" "$install_path/bin" || fail "Could not extract $release_file"
    rm "$release_file"

    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
