{ fetchFromGitHub, rustPlatform, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "gratttool";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "hackgnar";
    repo = "gratttool";
    rev = "v${version}";
    hash = "sha256-AT4/R3usfhqEkNfkzuEPUIENgvIdtsfGh2nBLhwayyE=";
  };

  cargoHash = "sha256-xKhU4hopPV2TeIFF0Ocjf8KBMPu0nBxCIlA8284g220=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];
}
