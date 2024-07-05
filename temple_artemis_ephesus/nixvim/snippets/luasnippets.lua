local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

ls.add_snippet("all", {
	s("d", { t("$") })
})


ls.add_snippet("all", {
	s("ddd", { t("this b what i b inserting") })
})
