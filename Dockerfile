FROM michilu/docker-dart
# For chrome installation.
# libX11.so.6 needed by google-chrome
ADD google-chrome.repo etc/yum.repos.d/
RUN dnf install --setopt=rawhide.skip_if_unavailable=true --quiet -y \
  google-chrome-unstable \
  libexif \
  xorg-x11-server-Xvfb \
  && dnf clean all
# For virtual frame buffer.
ADD Xvfb.service /usr/lib/systemd/system/
ADD Xvfb.sysconfig /etc/sysconfig/
ENV DISPLAY=:99

ENTRYPOINT \
  dbus-daemon --system \
  && xvfb-run google-chrome --disable-gpu

# Create the directory needed to run the dbus daemon
# https://hub.docker.com/r/dscho/docker-desktop/~/dockerfile/
#RUN mkdir /var/run/dbus
#CMD dbus-daemon --system --fork &&

## For launch chrome
## [1030:1030:1120/074254:ERROR:desktop_window_tree_host_x11.cc(766)] Not implemented reached in virtual void views::DesktopWindowTreeHostX11::InitModalType(ui::ModalType)
## https://bugs.launchpad.net/ubuntu/+source/chromium-browser/+bug/1329286
#sudo rm -rf $HOME/.config/chrome/Default
## For launch chrome on X11.
#sudo apt-get -y -q install dbus-x11
## For chrome installation failure.
#set -o errexit
## Display installed versions.
#/usr/bin/google-chrome --version
## Install dartium
#wget "http://storage.googleapis.com/dart-archive/channels/stable/release/latest/dartium/dartium-linux-x64-release.zip"
#unzip "dartium-linux-x64-release.zip"
#mv `find . -name "dartium-lucid64-full-stable*" -type d|head -1` $DART_SDK/../chromium
#rm "dartium-linux-x64-release.zip"
## Display installed versions.
#/usr/bin/google-chrome --version
#$DART_SDK/../chromium/chrome --version
