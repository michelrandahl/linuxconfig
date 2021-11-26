with (import <nixpkgs> {});
mkShell {
  buildInputs = [
    dotnet-sdk_5
    dotnet-netcore
    dotnetCorePackages.netcore_3_1
    dotnetCorePackages.sdk_5_0
  ];
  shellHook = ''
    TOOLS_PATH=~/.dotnet/tools
    FSAC=fsautocomplete
    ls $TOOLS_PATH/dotnet-$FSAC
    FSAC_EXISTS=$?
    if [ $FSAC_EXISTS > 0 ]; then
      dotnet tool install $FSAC --global
    fi
    dotnet tool install dotnet-search --global
    export DOTNET_ROOT="${pkgs.dotnet-sdk_5}"
    export PATH=$PATH:$TOOLS_PATH
    '';
}
