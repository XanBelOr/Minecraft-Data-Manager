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

## Credit
This library has the **[gu](https://github.com/gibbsly/gu)** library built in.
