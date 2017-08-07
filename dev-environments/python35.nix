with import <nixpkgs> {};

(pkgs.python35.withPackages (ps: [ps.numpy
                                  ps.toolz
                                  ps.scipy
                                  ps.scikitlearn
                                  ps.pillow
                                  ps.ipython
                                  ps.pip
                                  ps.tkinter
                                  ps.matplotlib])).env
