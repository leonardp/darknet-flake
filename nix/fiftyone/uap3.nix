{ python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "universal-analytics-python3";
  version = "1.1.1";

  src = python3Packages.fetchPypi{
    inherit pname version;
    hash = "sha256-9Ytqt87yOJrv7YDxRbhz5EfcQIMlYzDxhxIng3kvf60=";
  };

  nativeBuildInputs = with python3Packages; [
    flake8
    httpx
    pytest-runner
  ];

  doCheck = false;
}
