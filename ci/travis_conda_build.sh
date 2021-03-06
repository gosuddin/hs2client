#!/usr/bin/env bash

set -e

source $TRAVIS_BUILD_DIR/ci/travis_install_conda.sh

# Build libhs2client

conda build conda.recipe --channel cloudera/channel/dev
CONDA_PACKAGE=`conda build --output conda.recipe | grep bz2`

if [ $TRAVIS_BRANCH == "master" ] && [ $TRAVIS_PULL_REQUEST == "false" ]; then
  anaconda --token $ANACONDA_TOKEN upload $CONDA_PACKAGE --user cloudera --channel dev;
fi

# Build python-hs2client

cd $TRAVIS_BUILD_DIR/python

build_for_python_version() {
  PY_VERSION=$1
  conda build conda.recipe --python $PY_VERSION --channel cloudera/channel/dev
  CONDA_PACKAGE=`conda build --python $PY_VERSION --output conda.recipe | grep bz2`

  if [ $TRAVIS_BRANCH == "master" ] && [ $TRAVIS_PULL_REQUEST == "false" ]; then
    anaconda --token $ANACONDA_TOKEN upload $CONDA_PACKAGE --user cloudera --channel dev;
  fi
}

build_for_python_version 2.7
build_for_python_version 3.5
