{ shortRev ? "dev" }:
pkgs @ {
  lib,
  kernel ? pkgs.linuxPackages.kernel,
  kernelModuleMakeFlags ? pkgs.linuxPackages.kernelModuleMakeFlags,
  ...
}:

let
  mkPackage = overrides @ {
    kernel,
    kernelModuleMakeFlags,
    ...
  }: (kernel.stdenv.mkDerivation {
    pname = "yeetmouse";
    version = shortRev;
    src = lib.fileset.toSource {
      root = ./..;
      fileset = ./..;
    };

    setSourceRoot = "export sourceRoot=$(pwd)/source";
    nativeBuildInputs = with pkgs; kernel.moduleBuildDependencies ++ [
      makeWrapper
      autoPatchelfHook
    ];
    buildInputs = [
      kernel.stdenv.cc.cc.lib
      pkgs.glfw3
    ];

    makeFlags = kernelModuleMakeFlags ++ [
      "KBUILD_OUTPUT=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "-C"
      "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      "M=$(sourceRoot)/driver"
    ];

    preBuild = ''
      cp $sourceRoot/driver/config.sample.h $sourceRoot/driver/config.h
    '';

    buildFlags = [ "modules" ];
    installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
    installTargets = [ "modules_install" ];
  }).overrideAttrs (prev: overrides);

  makeOverridable =
    f: origArgs:
    let
      origRes = f origArgs;
    in
    origRes // { override = newArgs: f (origArgs // newArgs); };
in
  makeOverridable mkPackage { inherit kernel kernelModuleMakeFlags; }
