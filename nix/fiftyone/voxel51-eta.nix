{ lib
, substituteAll
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "voxel51-eta";
  version = "0.7.0";

  src = python3Packages.fetchPypi{
    inherit pname version;
    hash = "sha256-mb6v5c7FfIZ4TM3ePztLhtKkCnvAywcKsj8K7jVXov8=";
  };

  patches = [
    ./choose-correct-opencv.patch
  ];

  nativeBuildInputs = with python3Packages; [
    argcomplete
    dill
    future
    glob2
    importlib-metadata
    ndjson
    numpy
    packaging
    patool
    pillow
    python-dateutil
    pytz
    requests
    retrying
    six
    scikitimage
    opencv4
    sortedcontainers
    tabulate
    tzlocal
    urllib3
  ];

  doCheck = false;
}
