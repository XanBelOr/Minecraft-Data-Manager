function data_manager:gu/generate
data modify storage data:manager custom_data set value {}
execute unless entity @s[tag=c.has_entry] run function data_manager:new_entry
function data_manager:read_macro with storage gu:main
