# Caller must set dm:args.id, then call: function data_manager:read_perm with storage dm:args
$data modify storage data:manager custom_data set from storage dm:db perm."$(id)".custom_data
