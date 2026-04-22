# Pool-agnostic: single macro call. Caller sets dm:args.id and dm:args.path.
$data modify storage dm:db entries."$(id)".custom_data.$(path) set from storage data:manager custom_data.$(path)
