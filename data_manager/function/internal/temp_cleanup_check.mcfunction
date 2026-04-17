# Read the ID at the current index from temp_index
$data modify storage dm:args id set from storage dm:db temp_index[$(idx)]
# If nothing at that index, nothing to check
execute unless data storage dm:args id run return 0
# Read the uuid stored in the entry for this id
function data_manager:internal/temp_cleanup_load_uuid with storage dm:args
# Verify via UUID — works for both loaded and unloaded entities
function data_manager:internal/temp_cleanup_verify with storage dm:args
