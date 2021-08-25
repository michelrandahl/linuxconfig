with (import <unstable> {});
mkShell {
  buildInputs = [
    purescript
    nodePackages.purescript-language-server
  ];
}
