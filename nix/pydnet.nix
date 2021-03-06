{ lib
, fetchgit
, substituteAll
, python3Packages
, darknet
, enableGtk3 ? true
, gtk3
, opencv
}:
let
  cvOverride = (if enableGtk3 then { enableGtk3=true; } else { } );
in

python3Packages.buildPythonPackage rec {
  pname = "pydnet";
  version = "0.0.1";

  #src = ./work/pydnet;
  src = fetchgit {
    #inherit pname version;
    url = "https://github.com/leonardp/pydnet";
    rev = "2964746bae62f04dc86731b07920aadfc9ba86d1";
    hash = "sha256-wGmQeHJRgPqkYFj7CW484s3UuzX5sr/QdKsKGs2HS3s=";
  };

  buildInputs = [
    #opencvGtk
    (python3Packages.opencv4.override cvOverride)
  ];

  patches = [
    (substituteAll {
      src = ./pydnet-library-path.patch;
      darknet = "${darknet}/lib/libdarknet.so";
    })
  ];

  # no worky (wrong path for darknet.py ?!)
  #postPatchPhase = ''
  #  sed -i 's|find_library("darknet")|"${darknet}/lib/libdarknet.so"|' darknet.py
  #'';

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/leonardp/pydnet";
    description = "Python bindings and applications for AlexeyAB/darknet";
    license = licenses.gpl3;
  };
}
