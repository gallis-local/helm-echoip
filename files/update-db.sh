#!/bin/sh

echo "Update DB started"
dir="/db-shared"
cd "$dir" || exit 2

procdir="$(mktemp -d -p "$dir")"
cd "$procdir" || exit 3

download() {

    url="https://download.maxmind.com/app/geoip_download?edition_id="
    extra="&license_key=$LICENSE_KEY&suffix=tar.gz"
    target="$1"
    archive="$1.tar.gz"
    echo "Preparing to download: $target"

    tmpdir="$(mktemp -d -p "$procdir")"
    cd "$tmpdir" || exit 4

    echo "Downloading: $url$1$extra"
    wget "$url$1$extra" -O $archive
    tar -xzvf "$archive"
    mv "$target"*/*.mmdb "$procdir"

    echo "Finalizing download: $target"
    cd "$procdir" || exit 5
    rm -rf "$tmpdir"
    md5sum "$target.mmdb" > "$target.mmdb.md5"
}

download "GeoLite2-City"
download "GeoLite2-Country"
mv ./* "$dir" || exit 6

cd "$dir" || exit 7
rm -rf "$procdir"
echo "Update DB completed"
