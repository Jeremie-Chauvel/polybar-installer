#! /bin/bash
# this script install polybar compiling it from source

set -euo pipefail
IFS=$'\n\t'

# cp config file
readonly polybar_config_dir="$HOME/.config/polybar"
if [[ ! -d "$polybar_config_dir" ]]; then
  mkdir -p "$polybar_config_dir"
fi
if [[ -f "$polybar_config_dir/config" ]]; then
  mv "$polybar_config_dir/config" "$polybar_config_dir/config.backup"
fi
ln -sr ./config "$polybar_config_dir"

# install dependencies
sudo apt install --yes build-essential git cmake cmake-data pkg-config python3-sphinx \
  libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev \
  libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev \
  libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev \
  libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev \
  libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev

# download 3.4 polybar release
tmp_dir=$(mktemp -d -t polybar-install-XXXX)
cd "$tmp_dir"
git clone https://github.com/jaagr/polybar.git
cd polybar
git checkout 3.4.2 # version

# compile polybar
set +e
hash pyenv
result_status="$?"
set -e
if [[ "$result_status" == 0 ]]; then
  pyenv local system
fi
set +euo
./build.sh --i3 --pulseaudio --network --curl --auto
set -euo
# add siji character set
cd ..
git clone https://github.com/stark/siji && cd siji
set +euo
./install.sh
sudo dpkg-reconfigure fontconfig-config
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf && fc-cache
set -euo

rm -rf "$tmp_dir"
