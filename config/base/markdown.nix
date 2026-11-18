{
  plugins.render-markdown = {
    enable = true;

    settings = {
      enabled = true;

      # Renderiza em Normal, Command e Terminal.
      # Insert permanece com Markdown editável.
      render_modes = [
        "n"
        "c"
        "t"
      ];

      heading = {
        sign = false;
        position = "inline";
        width = "full";
        border = true;
      };

      code = {
        sign = false;
        border = "thick";
        width = "block";
        left_pad = 2;
        right_pad = 2;
      };

      bullet = {
        icons = [
          "●"
          "○"
          "◆"
          "◇"
        ];
        right_pad = 1;
      };
    };
  };

  # Links, referências e navegação semântica
  lsp.servers.marksman.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>mr";
      action = "<cmd>RenderMarkdown toggle<cr>";
      options.desc = "Markdown: alternar renderização";
    }
    {
      mode = "n";
      key = "<leader>mt";
      action = "<cmd>Telescope lsp_document_symbols<cr>";
      options.desc = "Markdown: índice de seções";
    }
  ];
}
