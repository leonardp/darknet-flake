{ stdenv
, lib
, fetchgit
, cmake
#, pkg-config # only needed if not using cmake
, opencvSupport ? true
, opencv
, cudaSupport ? false
, cudnnSupport ? false
, cudaPackages
, addOpenGLRunpath
}:

stdenv.mkDerivation rec {
  pname = "darknet";
  version = "YOLOv4";

  src = fetchgit {
    url = "https://github.com/leonardp/darknet";
    rev = "9cb6ea27c5ac3cd9bfec360e5ae95fe5d3d0658f";
    hash = "sha256-P6qK+F2Q45EeqZygaGupjMug4lYS4bOVnPS59zgnXiM=";
  };

  # not working -> forked
  #patches = [ ./rename-build-dir.patch ];
  patches = [ ./do-not-build-uselib.patch ];

  postFixup = lib.mkIf cudaSupport ''
    addOpenGLRunpath darknet
    addOpenGLRunpath libdarknet.so
  '';

  #nativeBuildInputs = [ pkg-config ]; # pkg-config needed if not using cmake
  nativeBuildInputs = [ cmake addOpenGLRunpath ];

  buildInputs = [ ]
    ++ lib.optional opencvSupport opencv
    ++ lib.optional cudaSupport cudaPackages.cudatoolkit
    ++ lib.optional cudnnSupport cudaPackages.cudnn
  ;

  propagatedBuildInputs = [ opencv ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    (if opencvSupport then "-DENABLE_OPENCV=ON" else "-DENABLE_OPENCV=OFF")
    (if cudaSupport then "-DENABLE_CUDA=ON" else "-DENABLE_CUDA=OFF")
    (if cudnnSupport then "-DENABLE_CUDNN=ON" else "-DENABLE_CUDNN=OFF")
    # 2x speedup in detection using Volta/Turing Tensor Cores
    "-DENABLE_CUDNN_HALF=OFF"
    "-DENABLE_ZED_CAMERA=OFF"
    "-DENABLE_VCPKG_INTEGRATION=OFF"
    "-DVCPKG_USE_OPENCV4=ON"
    "-DVCPKG_BUILD_OPENCV_WITH_CUDA=OFF"
    "-DUSELIB_TRACK=OFF"
  ];

  installPhase = ''
    mkdir -p $out/bin;
    mkdir -p $out/lib;
    mkdir -p $out/include;
    install -t $out/bin darknet;
    install -t $out/lib libdarknet.so;
    install -t $out/include $src/include/darknet.h;
  '';
}
