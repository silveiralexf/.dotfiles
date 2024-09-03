return {
  -- behaviours
  automatically_reload_config = true,
  exit_behavior = 'CloseOnCleanExit', -- if the shell program exited with a successful status
  exit_behavior_messaging = 'Verbose',
  status_update_interval = 1000,

  -- This should be set to at least the sum of the number of lines in the panes in a tab.
  -- eg: if you have an 80x24 terminal split left/right then you should set this to at least 2x24 = 48
  -- Setting it smaller than that will harm performance
  line_quad_cache_size = 1024,

  -- Should also be set >= number of lines as above.
  -- Values are relatively small, may not need adjustment.
  line_state_cache_size = 1024,

  -- Should also be set >= number of lines as above.
  -- Values are relatively small, may not need adjustment.
  line_to_ele_shape_cache_size = 1024,

  -- should be >= the number of different attributed runs on the screen.
  -- hard to suggest a min size: try reducing until you notice performance getting bad.
  shape_cache_size = 1024,

  hyperlink_rules = {
    -- Matches: a URL in parenthesis: (URL)
    {
      regex = '\\((\\w+://\\S+)\\)',
      format = '$1',
      highlight = 1,
    },
    -- Matches: a URL in brackets: [URL]
    {
      regex = '\\[(\\w+://\\S+)\\]',
      format = '$1',
      highlight = 1,
    },
    -- Matches: a URL in curly braces: {URL}
    {
      regex = '\\{(\\w+://\\S+)\\}',
      format = '$1',
      highlight = 1,
    },
    -- Matches: a URL in angle brackets: <URL>
    {
      regex = '<(\\w+://\\S+)>',
      format = '$1',
      highlight = 1,
    },
    -- Then handle URLs not wrapped in brackets
    {
      regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
      format = '$0',
    },
    -- implicit mail-to link
    {
      regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
      format = 'mailto:$0',
    },
  },
}
