with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    purescript
    nodePackages.purescript-language-server
    spago
  ];
}
