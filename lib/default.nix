{lib}: let
  net = import ./net.nix {inherit lib;};
in {
  dirToStrings = dir: (map (v: builtins.readFile "${dir}/${v}")
    (builtins.filter (v:
      (builtins.readFileType "${dir}/${v}") == "regular") (
      if (builtins.pathExists dir && (builtins.readFileType dir) == "directory")
      then
        builtins.attrNames (
          builtins.readDir dir
        )
      else []
    )));

  calcSystemdDhcpPoolOffset = {
    base,
    start,
    end,
  }: {
    offset = net.lib.net.ip.diff start base;
    size = net.lib.net.ip.diff end start;
  };
}
