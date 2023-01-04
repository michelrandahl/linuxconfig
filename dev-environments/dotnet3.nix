with (import <nixpkgs> {});
mkShell {
  name = "dotnet-env";
  buildInputs = [
    #dotnet-sdk_5
    #dotnet-sdk_6
    #dotnet-netcore
    omnisharp-roslyn
    # azure-functions-core-tools
    # dotnetCorePackages.netcore_3_1
    # dotnetCorePackages.runtime_3_1
    # dotnetCorePackages.sdk_5_0
    # dotnetCorePackages.sdk_6_0
    # dotnetPackages.Paket
  ];
  packages = [
    (with dotnetCorePackages; combinePackages [
      #sdk_5_0
      #sdk_6_0
      sdk_3_1
    ])
  ];
  shellHook = ''
    TOOLS_PATH=~/.dotnet/tools
    FSAC=fsautocomplete

    dotnet tool install $FSAC --global
    dotnet tool install paket --global
    dotnet tool install dotnet-search --global
    dotnet tool install fake-cli --global

    export DOTNET_ROOT="${pkgs.dotnet-sdk_3}"
    export PATH=$PATH:$TOOLS_PATH
    '';
}
