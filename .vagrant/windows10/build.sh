#!/usr/bin/env bash
workspaceDir=/c/Users/vagrant/Desktop/workspace
cd $workspaceDir

/c/Users/vagrant/Desktop/v2rayN/v2rayN.exe &
sleep 5
export http_proxy=http://127.0.0.1:10809;export https_proxy=http://127.0.0.1:10809;
echo "Set Proxy."

if [ -e tmp ]; then
    rm -rf tmp
    echo "deleted tmp directory."
fi

if [ ! -e ${workspaceDir}/shareFolder/build ]; then
  mkdir ${workspaceDir}/shareFolder/build
fi
buildWindowsDir="${workspaceDir}/shareFolder/build/windows"
if [ -e $buildWindowsDir ]; then
  rm -rf "${buildWindowsDir}"
  echo "deleted build directory for windows platform."
fi

mkdir tmp
echo "created tmp directory."
cp -r shareFolder/* tmp/
cp -r shareFolder/.* tmp/
echo "copy project."
cd tmp
flutter pub get
echo "get flutter dependencies."
flutter build windows
echo "build windows platform."
cp -r build/windows ../shareFolder/build
echo "cp the build files to sync Directory."
cd ..
rm -rf tmp
echo "deleted tmp directory."
