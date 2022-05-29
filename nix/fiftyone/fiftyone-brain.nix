{ lib
, substituteAll
, python3Packages
}:

python3Packages.buildPythonPackage rec {
  pname = "fiftyone-brain";
  version = "0.8.2";

  src = python3Packages.fetchPypi{
    inherit pname version;
    hash = "sha256-WNWv4D34EyXo6HJs4v1Z1ePW3lCretutTdy7pmKtZF4=";
  };

  nativeBuildInputs = with python3Packages; [
    scipy
    scikit-learn
  ];

  doCheck = false;
}
