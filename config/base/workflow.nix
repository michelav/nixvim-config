{
  plugins = {
    oil.enable = true;
    trouble.enable = true;
    telescope.enable = true;
    web-devicons.enable = true;
    nvim-tree = {
      enable = true;
      autoClose = true;
      settings = {
        actions.open_file.quit_on_open = true;
      };
    };
    nvim-autopairs.enable = true;
    nvim-surround.enable = true;
  };
  keymaps = [
    {
      action = ":NvimTreeToggle<cr>";
      key = "<leader>e";
      mode = [ "n" ];
    }
  ];
}
