{
  buildDotnetGlobalTool,
  dotnetCorePackages,
  lib,
}:

buildDotnetGlobalTool {
  pname = "easy-dotnet-server";
  nugetName = "EasyDotnet";
  version = "3.4.30";
  nugetHash = "sha256-ajeY7sg+VCbPYFPvTdzaGKI5AWgfXMfWE4vrMtfQwfk=";
  executables = [ "dotnet-easydotnet" ];
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.sdk_8_0;

  meta = {
    description = "Backend for easy-dotnet.nvim";
    homepage = "https://github.com/GustavEikaas/easy-dotnet-server";
    license = lib.licenses.mit;
    mainProgram = "dotnet-easydotnet";
  };
}
