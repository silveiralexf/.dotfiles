Feature: Neovim keymaps
  Custom keymaps are registered in config/keymaps.lua. Critical keys must
  exist so that LSP, fuzzy finder, and editor flows work.

  Scenario: LSP keymaps are registered
    Given Neovim keymaps are loaded with a vim mock
    When I inspect registered keymaps
    Then key "K" in normal mode is mapped to LSP hover
    And key "<leader>k" in normal mode is mapped to WhichKey

  Scenario: FzfLua keymaps are registered
    Given Neovim keymaps are loaded with a vim mock
    When I inspect registered keymaps
    Then key "\\z" in normal mode is mapped to FzfLua
    And key "\\zb" in normal mode is mapped to FzfLua buffers
