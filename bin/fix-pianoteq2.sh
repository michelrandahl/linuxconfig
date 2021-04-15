#!/usr/bin/env bash

# if something doesn't work 'locate' correct shared objects and replace
# or use `ls /nix/store | grep something`

PIANOTEQ="/home/michel/Pianoteq/Pianoteq 7-new/Pianoteq 7/x86-64bit/Pianoteq 7"
PIANOTEQ_SO="/home/michel/Pianoteq/Pianoteq 7-new/Pianoteq 7/x86-64bit/Pianoteq 7.so"
echo "fixing: $PIANOTEQ"

file "$PIANOTEQ"
ldd "$PIANOTEQ"

# NEW_RPATH="/run/current-system/sw/lib:$1lib"
NEW_INTERPRETER="/nix/store/a6rnjp15qgp8a699dlffqj94hzy1nldg-glibc-2.32/lib/ld-linux-x86-64.so.2"

LIB_ASOUND="/nix/store/f7k0y5zdifzpq3gcv98vm303kmby38p1-alsa-lib-1.2.4/lib/libasound.so.2"
LIB_FREETYPE="/nix/store/h5bd4parl53gk0kq73r15fjdfsc6iclv-freetype-2.10.2/lib/libfreetype.so.6"
LIB_X11="/nix/store/pk2m3xqjcmpdlqqrsbnasrsparyhb62i-libX11-1.7.0/lib/libX11.so.6"
LIB_STD_CPP="/nix/store/vran8acwir59772hj4vscr7zribvp7l5-gcc-9.3.0-lib/lib/libstdc++.so.6"

# CPP_LIB_DIR="/nix/store/51hq0xxp9nng3xxfz7dpkhb9lzy7sz84-gcc-9.3.0-lib/lib/libstdc++.so.6"
# 
# echo "PROBLEMS:"
# file $1bin/*
# ldd $1bin/*
# echo "new ld-linux"
# file $NEW_LD_LINUX
# 
# # default interpreter is pointing to a wrong file
patchelf --set-interpreter $NEW_INTERPRETER "$PIANOTEQ"

# # default r-path cannot find multiple shared objects
patchelf --add-needed $LIB_ASOUND "$PIANOTEQ"
patchelf --add-needed $LIB_FREETYPE "$PIANOTEQ"
patchelf --add-needed $LIB_FREETYPE "$PIANOTEQ_SO"
patchelf --add-needed $LIB_X11 "$PIANOTEQ_SO"
patchelf --add-needed $LIB_STD_CPP "$PIANOTEQ_SO"

# note that you might need to 'patchelf --remove-needed <some-"not-found"-lib-path>'

echo ""
echo ""
echo "RESULT:"


file "$PIANOTEQ"
ldd "$PIANOTEQ"
