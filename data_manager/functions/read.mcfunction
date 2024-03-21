function data_manager:gu/generate
execute unless entity @s[tag=c.has_entry] run function data_manager:new_entry
function data_manager:read_macro with storage gu:main