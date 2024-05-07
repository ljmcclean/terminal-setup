local modes = {
  ['n'] = 'NORMAL',
  ['no'] = 'NORMAL',
  ['v'] = 'VISUAL',
  ['V'] = 'VISUAL LINE',
  ['␖'] = 'VISUAL BLOCK',
  ['s'] = 'SELECT',
  ['S'] = 'SELECT LINE',
  ['␓'] = 'SELECT BLOCK',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['Rv'] = 'VISUAL REPLACE',
  ['c'] = 'COMMAND',
  ['cv'] = 'VIM EX',
  ['ce'] = 'EX',
  ['r'] = 'PROMPT',
  ['rm'] = 'MOAR',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  ['t'] = 'TERMINAL',
}

local function get_mode()
  local cur_mode = vim.api.nvim_get_mode().mode
  return string.format(' %s ', modes[cur_mode]):upper()
end

local function get_mode_clr()
  local cur_mode = vim.api.nvim_get_mode().mode
  local mode_clr = '%#StatusLineAccent#'
  if cur_mode == 'n' then
    mode_clr = '%#StatuslineAccent#'
  elseif cur_mode == 'i' or cur_mode == 'ic' then
    mode_clr = '%#StatuslineInsertAccent#'
  elseif cur_mode == 'v' or cur_mode == 'V' or cur_mode == '' then
    mode_clr = '%#StatuslineVisualAccent#'
  elseif cur_mode == 'R' then
    mode_clr = '%#StatuslineReplaceAccent#'
  elseif cur_mode == 'c' then
    mode_clr = '%#StatuslineCmdLineAccent#'
  elseif cur_mode == 't' then
    mode_clr = '%#StatuslineTerminalAccent#'
  end
  return mode_clr
end

local function get_filename()
  local name = vim.fn.expand '%:t'
  return name
end

local function get_lsp_counts()
  local count = {}
  local levels = {
    errors = 'Error',
    warnings = 'Warn',
    hints = 'Hint',
    info = 'Info',
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ''
  local warnings = ''
  local hints = ''
  local info = ''

  if count['errors'] ~= 0 then
    errors = ' %#LspDiagnosticsSignError#[X' .. count['errors'] .. '] '
  end
  if count['warnings'] ~= 0 then
    warnings = ' %#LspDiagnosticsSignWarning#[!' .. count['warnings'] .. '] '
  end
  if count['hints'] ~= 0 then
    hints = ' %#LspDiagnosticsSignHint#[^' .. count['hints'] .. '] '
  end
  if count['info'] ~= 0 then
    info = ' %#LspDiagnosticsSignInformation#[?' .. count['info'] .. '] '
  end

  return string.format('%s %s %s %s', errors, warnings, hints, info)
end

local function get_filetype()
  return string.format('%s', vim.bo.filetype):upper()
end

local function get_pos_info()
  if vim.bo.filetype == 'alpha' then
    return ''
  end
  return ' %P %l:%c '
end

Statusline = {}

function Statusline.active()
  return table.concat {
    '%#StatusLine#',
    get_mode_clr(),
    get_mode(),
    '%#Normal #',
    get_filename(),
    '%#Normal# ',
    get_lsp_counts(),
    '%=%#StatusLineExtra# ',
    get_filetype(),
    get_pos_info(),
  }
end

function Statusline.short()
  return string.format('%s %s', get_filename(), get_filetype())
end

vim.cmd [[
  augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  autocmd WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]]
