{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.password-store = {
    enable = true;
    settings={
      PASSWORD_STORE_DIR = "$HOME/keys/password-store";
    };
  };

  home.packages = with pkgs; [
    ripasso-cursive
  ];

  programs.nushell.extraEnv = ''
    $env.PASSWORD_STORE_DIR = ($env.HOME | path join "keys" "password-store")
  '';
}
