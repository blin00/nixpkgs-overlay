{ lib, writeShellScriptBin, coreutils }:

writeShellScriptBin "install-safe" ''
  export PATH="$PATH''${PATH:+:}${coreutils}/bin"
  ${builtins.readFile ./install-safe.sh}
''
