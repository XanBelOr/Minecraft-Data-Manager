# Caller must set dm:args.id and dm:args.path, then call: function data_manager:write_partial_perm with storage dm:args
$data modify storage dm:db perm."$(id)".custom_data.$(path) set from storage data:manager custom_data.$(path)
