#! /bin/bash
# this script install polybar compiling it from source

set -euo pipefail
IFS=$'\n\t'

# cp config file
readonly polybar_config_dir="$HOME/.config/polybar"
if [ ! -d "$polybar_config_dir" ]; then
    mkdir -p "$polybar_config_dir"
fi
cp ./config $HOME/.config/polybar/

# install dependencies
sudo apt install build-essential git cmake cmake-data pkg-config python3-sphinx libcairo2-dev libxcb1-dev libxcb-util0-dev libxcb-randr0-dev libxcb-composite0-dev python-xcbgen xcb-proto libxcb-image0-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-xkb-dev libxcb-xrm-dev libxcb-cursor-dev libasound2-dev libpulse-dev i3-wm libjsoncpp-dev libmpdclient-dev libcurl4-openssl-dev libnl-genl-3-dev -y

# download 3.4 polybar release
tmp_dir=$(mktemp -d -t polybar-install-XXXX)
cd "$tmp_dir"
curl https://github.com/polybar/polybar/releases/download/3.4.2/polybar-3.4.2.tar > polybar-3.4.2.tar
tar xvf polybar-3.4.2.tar

# compile polybar
cd polybar
if hash pyenv; then
  pyenv local system
fi
set +euo
./build.sh --i3 --network --jobs --auto
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

