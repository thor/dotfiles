
-------------------------------------------------------------------------------
-- Commands

-- Add buffer deletion command for more-than-one windows and buffers
vim.api.nvim_create_user_command('Bd', 'bp | sp | bn | bd', {})

