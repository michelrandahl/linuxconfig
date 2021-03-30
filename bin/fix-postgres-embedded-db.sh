#!/usr/bin/env bash

# execute with directory as argument, like this:
# ./fix-postgres-embedded-db.sh /tmp/embedded-pg/PG-06e3a92a2edb6ddd6dbdf5602d0252ca/

# if something doesn't work 'locate' correct shared objects and replace

echo "fixing directory: $1"

# NEW_RPATH="/run/current-system/sw/lib:/tmp/embedded-pg/PG-06e3a92a2edb6ddd6dbdf5602d0252ca/lib"
NEW_RPATH="/run/current-system/sw/lib:$1lib"

# NEW_LD_LINUX="/nix/store/xdsjx0gba4id3yyqxv66bxnm2sqixkjj-glibc-2.27/lib/ld-linux-x86-64.so.2"
# NEW_LD_LINUX="/nix/store/xlxiw4rnxx2dksa91fizjzf7jb5nqghc-glibc-2.27/lib/ld-linux-x86-64.so.2"
# NEW_LD_LINUX="/nix/store/2wrfwfdpklhaqhjxgq6yd257cagdxgph-glibc-2.32/lib/ld-linux-x86-64.so.2"
NEW_LD_LINUX="/nix/store/9l06v7fc38c1x3r2iydl15ksgz0ysb82-glibc-2.32/lib/ld-linux-x86-64.so.2"


# CPP_LIB_DIR="/nix/store/sf0wnp30savqz9ljn6fsrn8f63w5v0za-gcc-7.4.0-lib/lib/libstdc++.so.6"
# CPP_LIB_DIR="/nix/store/hlnxw4k6931bachvg5sv0cyaissimswb-gcc-7.4.0-lib/lib/libstdc++.so.6"
CPP_LIB_DIR="/nix/store/51hq0xxp9nng3xxfz7dpkhb9lzy7sz84-gcc-9.3.0-lib/lib/libstdc++.so.6"

echo "PROBLEMS:"
file $1bin/*
ldd $1bin/*
echo "new ld-linux"
file $NEW_LD_LINUX

# default interpreter is pointing to a wrong file
patchelf --set-interpreter $NEW_LD_LINUX $1bin/pg_ctl
patchelf --set-interpreter $NEW_LD_LINUX $1bin/initdb
patchelf --set-interpreter $NEW_LD_LINUX $1bin/postgres

# default r-path cannot find multiple shared objects
patchelf --set-rpath $NEW_RPATH $1bin/postgres
patchelf --set-rpath $NEW_RPATH $1bin/initdb


# we can't add this one to the rpath for some reason, so we just make a link instead
# rm $CPP_LIB_DIR $1lib/libstdc++.so.6 # remove file if it exists already
rm $1lib/libstdc++.so.6 # remove file if it exists already
ln -s $CPP_LIB_DIR $1lib/libstdc++.so.6

echo ""
echo ""
echo "RESULT:"


file $1bin/*
ldd $1bin/*
