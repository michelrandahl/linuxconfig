# nix-channel
# old https://nixos.org/channels/nixos-19.09
with (import <old> {});
mkShell {
  # propagatedBuildInputs = [glibc libgcc gcc linux-pam libstdcxx5];
  buildInputs = [
    jdk8
    leiningen
    clojure
  ];
}
