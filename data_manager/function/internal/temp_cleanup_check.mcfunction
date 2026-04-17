# Read the ID at the current index from temp_index
$data modify storage dm:args id set from storage dm:db temp_index[$(idx)]
# If nothing at that index, nothing to check
execute unless data storage dm:args id run return 0
# Verify via macro — if an entity still has this id, leave it alone; otherwise remove
function data_manager:internal/temp_cleanup_verify with storage dm:args
