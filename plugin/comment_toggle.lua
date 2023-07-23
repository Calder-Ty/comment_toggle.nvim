ct = require("comment_toggle")

vim.api.nvim_create_user_command("CommentToggle", function(args)
	local start=args['line1']
	local fin=args['line2']
	ct.comment_toggle(start, fin)
end, {range=true})
