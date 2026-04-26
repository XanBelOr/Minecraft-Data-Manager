# Tag the loaded entity (if any) matching this uuid as perm. No-op if unloaded.
$execute as $(uuid) run tag @s add dm.perm
$execute as $(uuid) run tag @s remove c.has_entry
$execute as $(uuid) run scoreboard players set @s dm.id $(new_id)
