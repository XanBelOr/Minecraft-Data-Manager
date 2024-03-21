data modify storage central:temp entry.uuid set from storage gu:main out
execute unless entity @s[type=player] run data modify storage central:entity data append from storage central:temp entry
execute if entity @s[type=player] run data modify storage central:player data append from storage central:temp entry
tag @s add c.has_entry
scoreboard players set @s c.has_custom_data 1