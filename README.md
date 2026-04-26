# Minecraft-Data-Manager

A lightweight datapack that gives every entity its own persistent custom data, using Minecraft's storage system. Designed for speed — measured **~1.6× faster than direct marker NBT** for per-entity data access.

## What it does

Each entity gets a numeric ID (the `dm.id` scoreboard). That ID maps to a storage compound under `dm:db entries` where your custom data lives. Read and write with simple function calls, no manual UUID handling.

**Two pools, one unified storage:**
- **Temp pool** — short-lived entities (projectiles, summons, most entities). Positive IDs (1, 2, 3...). Auto-cleanup when the entity dies.
- **Perm pool** — long-lived entities (players, npcs, permanent markers). Negative IDs (-1, -2, -3...). No cleanup, UUID-based name-change recovery.

The pool is encoded in the **sign of the ID**. Both pools use the same `dm:db entries` compound, so **read/write works identically for either** — one function, no dispatcher, no branching.

## Quick start

### 1. Initialize on load

Add `data_manager:load` to your pack's load tag.

### 2. Choose a pool per entity

Call **once** per entity:
- `data_manager:init_temp` → temportary (tagged `dm.temp`, positive ID)
- `data_manager:init_perm` → permanent (tagged `dm.perm`, negative ID)

Both are idempotent. `init_perm` on a `dm.temp`-tagged entity **migrates** its custom_data to a new perm entry. `init_temp` on a `dm.perm`-tagged entity is a no-op (no downgrade).

### 3. Read and write

All read/write functions take args via `dm:args` storage. Set `id` (and `path` for partial variants), then call with `with storage dm:args`:

```mcfunction
# Read a path
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
data modify storage dm:args path set value "my.path"
function data_manager:read_partial with storage dm:args
# Data is now at: storage data:manager custom_data.my.path

# Write a path
data modify storage data:manager custom_data.my.path set value "hello"
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
data modify storage dm:args path set value "my.path"
function data_manager:write_partial with storage dm:args
```

**Full read/write** (copies ALL of the entity's custom_data):
```mcfunction
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:read with storage dm:args
# or
function data_manager:write with storage dm:args
```

## Function reference

### Init
| Function | Purpose |
|---|---|
| `data_manager:init_temp` | Assigns positive ID to `@s`, tags `dm.temp`, appends to cleanup index. Populates `dm:args.id`. No-op if already `dm.perm`. |
| `data_manager:init_perm` | Assigns negative ID to `@s`, tags `dm.perm`, stores UUID for recovery. Populates `dm:args.id`. Auto-migrates from `dm.temp` if needed. |

### Read/Write (unified — works for both pools)
| Function | Args in `dm:args` |
|---|---|
| `data_manager:read` | `id` |
| `data_manager:write` | `id` |
| `data_manager:read_partial` | `id`, `path` |
| `data_manager:write_partial` | `id`, `path` |

### Explicit pool migration
| Function | Purpose |
|---|---|
| `data_manager:migrate_perm_to_temp` | Downgrade `@s` from perm to temp, preserving custom_data. Must be called explicitly — `init_temp` alone will NOT downgrade a perm entity (safety). No-op if `@s` is not in perm. |

(The reverse direction — temp → perm — is handled automatically by `init_perm` if `@s` has the `dm.temp` tag.)

### Cleanup
| Function | Purpose |
|---|---|
| `data_manager:clear_temp` | Run as `@s` (must have `dm.temp`). Removes entry + tag + score. |
| `data_manager:clear_perm` | Run as `@s` (must have `dm.perm`). Removes entry + tag + score. |

## Pool semantics

### Temp pool (positive IDs)
- Best for: projectiles, short-lived summons, any entity expected to eventually die
- ID range: 1 up to `Integer.MAX_VALUE`, then wraps to `Integer.MIN_VALUE` (negative) — but that collides with perm range. **In practice this is fine** because you'd need 2 billion concurrent temp entities for collision risk.
- Cleanup: tick function checks one entry per tick, removes entries whose entity is gone (score no longer exists in `scoreboard.dat` — works for loaded, unloaded, and dead entities).

### Perm pool (negative IDs)
- Best for: players, unique NPCs, any entity expected to persist
- ID range: -1 down to `Integer.MIN_VALUE`, no wrap
- Cleanup: none. Call `clear_perm` manually if needed.
- Each entry stores the entity's UUID for name-change recovery.

### Player name change recovery
When a player's username changes, Minecraft resets their scoreboard scores. The tick function detects players with `dm.perm` tag but `dm.id=0`, generates their UUID, and scans perm entries (negative IDs down to `.perm_counter`) for a matching UUID. O(n) but only fires on name change.

## Performance

Benchmark: 10,000 write+read cycles (20,000 total operations), wrapped in a cycle function for realistic dispatch patterns. Measured in MC 26.2-snapshot-3.

| System | Per-op cost | 20k ops time | Throughput |
|---|---|---|---|
| Direct marker NBT | 6.2µs | 124ms | ~161,000 ops/sec |
| **data_manager** | **3.85µs** | **77ms** | **~260,000 ops/sec** |

**Why it beats NBT:** Storage compound keys are hashmap lookups with no serialization overhead. NBT entity data has to walk the entity tree and serialize. data_manager uses more commands per call, but each command is cheaper — net result is ~38% faster per op and ~62% more throughput.

## Storage layout

```
dm:db {
  entries: {
    "1":  { uuid: "<hex>", custom_data: { <your fields> } },    // temp (positive)
    "2":  { uuid: "<hex>", custom_data: { <your fields> } },    // temp
    "-1": { uuid: "<hex>", custom_data: { <your fields> } },    // perm (negative)
    "-2": { uuid: "<hex>", custom_data: { <your fields> } },    // perm
    ...
  },
  temp_index: [1, 2, 3, ...]  // only temp IDs, for cleanup iteration
}
```

## Migrating from v2.x

**Breaking change.** v3 is a full rewrite with new API and storage structure. Use the `data_manager_migrate_v3` datapack (included):

1. Install **both** `data_manager` (v3.1) and `data_manager_migrate_v3` datapacks
2. `/reload`
3. Run `/function data_manager_migrate_v3:migrate` once
4. Remove the `data_manager_migrate_v3` datapack
5. Update callers to the new API (see above)

Migration copies `central:player data[]` → perm (negative IDs) and `central:entity data[]` → temp (positive IDs), tags online entities, and preserves custom_data.

## Credits

UUID utility library ([gu](https://github.com/gibbsly/gu)) is bundled.
