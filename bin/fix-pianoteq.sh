#!/usr/bin/env bash

# execute with directory as argument, like this:
# ./fix-postgres-embedded-db.sh /tmp/embedded-pg/PG-06e3a92a2edb6ddd6dbdf5602d0252ca/

# if something doesn't work 'locate' correct shared objects and replace
# or use `ls /nix/store | grep something`

PIANOTEQ="/home/michel/Pianoteq/Pianoteq 7/x86-64bit/Pianoteq 7"
PIANOTEQ_SO="/home/michel/Pianoteq/Pianoteq 7/x86-64bit/Pianoteq 7.so"
echo "fixing: $PIANOTEQ"

file "$PIANOTEQ"
ldd "$PIANOTEQ"

# NEW_RPATH="/run/current-system/sw/lib:$1lib"
NEW_INTERPRETER="/nix/store/2wrfwfdpklhaqhjxgq6yd257cagdxgph-glibc-2.32/lib/ld-linux-x86-64.so.2"

LIB_ASOUND="/nix/store/94ih212nc4nq8dy7vn03vzh9kk7znxk3-alsa-lib-1.2.4/lib/libasound.so.2"
LIB_FREETYPE="/nix/store/65gyai5wljjjacsp28g9davg79in3ma2-freetype-2.10.4/lib/libfreetype.so.6"

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

# note that you might need to 'patchelf --remove-needed <some-"not-found"-lib-path>'

echo ""
echo ""
echo "RESULT:"


file "$PIANOTEQ"
ldd "$PIANOTEQ"
