# Minecraft-Data-Manager
This is a simple and lightweight datapack which makes it easy to have custom data saved per-entity using data storages.

# Usage
Usage is simple. All data is passed through the `data:manager custom_data` storage.

First, make sure you use `function data_manager:load` in your datapack's load function.

To **read** data, use `function data_manager:read`. This will put all the entity's arbitrary data into the `data:manager custom_data` storage.

To **write** data to an entity's storage, use `function data_manager:write`. This will copy the `data:manager custom_data` to your entity's storage location.

## Notice
The `write` function completely replaces the entity's storage, so it it is HIGHLY recommended you use `read` and modify that before you `write` back to storage unless you want to completely erase everything else in the storage.

## Exanple
```
function data_manager:read

data modify storage data:manager custom_data.laser_eyes set value "disabled"

function data_manager:write
```

## Other features
This library will automatically filter through non-entity storages and clean them up if the entity no longer exists to avoid clutter. Also, calling `read` or `write`
for an entity that has not yet been initialized with the system will automatically initialize it and create an entry for it.

## Credit
This library has the **[gu](https://github.com/gibbsly/gu)** library built in.
