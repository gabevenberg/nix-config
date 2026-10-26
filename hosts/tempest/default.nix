# home desktop
{
  inputs,
  myLib,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs myLib;};
  modules =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.disko.nixosModules.disko
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.nixos-hardware.nixosModules.common-pc
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      ./disk-config.nix
      ./hardware-config.nix
      ../../configs/nixos/common.nix
      ../../configs/nixos/sshd.nix
      ../../configs/nixos/interactive-networking.nix
      ../../configs/nixos/secrets.nix
      ../../configs/nixos/tailscale.nix
      ../../configs/nixos/syncthing.nix
      ../../configs/nixos/graphical.nix
      ../../configs/nixos/bluetooth.nix
      ../../configs/nixos/ntfy.nix
      ../../roles/nixos/gaming.nix
      ../../roles/nixos/embedded-dev
      ({
        config,
        pkgs,
        ...
      }: let
        switchAudioOutput = pkgs.callPackage ./switch-audio-out.nix {};
        tvToggle = pkgs.callPackage ./tv.nix {};
      in {
        nixpkgs.hostPlatform = "x86_64-linux";
        host.details = {
          user = "gabe";
          fullName = "Gabe Venberg";
          gui.enable = true;
        };
        host.niri.enable = true;
        host.niri.shell = "noctalia";
        networking.hostName = "tempest";
        networking.hostId = "d46bca4f";

        home-manager.sharedModules = [inputs.sops-nix.homeManagerModules.sops];
        home-manager.users.${config.host.details.user} = {
          inputs,
          osConfig,
          lib,
          ...
        }: {
          host.details = osConfig.host.details;
          user = {
            git = {
              profile = {
                name = config.host.details.fullName;
                email = "gabevenberg@gmail.com";
              };
            };
          };

          xsession.windowManager.i3.config.keybindings = {
            "Mod4+ctrl+p" = "exec --no-startup-id ${lib.getExe switchAudioOutput}";
          };
          wayland.windowManager.niri.settings.binds."Mod+Ctrl+P" = {
            _props.hotkey-overlay-title = "Switch Audio Output";
            spawn = [(lib.getExe switchAudioOutput)];
          };

          home.packages = with pkgs; [
            tvToggle
            signal-desktop
            uhk-agent
            cameractrls
            v4l-utils
            gimp
            obs-studio
            yt-dlp
          ];

          imports = [
            ../../roles/home-manager/terminal.nix
            ../../roles/home-manager/music.nix
            ../../roles/home-manager/3dprinting.nix
            ../../roles/home-manager/all_the_langs.nix
            ../../roles/home-manager/music-prod.nix
            ../../configs/home-manager/common.nix
            ../../configs/home-manager/secrets.nix
            ../../configs/home-manager/email.nix
            ../../configs/home-manager/senpai-irc.nix
            ../../configs/home-manager/ntfy.nix
            ../../configs/home-manager/kicad.nix
            ../../configs/home-manager/anki.nix
          ];

          sops = lib.mkIf (inputs ? nix-secrets) {
            secrets = {
              gmail-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
              irc-cert.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
              soju-password.sopsFile = "${inputs.nix-secrets}/workstations.yaml";
            };
          };
        };

        systemd.services.disable-alsa-auto-mute = {
          description = "Disables the soundcards auto-mute so that the main speaker can still be used even when headphones are plugged in.";
          script = "${pkgs.alsa-utils}/bin/amixer -c \"Generic\" sset \"Auto-Mute Mode\" Disabled";
          wantedBy = ["multi-user.target"];
        };

        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        # boot.loader.efi.canTouchEfiVariables = false;
        # without this, WOL causes the machine to boot right after shutdown.
        boot.kernelParams = ["xhci_hcd.quirks=270336"];

        # This value determines the NixOS release from which the default
        # settings for stateful data, like file locations and database versions
        # on your system were taken. It‘s perfectly fine and recommended to leave
        # this value at the release version of the first install of this system.
        # Before changing this value read the documentation for this option
        # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
        system.stateVersion = "25.11"; # Did you read the comment?
      })
    ]
    ++ (inputs.nixpkgs.lib.optional (inputs ? nix-secrets) "${toString inputs.nix-secrets}/nix/hosts/tempest.nix");
}
