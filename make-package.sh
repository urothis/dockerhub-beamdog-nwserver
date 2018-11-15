#!/bin/bash
set -e

BRANCH=$(git symbolic-ref --short HEAD)

echo "Detected tag: $BRANCH. Enter for OK, ^C to cancel. [Make sure to git branch if not correct]"
read

if [ ! -f "$NWN_ROOT/data/nwn_base.key" ]; then
  echo "NWN_ROOT not specified"
  exit 1
fi

set -x
cp -va "$NWN_ROOT"/build-date.txt data
cp -va "$NWN_ROOT"/bin/linux-x86/nwserver-linux data/bin/linux-x86/
# cp -va "$NWN_ROOT"/bin/macos/nwserver-macos data/bin/macos/
# cp -va "$NWN_ROOT"/bin/win32/nwserver.exe data/bin/win32/
cp -va "$NWN_ROOT"/data/dialog.tlk data/data/
nwn_resman_pkg -d data/data --root "$NWN_ROOT"

docker build -t beamdog/nwserver:$BRANCH -f Dockerfile .
docker tag beamdog/nwserver:$BRANCH beamdog/nwserver:latest
set +x

echo ""
echo "All done, now verify the images and then run to push:"
echo " docker push beamdog/nwserver:$BRANCH"
echo " docker push beamdog/nwserver:latest"
echo ""
echo "Don't forget to update the master branch."
