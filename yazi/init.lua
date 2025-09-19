-- proper display of filesize and mtime
function Linemode:size_and_mtime()
  local time = math.floor(self._file.cha.mtime or 0)
  if time == 0 then
    time = ''
  elseif os.date('%Y', time) == os.date('%Y') then
    time = os.date('%b %d %H:%M', time)
  else
    time = os.date('%b %d  %Y', time)
  end

  local size = self._file:size()
  return string.format('%s %s', size and ya.readable_size(size) or '-', time)
end

-- [Plugin] https://github.com/hankertrix/augment-command.yazi
require('augment-command'):setup({
  prompt = true,
  default_item_group_for_prompt = 'none',
  open_file_after_creation = true,
  enter_directory_after_creation = true,
  extract_retries = 5,
  encrypt_archives = true,
  smooth_scrolling = true,
  create_item_delay = 0.1,
  wraparound_file_navigation = false,
})

-- [Plugin] https://github.com/dedukun/relative-motions.yazi
require('relative-motions'):setup({
  show_numbers = 'relative',
  show_motion = true,
  enter_mode = 'first',
})

-- Configure the git plugin
---@diagnostic disable-next-line: inject-field
th.git = th.git
  or {

    -- Colours
    modified = ui.Style():fg('#0096DB'),
    added = ui.Style():fg('#239549'),
    untracked = ui.Style():fg('#B0B0B0'),
    ignored = ui.Style():fg('#B0B0B0'),
    deleted = ui.Style():fg('#D32752'),

    -- Unmerged
    updated = ui.Style():fg('#CD32C0'),

    -- Icons
    modified_sign = '',
    added_sign = '',
    untracked_sign = '󱋽',
    ignored_sign = '',
    deleted_sign = '',

    -- Unmerged
    updated_sign = '',
  }

-- Set up the git plugin
require('git'):setup()
