with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    dotnet-sdk_5
    dotnetCorePackages.netcore_3_1
  ];
  shellHook = ''
    TOOLS_PATH=~/.dotnet/tools
    FSAC=fsautocomplete
    ls $TOOLS_PATH/dotnet-$FSAC
    FSAC_EXISTS=$?
    if [ $FSAC_EXISTS > 0 ]; then
      dotnet tool install $FSAC --global
    fi
    export DOTNET_ROOT="${pkgs.dotnet-sdk_5}"
    export PATH=$PATH:$TOOLS_PATH
    '';
}
