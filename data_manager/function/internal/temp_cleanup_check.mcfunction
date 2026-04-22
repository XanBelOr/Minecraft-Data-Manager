$data modify storage dm:args id set from storage dm:db temp_index[$(idx)]
execute unless data storage dm:args id run return 0
data remove storage dm:args uuid
function data_manager:internal/temp_cleanup_load_uuid with storage dm:args
execute unless data storage dm:args uuid run return run function data_manager:internal/temp_cleanup_orphan with storage dm:args
function data_manager:internal/temp_cleanup_verify with storage dm:args
