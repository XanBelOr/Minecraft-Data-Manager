# Pool-agnostic: single macro call. Caller sets dm:args.id and dm:args.path.
$execute if entity @s[tag=!dm.temp,tag=!dm.perm] run say i am a retard who hasnt been initialized. I tried to call $(path)
$data modify storage data:manager custom_data.$(path) set from storage dm:db entries."$(id)".custom_data.$(path)
