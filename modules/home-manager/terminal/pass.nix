{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.password-store = {
    enable = true;
  };

  home.packages = with pkgs; [
    ripasso-cursive
  ];

  programs.nushell.extraEnv = ''
    $env.PASSWORD_STORE_DIR = ($env.XDG_DATA_HOME | path join "password-store")
  '';
}
