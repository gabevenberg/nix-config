{
  configs,
  pkgs,
  lib,
  ...
}: {
  programs.nixvim = {
    options = {
      mouse = "a";
      lazyredraw = true;
      termguicolors = true;
      autoread = true;
      swapfile = false;
      history = 500;
      formatoptions = "rojq";
      # dont hard wrap
      textwidth = 0;
      wrapmargin = 0;
      breakindent = true;
      # highlight after col
      colorcolumn = "80,100,120";
      # add ruler to side of screen
      number = true;
      numberwidth = 3;
      #display cursor cordinates
      ruler = true;
      #always leave 5 cells between cursor and side of window
      scrolloff = 5;
      # better command line completion
      wildmenu = true;
      # ignore case if all lowercase
      ignorecase = true;
      smartcase = true;
      # show unfinished keycombos in statusbar
      showcmd = true;
      # regex stuff
      magic = true;
      # always show statusline
      laststatus = 2;
      # tab stuff
      tabstop = 4;
      shiftwidth = 0;
      autoindent = true;
      smartindent = true;
      smarttab = true;
      # for true tabs, change to false
      expandtab = true;
      softtabstop = -1;
      # highlight search results as you type
      hlsearch = true;
      incsearch = true;
      # folding stuff
      foldlevelstart = 5;
      foldmethod = lib.mkDefault "indent";
      foldcolumn = "auto:4";
      foldenable = true;
      # display whitespace as other chars
      list = true;
      listchars = {
        tab = ">-";
        eol = "↲";
        nbsp = "␣";
        trail = "•";
        extends = "⟩";
        precedes = "⟨";
      };
      showbreak = "↪";
    };
  };
}
