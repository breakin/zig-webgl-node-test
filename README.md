This is a small test of ziglang+wasm+webgl2+node.
Some WebGL code with unknown license was lifted from https://github.com/raulgrell/tetris (https://github.com/raulgrell).

# Status

This is very much a work-in-progress test that I am making to learn using zig for the web.
It is also my first zig program!

# Build

Make sure you put zig 0.6 in path somewhere such that the command "zig" exists. Then do

´npm install
npm run build
npm run serve´

If all went well you can see the result by browsing https://localhost:8000 in chrome/firefox.
Webgl2 is required.