local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	print("Failed to load which-key")
	return
end

local setup = {
	preset = "modern",
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	win = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	show_help = true, -- show help message on the command line when the popup is visible
}

local spec = {
	{ "<leader>a", group = "ai" },
	{ "gm", group = "+Copilot chat" },
	{ "gmh", desc = "Show help" },
	{ "gmd", desc = "Show diff" },
	{ "gmp", desc = "Show system prompt" },
	{ "gms", desc = "Show selection" },
	{ "gmy", desc = "Yank diff" },

	{
		"<leader>ap",
		function()
			local actions = require("CopilotChat.actions")
			require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
		end,
		desc = "CopilotChat - Prompt actions",
	},
	{
		"<leader>ap",
		":lua require('CopilotChat.integrations.telescope').pick(require('CopilotChat.actions').prompt_actions({selection = require('CopilotChat.select').visual}))<CR>",
		mode = "x",
		desc = "CopilotChat - Prompt actions",
	},
	-- Code related commands
	{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
	{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
	{ "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
	{ "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
	{ "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
	-- Chat with Copilot in visual mode
	{
		"<leader>av",
		":CopilotChatVisual",
		mode = "x",
		desc = "CopilotChat - Open in vertical split",
	},
	{
		"<leader>ax",
		":CopilotChatInline<cr>",
		mode = "x",
		desc = "CopilotChat - Inline chat",
	},
	-- Custom input for CopilotChat
	{
		"<leader>ai",
		function()
			local input = vim.fn.input("Ask Copilot: ")
			if input ~= "" then
				vim.cmd("CopilotChat " .. input)
			end
		end,
		desc = "CopilotChat - Ask input",
	},
	-- Generate commit message based on the git diff
	{
		"<leader>am",
		"<cmd>CopilotChatCommit<cr>",
		desc = "CopilotChat - Generate commit message for all changes",
	},
	-- Quick chat with Copilot
	{
		"<leader>aq",
		function()
			local input = vim.fn.input("Quick Chat: ")
			if input ~= "" then
				vim.cmd("CopilotChatBuffer " .. input)
			end
		end,
		desc = "CopilotChat - Quick chat",
	},
	-- Debug
	{ "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
	-- Fix the issue with diagnostic
	{ "<leader>af", "<cmd>CopilotChatFixDiagnostic<cr>", desc = "CopilotChat - Fix Diagnostic" },
	-- Clear buffer and chat history
	{ "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
	-- Toggle Copilot Chat Vsplit
	{ "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
	-- Copilot Chat Models
	{ "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
	{
		"<leader>F",
		"<cmd>Telescope live_grep theme=ivy<cr>",
		desc = "Find Text",
		nowait = true,
		remap = false,
	},
	{
		"<leader>b",
		group = "Buffers",
		nowait = true,
		remap = false,
	},
	{
		"<leader>bb",
		"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
		desc = "List Buffers",
	},
	{
		"<leader>bo",
		"<cmd>%bd|e#<cr>",
		desc = "Close all buffers except current", -- https://stackoverflow.com/a/42071865/516188
	},
	{
		"<leader>e",
		"<cmd>NvimTreeToggle<cr>",
		desc = "Explorer",
		nowait = true,
		remap = false,
	},
	{
		"<leader>f",
		"<cmd>lua require('telescope.builtin').find_files(require('telescope.themes', {hidden = true}).get_dropdown{previewer = false})<cr>",
		desc = "Find files",
		nowait = true,
		remap = false,
	},
	{
		"<leader>g",
		group = "Git",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gR",
		"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
		desc = "Reset Buffer",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gb",
		"<cmd>Telescope git_branches<cr>",
		desc = "Checkout branch",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gc",
		"<cmd>Telescope git_commits<cr>",
		desc = "Checkout commit",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gd",
		"<cmd>Gitsigns diffthis HEAD<cr>",
		desc = "Diff",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gg",
		"<cmd>lua _LAZYGIT_TOGGLE()<CR>",
		desc = "Lazygit",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gj",
		"<cmd>lua require 'gitsigns'.next_hunk()<cr>",
		desc = "Next Hunk",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gk",
		"<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
		desc = "Prev Hunk",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gl",
		"<cmd>lua require 'gitsigns'.blame_line()<cr>",
		desc = "Blame",
		nowait = true,
		remap = false,
	},
	{
		"<leader>go",
		"<cmd>Telescope git_status<cr>",
		desc = "Open changed file",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gp",
		"<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
		desc = "Preview Hunk",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gr",
		"<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
		desc = "Reset Hunk",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gs",
		"<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
		desc = "Stage Hunk",
		nowait = true,
		remap = false,
	},
	{
		"<leader>gu",
		"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
		desc = "Undo Stage Hunk",
		nowait = true,
		remap = false,
	},
	{
		"<leader>h",
		"<cmd>nohlsearch<CR>",
		desc = "No Highlight",
		nowait = true,
		remap = false,
	},
	{
		"<leader>l",
		group = "LSP",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lI",
		"<cmd>Mason<cr>",
		desc = "Installer Info",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lS",
		"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
		desc = "Workspace Symbols",
		nowait = true,
		remap = false,
	},
	{
		"<leader>la",
		"<cmd>lua vim.lsp.buf.code_action()<cr>",
		desc = "Code Action",
		nowait = true,
		remap = false,
	},
	{
		"<leader>ld",
		"<cmd>Telescope lsp_document_diagnostics<cr>",
		desc = "Document Diagnostics",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lf",
		"<cmd>lua vim.lsp.buf.format{async=true}<cr>",
		desc = "Format",
		nowait = true,
		remap = false,
	},
	{
		"<leader>li",
		"<cmd>LspInfo<cr>",
		desc = "Info",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lj",
		"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
		desc = "Next Diagnostic",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lk",
		"<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
		desc = "Prev Diagnostic",
		nowait = true,
		remap = false,
	},
	{
		"<leader>ll",
		"<cmd>lua vim.lsp.codelens.run()<cr>",
		desc = "CodeLens Action",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lq",
		"<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>",
		desc = "Quickfix",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lr",
		"<cmd>lua vim.lsp.buf.rename()<cr>",
		desc = "Rename",
		nowait = true,
		remap = false,
	},
	{
		"<leader>ls",
		"<cmd>Telescope lsp_document_symbols<cr>",
		desc = "Document Symbols",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lt",
		"<cmd>TroubleToggle<cr>",
		desc = "Trouble",
		nowait = true,
		remap = false,
	},
	{
		"<leader>lw",
		"<cmd>Telescope lsp_workspace_diagnostics<cr>",
		desc = "Workspace Diagnostics",
		nowait = true,
		remap = false,
	},
	{
		"<leader>m",
		group = "Markdown",
		nowait = true,
		remap = false,
	},
	{
		"<leader>p",
		"<cmd>Lazy<cr>",
		desc = "Lazy",
		nowait = true,
		remap = false,
	},
	{
		"<leader>q",
		"<cmd>q!<CR>",
		desc = "Quit",
		nowait = true,
		remap = false,
	},
	{
		"<leader>s",
		group = "Search",
		nowait = true,
		remap = false,
	},
	{
		"<leader>sC",
		"<cmd>Telescope commands<cr>",
		desc = "Commands",
		nowait = true,
		remap = false,
	},
	{
		"<leader>sM",
		"<cmd>Telescope man_pages<cr>",
		desc = "Man Pages",
		nowait = true,
		remap = false,
	},
	{
		"<leader>sR",
		"<cmd>Telescope registers<cr>",
		desc = "Registers",
		nowait = true,
		remap = false,
	},
	{
		"<leader>sb",
		"<cmd>Telescope git_branches<cr>",
		desc = "Checkout branch",
		nowait = true,
		remap = false,
	},
	{
		"<leader>sc",
		"<cmd>Telescope colorscheme<cr>",
		desc = "Colorscheme",
		nowait = true,
		remap = false,
	},
	{
		"<leader>sh",
		"<cmd>Telescope help_tags<cr>",
		desc = "Find Help",
		nowait = true,
		remap = false,
	},
	{
		"<leader>sk",
		"<cmd>Telescope keymaps<cr>",
		desc = "Keymaps",
		nowait = true,
		remap = false,
	},
	{
		"<leader>sr",
		"<cmd>Telescope oldfiles<cr>",
		desc = "Open Recent File",
		nowait = true,
		remap = false,
	},
	{
		"<leader>w",
		"<cmd>w!<CR>",
		desc = "Save",
		nowait = true,
		remap = false,
	},
	{
		"<leader>t",
		group = "Telescope",
		nowait = true,
		remap = false,
	},
	{
		"<leader>ty",
		"<cmd>Telescope yaml_schema<cr>",
		desc = "Yaml Schema",
		nowait = true,
		remap = false,
	},
	{
		"<leader>x",
		group = "Trouble",
		nowait = true,
		remap = false,
	},
	{
		"<leader>xx",
		"<cmd>Trouble diagnostics toggle<cr>",
		desc = "Diagnostics (Trouble)",
	},
	{
		"<leader>xX",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		desc = "Buffer Diagnostics (Trouble)",
	},
	{
		"<leader>cs",
		"<cmd>Trouble symbols toggle focus=false<cr>",
		desc = "Symbols (Trouble)",
	},
	{
		"<leader>cl",
		"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
		desc = "LSP Definitions / references / ... (Trouble)",
	},
	{
		"<leader>xL",
		"<cmd>Trouble loclist toggle<cr>",
		desc = "Location List (Trouble)",
	},
	{
		"<leader>xQ",
		"<cmd>Trouble qflist toggle<cr>",
		desc = "Quickfix List (Trouble)",
	},
}

which_key.setup(setup)
which_key.add(spec)
