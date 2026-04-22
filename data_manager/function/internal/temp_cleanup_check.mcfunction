# Read the ID at the current index from temp_index
$data modify storage dm:args id set from storage dm:db temp_index[$(idx)]
execute unless data storage dm:args id run return 0

# Clear uuid so we can detect if the entry was deleted (e.g. by migration)
data remove storage dm:args uuid

# Try to load the uuid from the entry
function data_manager:internal/temp_cleanup_load_uuid with storage dm:args

# If uuid wasn't loaded, entry is gone (orphaned index entry) - clean up index
execute unless data storage dm:args uuid run return run function data_manager:internal/temp_cleanup_orphan with storage dm:args

# Normal verification via UUID score check
function data_manager:internal/temp_cleanup_verify with storage dm:args
