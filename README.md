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
