{lib}: {
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
}
