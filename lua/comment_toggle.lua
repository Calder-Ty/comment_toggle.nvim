local api = vim.api

M = {}

local var_name = "comment_toggle_comment_leader"

local comment_strings = {
	["//"] = { "c", "cpp", "java", "scala", "rust", "cs", "go", "javascript", "typescript", "php", "odin", 'zig' },
	["#"] = { "sh", "ruby", "python", "conf", "fstab", "yaml", "yml", "Dockerfile", "gitcommit", "nim", "perl", "r" },
	["%"] = { "tex" },
	[">"] = { "mail" },
	["x"] = { "todotext" },
	['"'] = { "vim" },
	['⍝'] = { "apl" },
	["REM"] = { "freebasic" },
	["--"] = { "sql", "lua", "ada", "haskell" }
}

local group = api.nvim_create_augroup("CommentToggle", {})

for comment_str, langs in pairs(comment_strings) do
	api.nvim_create_autocmd({ "FileType" }, {
		group = group,
		pattern = langs,
		desc = "Add Comment Toggling for file",
		callback = function(args)
			local bufnr = args.buf
			api.nvim_buf_set_var(bufnr, var_name, comment_str)
		end
	})
end

local special_chars = {
	["("] = true,
	[")"] = true,
	["."] = true,
	["%"] = true,
	["+"] = true,
	["-"] = true,
	["*"] = true,
	["?"] = true,
	["["] = true,
	["^"] = true,
	["$"] = true,
}

local escape = function(str)
	local escaped = {}
	for i = 1, #str do
		local char = str:sub(i, i)
		if special_chars[char] then
			char = "%" .. char
		end
		table.insert(escaped, char)
	end
	return table.concat(escaped)
end


local toggle_on = function(start, fin, comment_leader, lines)

	local modified = {}
	for i, _ in pairs(lines) do
		local line = lines[i]
		if line ~= "" then
			local i, j = string.find(line, "%S")
			line = string.sub(line, 1, i - 1) .. comment_leader .. " " .. string.sub(line, j)
		end
		table.insert(modified, line)
	end

	vim.api.nvim_buf_set_lines(0, start - 1, fin, false, modified)
end

local toggle_off = function(start, fin, comment_leader, lines)
	local modified = {}
	for i, _ in pairs(lines) do
		local line = string.gsub(lines[i], comment_leader .. " ", "", 1)
		table.insert(modified, line)
	end
	vim.api.nvim_buf_set_lines(0, start - 1, fin, false, modified)
end

M.comment_toggle = function(start, fin)
	local comment_leader = api.nvim_buf_get_var(0, var_name)
	local lines = vim.api.nvim_buf_get_lines(0, start - 1, fin, false)
	local on = true
	local pat = "^%s*" .. escape(comment_leader) .. " "
	for i = 1, #lines do
		if string.find(lines[i], pat) then
			on = false
			break
		end
	end
	if on then
		toggle_on(start, fin, comment_leader, lines)
	else
		toggle_off(start, fin, comment_leader, lines)
	end
end



return M
