# Minecraft-Data-Manager

A lightweight datapack that gives every entity its own persistent custom data, using Minecraft's storage system. Designed for speed — measured **~1.6× faster than direct marker NBT** for per-entity data access.

## What it does

Each entity gets a numeric ID (the `dm.id` scoreboard). That ID maps to a storage compound under `dm:db` where your custom data lives. Read and write with simple function calls, no manual UUID handling.

## Quick start

### 1. Initialize on load

Add `data_manager:load` to your pack's load tag.

### 2. Choose a pool per entity

Two storage pools with different semantics:

- **`init_temp`** — short-lived entities (projectiles, summons, temporary mobs). IDs wrap at int max; entries auto-cleaned up when the entity dies.
- **`init_perm`** — long-lived entities (players, bosses, permanent mobs). IDs never wrap; data persists across sessions; automatic recovery on player name changes.

Call `init_temp` or `init_perm` on the entity **once** before reading/writing:
```mcfunction
execute as <entity> run function data_manager:init_perm
```

After init, the entity has a `dm.id` score and a `dm.temp` or `dm.perm` tag. Init is idempotent — calling it again is a no-op.

### 3. Read and write

All read/write functions take their arguments via a storage compound at `dm:args`. You set `id` (and `path` for partial variants), then call the function with `with storage dm:args`.

**Read a single path:**
```mcfunction
# As the entity whose data you want to read:
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
data modify storage dm:args path set value "my.path"
function data_manager:read_partial_perm with storage dm:args
# Data is now at: storage data:manager custom_data.my.path
```

**Write a single path:**
```mcfunction
# Put your value in data:manager first:
data modify storage data:manager custom_data.my.path set value "hello"

execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
data modify storage dm:args path set value "my.path"
function data_manager:write_partial_perm with storage dm:args
```

**Full read/write** (copies ALL of the entity's custom_data):
```mcfunction
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:read_perm with storage dm:args
# or
function data_manager:write_perm with storage dm:args
```

## Function reference

### Init
| Function | Purpose |
|---|---|
| `data_manager:init_temp` | Assign temp-pool ID to `@s`. Side effect: populates `dm:args.id`. |
| `data_manager:init_perm` | Assign perm-pool ID to `@s`. Side effect: populates `dm:args.id` and stores UUID for recovery. |

### Read/Write (temp pool)
| Function | Args in `dm:args` |
|---|---|
| `data_manager:read_temp` | `id` |
| `data_manager:write_temp` | `id` |
| `data_manager:read_partial_temp` | `id`, `path` |
| `data_manager:write_partial_temp` | `id`, `path` |
| `data_manager:clear_temp` | `id` (must call as `@s` — also removes tag and resets score) |

### Read/Write (perm pool)
| Function | Args in `dm:args` |
|---|---|
| `data_manager:read_perm` | `id` |
| `data_manager:write_perm` | `id` |
| `data_manager:read_partial_perm` | `id`, `path` |
| `data_manager:write_partial_perm` | `id`, `path` |
| `data_manager:clear_perm` | `id` (must call as `@s` — also removes tag and resets score) |

### Pool-agnostic dispatchers (when `@s` could be either pool)
For code that runs on an entity of unknown pool type (e.g., debuff logic that applies to players *or* mobs), these dispatchers check the `dm.temp` / `dm.perm` tag on `@s` and forward to the matching pool-specific function. Slightly slower due to the extra tag check, but avoids having to write branching logic at every callsite.

| Function | Args in `dm:args` |
|---|---|
| `data_manager:read` | `id` |
| `data_manager:write` | `id` |
| `data_manager:read_partial` | `id`, `path` |
| `data_manager:write_partial` | `id`, `path` |

Temp pool is checked first (with `return run`), so the cost is a single tag check for temp-pool entities and two for perm-pool entities.

## Pool semantics

### Temp pool (`dm:db temp`)
- Best for: projectiles, short-lived summons, any entity expected to eventually die
- ID range: 1 to `2147483647`, then wraps back to 1
- Cleanup: the tick function scans the temp index once per tick and removes entries whose entity no longer exists
- If you hit the wrap point, the assumption is that the original holder of that ID is long gone (it's 2 billion IDs away)

### Perm pool (`dm:db perm`)
- Best for: players, bosses, unique NPCs, anything that should persist
- ID range: 1 to `2147483647`, no wrap
- Cleanup: none automatically — if you need to clear an entity's entry, call `clear_perm`
- Each entry stores the entity's UUID for name-change recovery

### Player name change recovery
When a player changes their username, Minecraft resets their scoreboard scores. The tick function detects players with `dm.perm` tag but no `dm.id` score, generates their UUID, and scans the perm pool for a matching entry. The scan is `O(n)` but only fires on the rare name-change event.

## Performance

Benchmark: 10,000 write+read cycles (20,000 total operations), wrapped in a cycle function for realistic dispatch patterns. Measured in MC 26.2-snapshot-3.

| System | Per-op cost | 20k ops time | Throughput |
|---|---|---|---|
| Direct marker NBT | 6.2µs | 124ms | ~161,000 ops/sec |
| **data_manager v3** | **3.85µs** | **77ms** | **~260,000 ops/sec** |

**Why it beats NBT:** Storage compound keys are hashmap lookups with no serialization overhead. NBT entity data has to walk the entity tree and serialize. data_manager uses more commands per call, but each command is cheaper — net result is ~38% faster per op and ~62% more throughput.

## Storage layout

```
dm:db {
  temp: {
    "<id>": { custom_data: { <your fields> } },
    ...
  },
  perm: {
    "<id>": {
      uuid: "<hex-uuid-string>",
      custom_data: { <your fields> }
    },
    ...
  },
  temp_index: [1, 2, 3, ...]  // for cleanup iteration
}
```

## Migrating from v2.x

**Breaking change.** v3 is a full rewrite with a new API and new storage structure. Migration is handled by a separate one-time-use datapack included in this repo.

1. Install **both** the v3 `data_manager` datapack and the `data_manager_migrate_v3` datapack
2. `/reload`
3. Run `/function data_manager_migrate_v3:migrate` once
4. Remove the `data_manager_migrate_v3` datapack
5. Update all your callers to use the new API (see above)

The migration copies entries from the old `central:entity`/`central:player` lists into `dm:db perm`, assigns new sequential IDs, and tags online entities with `dm.perm`.

## Credits

UUID utility library ([gu](https://github.com/gibbsly/gu)) is bundled.
