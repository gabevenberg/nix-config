{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.feh.enable = true;

  programs.nushell.extraConfig = ''
    # display a slideshow of all pics in a directory, recursively
    def slideshow [delay: int = 10] {
        feh --full-screen --randomize --auto-zoom --recursive --slideshow-delay $delay
    }
  '';
  programs.zsh.shellAliases. slideshow = "feh --full-screen --randomize --auto-zoom --recursive --slideshow-delay";
}
