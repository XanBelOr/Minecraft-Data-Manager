$execute unless entity @s[type=player] run return run data modify storage central:entity data[{intuuid:$(0)$(1)$(2)$(3)}].custom_data.$(path) set from storage data:manager custom_data.$(path)
$execute if entity @s[type=player] run data modify storage central:player data[{intuuid:$(0)$(1)$(2)$(3)}].custom_data.$(path) set from storage data:manager custom_data.$(path)