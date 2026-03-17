{
  fetchFromGitHub,
  lib,
  nixosTests,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "agnos";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "blin00";
    repo = "agnos";
    rev = "39dc00130462fdd358c3368d8a7a842902c2cee9";
    hash = "sha256-DfqGCvZHO9POBY8qdYlbTfpu1HLeeYpxhTJJDWjTSHw=";
  };

  cargoHash = "sha256-yDpFz2GTg3+ZuM+8uaQklM0ggbrsITwjD53hL+hHyFs=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Obtains certificates from Let's Encrypt using DNS-01 without the need for API access to the DNS provider";
    homepage = "https://github.com/krtab/agnos";
    license = lib.licenses.mit;
    # maintainers = with lib.maintainers; [ justinas ];
  };

  passthru.tests = nixosTests.agnos;
}
