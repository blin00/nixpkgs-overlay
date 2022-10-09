{ lib, writeShellScriptBin, coreutils }:

writeShellScriptBin "fake-hwclock" ''
  export PATH="$PATH''${PATH:+:}${coreutils}/bin"
  ${builtins.readFile ./fake-hwclock.sh}
''
