{ lib
, substituteAll
, python3Packages
, fiftyone-brain
, voxel51-eta
, fiftyone-db
, uap3
}:

python3Packages.buildPythonPackage rec {
  pname = "fiftyone";
  version = "0.15.1";

  src = python3Packages.fetchPypi{
    inherit pname version;
    hash = "sha256-pVqsHXLSOkxYeGzghYz6P3CB43ak5vcYy57uDyhHcKY=";
  };

  patches = [
    ./fix-dependencies.patch
  ];

  nativeBuildInputs = with python3Packages; [
    aiofiles
    argcomplete
    boto3
    dacite
    eventlet
    future
    hypercorn
    jinja2
    #kaleido
    matplotlib
    mongoengine
    motor
    ndjson
    numpy
    packaging
    pandas
    pillow
    plotly
    pprintpp
    psutil
    pymongo
    pytz
    pyyaml
    retrying
    scikit-learn
    scikitimage
    setuptools
    sseclient-py
    #sse-starlette
    starlette
    #strawberry-graphql
    tabulate
    xmltodict
    #universal-analytics-python3
    uap3
    fiftyone-brain
    fiftyone-db
    voxel51-eta
    opencv4
    plotly
  ];

  #doCheck = false;
}
