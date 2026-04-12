$execute unless entity @s[type=player] run return run data modify storage central:entity entries."$(0)$(1)$(2)$(3)".custom_data set from storage data:manager custom_data
$execute if entity @s[type=player] run data modify storage central:player entries."$(0)$(1)$(2)$(3)".custom_data set from storage data:manager custom_data
