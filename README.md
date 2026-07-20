# Minecraft Data Manager

A datapack that gives every entity its own pocket of storage for whatever custom data you want to keep on it. It's fast (about 1.6x faster than writing NBT directly to a marker, benchmarks below), and you never have to touch a UUID yourself.

## Why this exists

Sooner or later every datapack hits the same wall: you want to remember something about a specific entity. A mana value on a player, an owner on a summon, a bounce counter on an arrow. Vanilla gives you a few ways to do this and none of them are great. Scoreboards only hold numbers. Writing NBT onto entities is slow, and you can't even do it to players. Tracking everything by UUID means juggling four ints and a lot of regret.

This pack takes a simpler road. Every entity gets a plain number, and that number points to a spot in storage where its data lives. You read and write with a couple of function calls and get on with your day.

## The basic idea

When you initialize an entity, it gets an ID on the `dm.id` scoreboard. That ID is the key to its own compound in `dm:db entries`, and that compound is where your custom data sits.

There are two kinds of entities, so there are two pools:

- **Temp pool** for stuff that won't be around long: projectiles, summons, most mobs. These get positive IDs (1, 2, 3...) and clean themselves up automatically when the entity is gone.
- **Perm pool** for stuff that sticks around: players, important NPCs, permanent markers. These get negative IDs (-1, -2, -3...), never get auto-deleted, and can survive a player changing their username.

Here's the nice part: the pool lives entirely in the sign of the ID. Both pools share the same storage, so reading and writing works exactly the same for either one. Same function, no branching, nothing extra to think about.

## Getting started

**1. Hook up the load function.** Add `data_manager:load` to your pack's load tag.

**2. Initialize each entity once.** Pick a pool:

- `data_manager:init_temp` for temporary entities (tags it `dm.temp`, gives it a positive ID)
- `data_manager:init_perm` for permanent ones (tags it `dm.perm`, gives it a negative ID)

Both are safe to call more than once. If you call `init_perm` on something that was temp, it moves the data over to a new perm entry for you. Calling `init_temp` on a perm entity does nothing, so you can't accidentally downgrade something important.

**3. Read and write.** The functions take their arguments from `dm:args` storage. Set `id` (and `path` if you only want part of the data), then call the function `with storage dm:args`:

```mcfunction
# Read one path
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
data modify storage dm:args path set value "my.path"
function data_manager:read_partial with storage dm:args
# Your data is now at: storage data:manager custom_data.my.path

# Write one path
data modify storage data:manager custom_data.my.path set value "hello"
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
data modify storage dm:args path set value "my.path"
function data_manager:write_partial with storage dm:args
```

If you want the entity's whole custom_data at once, use the full versions:

```mcfunction
execute store result storage dm:args id int 1 run scoreboard players get @s dm.id
function data_manager:read with storage dm:args
# or
function data_manager:write with storage dm:args
```

That's genuinely the whole API for day to day use. Init once, then read and write.

## Function list

Init (run as the entity):

| Function | What it does |
|---|---|
| `data_manager:init_temp` | Gives `@s` a positive ID, tags it `dm.temp`, adds it to the cleanup index. Also puts the ID in `dm:args.id` for you. Does nothing if the entity is already perm. |
| `data_manager:init_perm` | Gives `@s` a negative ID, tags it `dm.perm`, and stores its UUID for name change recovery. Also puts the ID in `dm:args.id`. If the entity was temp, its data comes along automatically. |

Read and write (same functions for both pools):

| Function | Needs in `dm:args` |
|---|---|
| `data_manager:read` | `id` |
| `data_manager:write` | `id` |
| `data_manager:read_partial` | `id`, `path` |
| `data_manager:write_partial` | `id`, `path` |

Moving between pools:

| Function | What it does |
|---|---|
| `data_manager:migrate_perm_to_temp` | Downgrades `@s` from perm to temp, keeping its data. You have to call this on purpose. `init_temp` will never downgrade a perm entity on its own, that's a safety thing. Does nothing if `@s` isn't perm. |

Going the other way (temp to perm) doesn't need its own function, `init_perm` handles it.

Cleanup (run as the entity):

| Function | What it does |
|---|---|
| `data_manager:clear_temp` | Removes the entry, tag, and score from a `dm.temp` entity. |
| `data_manager:clear_perm` | Removes the entry, tag, and score from a `dm.perm` entity. |

## Temp vs perm, in a bit more detail

**Temp (positive IDs).** Use this for anything you expect to eventually die: projectiles, short lived summons, that kind of thing. A tick function checks one entry per tick and removes entries whose entity no longer exists. It checks against `scoreboard.dat`, so it correctly handles loaded, unloaded, and dead entities alike. IDs count up from 1, and yes, in theory the counter could wrap around into perm territory, but you'd need two billion concurrent temp entities before that's a problem. If you manage that, I want to see the world.

**Perm (negative IDs).** Use this for players and anything else that should stick around. No auto cleanup ever happens here; if you truly want an entry gone, call `clear_perm` yourself. Each perm entry also stores the entity's UUID, which brings us to:

**Name change recovery.** When a player changes their username, Minecraft wipes their scoreboard scores, which would normally orphan their data. The tick function watches for players who have the `dm.perm` tag but a `dm.id` of 0, rebuilds their UUID, and scans the perm entries for a match. The scan is linear, but it only ever runs when someone actually changed their name, so in practice you'll never notice it.

## How fast is it?

The benchmark ran 10,000 write plus read cycles (20,000 operations total), wrapped in a cycle function so the dispatch pattern matches real use. Measured on MC 26.2-snapshot-3:

| System | Per op | 20k ops | Throughput |
|---|---|---|---|
| Direct marker NBT | 6.2µs | 124ms | ~161,000 ops/sec |
| data_manager | 3.85µs | 77ms | ~260,000 ops/sec |

So about 38% cheaper per operation and around 62% more throughput.

Why does it win when it runs more commands per call? Because storage keys are basically hashmap lookups with no serialization cost, while entity NBT has to walk the entity's data tree and serialize on every access. More commands, but each one is cheaper, and the total comes out well ahead.

## What the storage looks like

If you're curious (or debugging), here's the layout:

```
dm:db {
  entries: {
    "1":  { uuid: "<hex>", custom_data: { <your fields> } },    // temp (positive)
    "2":  { uuid: "<hex>", custom_data: { <your fields> } },    // temp
    "-1": { uuid: "<hex>", custom_data: { <your fields> } },    // perm (negative)
    "-2": { uuid: "<hex>", custom_data: { <your fields> } },    // perm
    ...
  },
  temp_index: [1, 2, 3, ...]  // temp IDs only, used by the cleanup loop
}
```

## Coming from v2.x?

Heads up: v3 is a full rewrite. New API, new storage structure, and it will not read v2 data on its own. The repo includes a one shot migration pack that handles the conversion:

1. Install both `data_manager` (v3.1) and `data_manager_migrate_v3`
2. `/reload`
3. Run `/function data_manager_migrate_v3:migrate` once
4. Remove the `data_manager_migrate_v3` pack
5. Update your callers to the new API described above

The migration copies `central:player data[]` into the perm pool and `central:entity data[]` into the temp pool, tags any entities that are currently online, and keeps all your custom_data intact.

## Credits

Bundles the [gu](https://github.com/gibbsly/gu) UUID utility library.
