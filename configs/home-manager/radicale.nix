{
  config,
  lib,
  ...
}: let
  khard = lib.getExe config.programs.khard.package;
  aercBinds = "${config.programs.aerc.package}/share/aerc/binds.conf";

 # TODO: watch https://github.com/pimalaya, their stack might be a nice replacement for khard and aerc.

  # reused in contacts and calendars
  remote = {
    url = "https://cal.venberg.xyz/";
    userName = "family";
    passwordCommand = ["cat" config.sops.secrets.radicale-password.path];
  };
  pimsync = {
    enable = true;
    extraPairDirectives = [
      {
        name = "collections";
        params = ["all"];
      }
    ];
  };
in {
  config = lib.mkIf (lib.hasAttrByPath ["sops" "secrets" "radicale-password"] config) {
    accounts.contact = {
      basePath = "${config.xdg.dataHome}/contacts";
      accounts.radicale = {
        remote = remote // {type = "carddav";};
        inherit pimsync;
        khard = {
          enable = true;
          type = "discover";
        };
      };
    };

    accounts.calendar = {
      basePath = "${config.xdg.dataHome}/calendars";
      accounts.radicale = {
        remote = remote // {type = "caldav";};
        inherit pimsync;
        noctalia.enable = true;
      };
    };

    programs.khard.enable = true;
    programs.pimsync.enable = true;
    services.pimsync.enable = true;

    # empty list is every calendar
    programs.noctalia.settings.calendar.account.radicale.calendars = [];

    programs.aerc = lib.mkIf config.programs.aerc.enable {
      extraConfig.compose.address-book-cmd = "${khard} email --remove-first-line --parsable %s";
      extraBinds =
        lib.replaceStrings
        ["[view]\n"]
        ["[view]\nca = :pipe -m ${khard} add-email<Enter>\n"]
        (builtins.readFile aercBinds);
    };
  };
}
