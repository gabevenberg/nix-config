{
  configs,
  pkgs,
  ...
}: {
  programs.nixvim = {
    plugins.lualine = {
      enable = true;
      alwaysDivideMiddle = true;
      iconsEnabled = true;
      sections = {
        lualine_a = [
          {name = "mode";}
        ];
        lualine_b = [
          {name = "branch";}
          {name = "diff";}
          {name = "diagnostics";}
        ];
        lualine_c = [
          {
            name = "filename";
            extraConfig = {path = 1;};
          }
        ];
        lualine_x = [
          {name = "encoding";}
          {name = "fileformat";}
          {name = "filetype";}
        ];
        lualine_y = [
          {name = "progress";}
        ];
        lualine_z = [
          {name = "location";}
        ];
      };

      inactiveSections = {
        lualine_a = [];
        lualine_b = [];
        lualine_c = [{name = "filename";}];
        lualine_x = [{name = "filetype";}];
        lualine_y = [];
        lualine_z = [];
      };

      tabline = {
        lualine_a = [
          {
            name = "buffers";
            extraConfig = {mode = 4;};
          }
        ];
        lualine_b = [];
        lualine_c = [];
        lualine_x = [];
        lualine_y = [];
        lualine_z = [
          {
            name = "tabs";
            extraConfig = {mode = 2;};
          }
        ];
      };

      winbar = {
        lualine_a = [];
        lualine_b = [];
        lualine_c = [];
        lualine_x = [];
        lualine_y = [];
        lualine_z = [];
      };
    };
  };
}
