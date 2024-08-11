execute store result score $c.entries temp run data get storage central:entity data
scoreboard players set $c.entry_number temp 0
#execute if score $c.entries temp matches 1.. run data modify storage central:temp data_array set from storage central:entity data