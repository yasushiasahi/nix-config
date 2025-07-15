{
  pkgs ? import <nixpkgs> { },
  version,
  sha256,
}:
let
  inherit (pkgs)
    lib
    stdenv
    autoPatchelfHook
    fetchurl
    patchelf
    ;
  inherit (stdenv) mkDerivation;

in
mkDerivation {
  inherit version;

  name = "nodejs-${version}-binary";
  src = fetchurl {
    url = "https://nodejs.org/dist/v${version}/node-v${version}${
      if stdenv.isDarwin then "-darwin-x64" else "-linux-x64"
    }.tar.xz"; # this darwin/linux check doesn't work since sha is different for packages
    inherit sha256;
  };

  buildInputs = with pkgs; lib.optional stdenv.isLinux [ patchelf ];
  nativeBuildInputs = with pkgs; lib.optional stdenv.isLinux [ autoPatchelfHook ];

  installPhase = ''
    echo "installing nodejs"
    mkdir -p $out
    cp -r ./ $out/
  '';

  meta = with lib; {
    description = "Event-driven I/O framework for the V8 JavaScript engine";
    homepage = "https://nodejs.org";
    license = licenses.mit;
  };

}
