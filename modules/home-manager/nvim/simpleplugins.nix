{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.user.nvim.enable {
    programs.nixvim = {
      plugins.comment.enable = true;
      plugins.marks.enable = true;
      plugins.surround.enable = true;
      plugins.todo-comments.enable = true;
      plugins.leap = {
        enable = true;
        addDefaultMappings = true;
      };
      extraPlugins = with pkgs.vimPlugins; [
        vim-numbertoggle
        dressing-nvim
      ];
      extraConfigLua = ''require("dressing").setup({})'';
    };
  };
}
