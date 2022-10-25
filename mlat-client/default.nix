{ python310, fetchFromGitHub }: (

python310.pkgs.buildPythonPackage rec {
  pname = "mlat-client";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "adsbxchange";
    repo = "mlat-client";
    rev = "faf9638fe8c2eafc2abdc45621ff879c7acb882b";
    sha256 = "0v2f5ikl7salvvqxwq1n8v4z7p4m2yg6kxd5hpyd8pl1i6jwpzsp";
  };
}

)
