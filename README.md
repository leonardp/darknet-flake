# darknet-flake
flake for [AlexeyAB/darknet](https://github.com/AlexeyAB/darknet)

try the demo!
```
nix flake new --template github:leonardp/darknet-flake#demo-yolo-tiny ./darknet-flake-demo
cd ./darknet-flake-demo
nix develop
```
this will open a jupyter notebook in your browser
run `demo.ipynb` to see yolov4 in action

### Note:
The fiftyone application does not work for [local data](https://voxel51.com/docs/fiftyone/environments/index.html#local-data).
The package fiftyone-db is a precompiled mongodb binary which is wrapped by the main application.
The other storage environments *might work* but are untested.
