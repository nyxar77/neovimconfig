{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netcoredbg";
  version = "3.2.0-1092";
  src = fetchurl {
    url = "https://github.com/Samsung/netcoredbg/releases/download/${finalAttrs.version}/netcoredbg-linux-amd64.tar.gz";
    hash = "sha256-CA6zstIVJGX1mdOzPR7m50d5ThHMCjdz7GifXl8sWvo=";
  };
  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [ (lib.getLib stdenv.cc.cc) ];
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec/netcoredbg
    cp -r . $out/libexec/netcoredbg
    makeWrapper $out/libexec/netcoredbg/netcoredbg $out/bin/netcoredbg
    runHook postInstall
  '';
  meta = {
    description = "CoreCLR debugger for .NET";
    homepage = "https://github.com/Samsung/netcoredbg";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "netcoredbg";
  };
})
