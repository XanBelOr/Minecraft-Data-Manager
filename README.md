# Minecraft-Data-Manager
This is a simple and lightweight datapack which makes it easy to have custom data saved per-entity using data storages.

# Usage
Usage is simple. All data is passed through the `data:manager custom_data` storage.

First, make sure you use `function data_manager:load` in your datapack's load function.

To **read** data, use `function data_manager:read`. This will put all the entity's arbitrary data into the `data:manager custom_data` storage.

To **write** data to an entity's storage, use `function data_manager:write`. This will copy the `data:manager custom_data` to your entity's storage location.

## Partial Storage Access
A new feature has been added with performance in mind. If an entity has several paths of data stored, copying the full data storage each time to access data can
be performance intensive. To address this, you can now use the `read_partial` and `write_partial` functions to directly target a specific path, only
copying over the path you specified and eliminating any other unnecessary data being copied over and consuming performance. 
Specify the `path` argument in a macro with your desired path: `{path:"some.path"}`.

Additional note: It is almost always recommended you use partial storage access. In most cases, you're just accessing one piece of the storage, and copying over the rest would add unnecessary overhead.

## Notice
The `write` function completely replaces the entity's storage with the `data:manager custom_data` storage, so it is always required that you use `read` and modify that before you `write` back to storage unless you want to completely erase everything else in the storage.
Also, not reading can cause unwanted data from another entity to be copied into your entity.

## Examples

**Full Storage Access**
```
function data_manager:read

data modify storage data:manager custom_data.laser_eyes set value "disabled"

data modify storage data:manager custom_data.hero_name set value "Superman"

function data_manager:write
```

**Partial Storage Access**
```
function data_manager:read_partial {path:laser_eyes}

data modify storage data:manager custom_data.laser_eyes set value "enabled"

function data_manager:write_partial {path:laser_eyes}
```

## Other features
This library will automatically filter through non-player storages and clean them up if the entity no longer exists to avoid clutter. Also, calling `read` or `write`
for an entity that has not yet been initialized with the system will automatically initialize it and create an entry for it.

## Upgrading from v1.x to v2.0

v2.0 changes the internal storage structure from a flat NBT list to compound keys. This is a **major performance improvement** — see the section below for details.

**If you have an existing world with entity data stored by v1.x**, run the following command once after updating to migrate your data:
```
/function data_manager:migrate_to_compound
```
This copies all entries from the old list format into the new compound key format. The old list is preserved as an index for cleanup but is no longer used for lookups.

**No changes to the public API are required.** `read`, `write`, `read_partial`, and `write_partial` all work identically — the change is entirely internal.

**If your datapack accesses `central:entity data[{intuuid:...}]` directly** (bypassing the data_manager API), you must update those paths to `central:entity entries."<intuuid>"`. For example:
```
# Old (v1.x) — O(n) list scan:
$function my_pack:something with storage central:entity data[{intuuid:$(0)$(1)$(2)$(3)}].custom_data.my_data

# New (v2.0) — O(1) compound lookup:
$function my_pack:something with storage central:entity entries."$(0)$(1)$(2)$(3)".custom_data.my_data
```

## Performance: O(1) Compound Key Lookups (v2.0)

In v1.x, all entity data was stored in a flat NBT list:
```
central:entity data = [
  {intuuid: "...", custom_data: {...}},
  {intuuid: "...", custom_data: {...}},
  ...
]
```
Every `read` or `write` operation searched this list by compound match (`data[{intuuid:"..."}]`), which is a **linear scan** — Minecraft iterates through every single entry in the list until it finds the matching UUID. With 1 entity this is instant. With 100+ entities, every single read/write has to scan through all 100+ entries, and if you're doing multiple reads per tick, you get **O(n²) behavior** that destroys performance.

In v2.0, entity data is stored as named compound keys:
```
central:entity entries = {
  "<intuuid_1>": {custom_data: {...}},
  "<intuuid_2>": {custom_data: {...}},
  ...
}
```
Compound tag key lookups in Minecraft are **hash-based (O(1))** — the game jumps directly to the matching key regardless of how many entries exist. This eliminates the scaling problem entirely.

The old `data[]` list is still maintained as a lightweight index for the tick-based cleanup system that removes data for dead entities, but it is never searched by compound match anymore.

## Credit
This library has the **[gu](https://github.com/gibbsly/gu)** library built in.
