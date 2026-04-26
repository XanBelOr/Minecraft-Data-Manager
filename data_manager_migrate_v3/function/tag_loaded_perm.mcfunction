$execute as $(uuid) run tag @s add dm.perm
$execute as $(uuid) run tag @s remove c.has_entry
$execute as $(uuid) run scoreboard players set @s dm.id $(new_id)
$execute as $(uuid) run scoreboard players operation @s dm.left_handled = @s dm.left
