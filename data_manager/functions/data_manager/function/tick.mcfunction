execute unless score $c.entries temp matches 1.. run function data_manager:get_entries
execute if score $c.entries temp matches 1.. run function data_manager:check_entity with storage central:temp data_array[-1]
schedule function data_manager:tick 1t replace