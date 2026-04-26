$execute as $(uuid) run tag @s add dm.temp
$execute as $(uuid) run tag @s remove c.has_entry
$execute as $(uuid) run scoreboard players set @s dm.id $(new_id)
