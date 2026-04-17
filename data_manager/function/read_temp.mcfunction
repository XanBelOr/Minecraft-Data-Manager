# Caller must set dm:args.id, then call: function data_manager:read_temp with storage dm:args
$data modify storage data:manager custom_data set from storage dm:db temp."$(id)".custom_data
