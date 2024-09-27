{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      plugins.lualine = {
        enable = true;
        settings = {
          options = {
            alwaysDivideMiddle = true;
            icons_enabled = true;
          };
          sections = {
            lualine_a = [
              "mode"
            ];
            lualine_b = [
              "branch"
              "diff"
              "diagnostics"
            ];
            lualine_c = [
              {
                __unkeyed = "filename";
                path = 1;
              }
            ];
            lualine_x = [
              "encoding"
              "fileformat"
              "filetype"
            ];
            lualine_y = [
              "progress"
            ];
            lualine_z = [
              "location"
            ];
          };

          inactiveSections = {
            lualine_a = [];
            lualine_b = [];
            lualine_c = ["filename"];
            lualine_x = ["filetype"];
            lualine_y = [];
            lualine_z = [];
          };

          tabline = {
            lualine_a = [
              {
                __unkeyed = "buffers";
                mode = 4;
              }
            ];
            lualine_b = [];
            lualine_c = [];
            lualine_x = [];
            lualine_y = [];
            lualine_z = [
              {
                __unkeyed="tabs";
                mode = 2;
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
    };
  };
}
