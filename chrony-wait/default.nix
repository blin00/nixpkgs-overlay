{ lib, writeShellScriptBin, coreutils, chrony }:

writeShellScriptBin "chrony-wait" ''
  export PATH="$PATH''${PATH:+:}${coreutils}/bin:${chrony}/bin"
  ${builtins.readFile ./chrony-wait.sh}
''
