with (import <unstable> {});
mkShell {
  buildInputs = [
    dotnet-sdk_6
  ];
  shellHook = ''
    TOOLS_PATH=~/.dotnet/tools
    FSAC=fsautocomplete
    # ls $TOOLS_PATH/dotnet-$FSAC
    # FSAC_EXISTS=$?
    # if [ $FSAC_EXISTS > 0 ]; then
    #   dotnet tool install $FSAC --global
    # fi
    dotnet tool install $FSAC --global
    dotnet tool update $FSAC --global
    dotnet tool install paket --global
    dotnet tool install dotnet-search --global
    export DOTNET_ROOT="${pkgs.dotnet-sdk_6}"
    export PATH=$PATH:$TOOLS_PATH
    '';
}
