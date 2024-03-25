function data_manager:gu/generate
data modify storage central:temp entry.uuid set from storage gu:main out
execute store result storage central:temp intuuid.0 int 1 run scoreboard players get @s gu.UUID0
execute store result storage central:temp intuuid.1 int 1 run scoreboard players get @s gu.UUID1
execute store result storage central:temp intuuid.2 int 1 run scoreboard players get @s gu.UUID2
execute store result storage central:temp intuuid.3 int 1 run scoreboard players get @s gu.UUID3
function data_manager:combine_uuid with storage central:temp intuuid
execute unless entity @s[type=player] unless entity @s[tag=c.has_entry] run data modify storage central:entity data append from storage central:temp entry
execute if entity @s[type=player,tag=!c.has_entry] run data modify storage central:player data append from storage central:temp entry
tag @s add c.has_entry
scoreboard players set @s c.has_custom_data 1