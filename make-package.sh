#!/bin/bash
set -e

if [ "$TAG" = "" ]; then
  echo "env var TAG not specified"
  exit 1
fi

echo "Using tag: $TAG. Enter for OK, ^C to cancel. [Make sure to git branch if not correct]"
read

if [ ! -f "$NWN_ROOT/data/nwn_base.key" ]; then
  echo "NWN_ROOT not specified"
  exit 1
fi

set -x
mkdir -p data/bin/linux-x86/
cp -va "$NWN_ROOT"/bin/linux-x86/nwserver-linux data/bin/linux-x86/
mkdir -p data/data/
cp -va "$NWN_ROOT"/data/dialog.tlk data/data/
nwn_resman_pkg -d data/data --root "$NWN_ROOT"

docker build --no-cache -t beamdog/nwserver:$TAG -f Dockerfile .
docker tag beamdog/nwserver:$TAG beamdog/nwserver:latest
set +x

echo ""
echo "All done, now verify the images and then run to push:"
echo " docker push beamdog/nwserver:$TAG"
echo " docker push beamdog/nwserver:latest"
echo ""
echo "Don't forget to update the master branch."
