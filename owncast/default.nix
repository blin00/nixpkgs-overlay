{ stdenv, lib, buildGoModule, fetchFromGitHub }:

let
  version = "0.0.8";
  src = fetchFromGitHub {
    owner = "owncast";
    repo = "owncast";
    rev = "v${version}";
    sha256 = "0md4iafa767yxkwh6z8zpcjv9zd79ql2wapx9vzyd973ksvrdaw2";
  };

in 
buildGoModule {
  inherit src version;
  pname = "owncast";
  vendorSha256 = "sha256-bH2CWIgpOS974/P98n0R9ebGTJ0YoqPlH8UmxSYNHeM=";

  postInstall = ''
    mkdir -p $out/share
    cp -r static webroot $out/share
  '';

  meta = with lib; {
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
