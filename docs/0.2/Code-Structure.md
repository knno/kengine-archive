# Code Structure

> This section is a work-in-progress.

## Writing Style

- `snake_case` for variables
- `_snake_case` for local variables 
- `__snake_case` for internal variables
- `CamelCase` for usable constructors, functions, and methods (with rare method exceptions).
- `__CamelCase` for internal constructors, functions, and methods.


## IDE Folders

- `Kengine/Scripts/`:
  - Contains what is needed to run Kengine in your project. Import that folder.
  - `__KengineBaseConstructors/`:
    - Contains base constructors used by Kengine.
  - `__KengineUtils/`:
    - Contains all utility scripts
  - `Extensions/`:
    - Contains extensions. (See the sub-folder `Example/`.)
  - `__KengineInternalFunctions` script:
    - Contains internal functions.
  - `Kengine` script:
    - Contains the main singleton.

- `KengineAssetTypes` script:
  - Contains all the definitions of assets. This is an extensive schema which also contains functions.
- `KengineConfig` script:
  - Contains all configuration macros.
- `KengineInfo` script:
  - Contains useful information.

## Special

- `KengineStruct` is a special constructor for almost all Kengine constructors. You can access `__opts` for special stored values. See parser notes.
- `KengineCollection` is a special constructor for almost all Kengine arrays. You can access `GetAll()` for getting all items in the array.
