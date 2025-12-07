{ python311, fetchFromGitHub }: (

python311.pkgs.buildPythonPackage rec {
  pname = "mlat-client";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "adsbxchange";
    repo = "mlat-client";
    rev = "fabefdc3543702c6ef950111b94981162c45147d";
    sha256 = "1s336ls0sll49bqcidwx9dprby11dvvkpxb64l66m11wknhk4n7c";
  };
  pyproject = true;
  build-system = [ python311.pkgs.setuptools ];
}

)
