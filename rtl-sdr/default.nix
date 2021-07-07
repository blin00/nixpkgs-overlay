{ stdenv, lib, fetchgit, cmake, pkgconfig, libusb1 }:

stdenv.mkDerivation rec {
  pname = "rtl-sdr";
  version = "0.6git";

  src = fetchgit {
    url = "git://git.osmocom.org/rtl-sdr.git";
    rev = "0847e93e0869feab50fd27c7afeb85d78ca04631";
    sha256 = "0xzy0xiirzhwb3kbx5cnlfvn76z2220j2asaz7pz2cnb7rrvyjx2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake libusb1 ];

  # TODO: get these fixes upstream:
  # * Building with -DINSTALL_UDEV_RULES=ON tries to install udev rules to
  #   /etc/udev/rules.d/, and there is no option to install elsewhere. So install
  #   rules manually.
  # * Propagate libusb-1.0 dependency in pkg-config file.
  postInstall = lib.optionalString stdenv.isLinux ''
    mkdir -p "$out/etc/udev/rules.d/"
    cp ../rtl-sdr.rules "$out/etc/udev/rules.d/99-rtl-sdr.rules"
    pcfile="$out"/lib/pkgconfig/librtlsdr.pc
    grep -q "Requires:" "$pcfile" && { echo "Upstream has added 'Requires:' in $(basename "$pcfile"); update nix expression."; exit 1; }
    echo "Requires: libusb-1.0" >> "$pcfile"
  '';

  meta = with lib; {
    description = "Turns your Realtek RTL2832 based DVB dongle into a SDR receiver";
    homepage = http://sdr.osmocom.org/trac/wiki/rtl-sdr;
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
