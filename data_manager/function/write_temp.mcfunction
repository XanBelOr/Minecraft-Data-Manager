# Caller must set dm:args.id, then call: function data_manager:write_temp with storage dm:args
$data modify storage dm:db temp."$(id)".custom_data set from storage data:manager custom_data
