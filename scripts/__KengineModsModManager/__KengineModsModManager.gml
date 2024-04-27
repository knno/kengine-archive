
/**
 * @function ModManager
 * @memberof Kengine.Extensions.Mods
 * @description A mod manager is a singleton object that manages {@link Kengine.Extensions.Mods.Mod} objects.
 * 
 */
function __KengineModsModManager() constructor {
	var this = self;

	self.toString = function() {
		return string("<ModManager (Kengine.Extensions.Mods.mod_manager)>");
	}

	Kengine.Utils.Events.Fire("mods__mod_manager__init__before", {mod_manager: this})

	/**
	 * @name mods
	 * @type {Kengine.Collection}
	 * @memberof Kengine.Extensions.Mods.ModManager
	 * @description Collection of `Mod` objects that are found by {@link Kengine.Extensions.Mods.ModManager.FindMods}. Defaults to empty Collection.
	 *
	 */
	self.mods = [];

	/**
	 * @function find_mods
	 * @memberof Kengine.Extensions.Mods.ModManager
	 * @description A function to search for mods. It uses `find_mods_func`.
	 * @return {Collection|Array<Kengine.Extensions.Mods.Mod>}
	 * 
	 */
	self.find_mods_func = KENGINE_MODS_FIND_MODS_FUNCTION
	self.FindMods = function() {
		var this = self;
		var _mods = [];
		Kengine.Utils.Events.Fire("mods__mod_manager__find_mods__before", {mod_manager: this, _mods});
		if is_string(self.find_mods_func) {
			if struct_exists(extension, self.find_mods_func) {
				self.find_mods_func = struct_get(extension, self.find_mods_func);
				self.find_mods_func = method({this}, self.find_mods_func);
			} else {
				self.find_mods_func = undefined;
			}
		}
		if self.find_mods_func != undefined {
			if array_length(_mods) == 0 {
				try {
					_mods = Kengine.Utils.Structs.SetDefault(self, "mods", self.find_mods_func());
				} catch (e) {
					Kengine.console.echo_error("Kengine: Mods: Error: " + e.longMessage);
					return false;
				}
			}
		} else {
			var _is_empty = false;
			if is_instanceof(_mods, Kengine.Collection) {
				if _mods.Length() == 0 {
					_is_empty = true;
				}
			} else {
				if array_length(_mods) == 0 {
					_is_empty = true;
				}
			}
			if _is_empty {
				Kengine.console.echo_ext(string("Kengine: Mods: Warning: No mods are found since there is no \"find_mods\" function option for {0}", self.toString()), c_yellow, true, true);
			}
		}
		if not is_instanceof(_mods, Kengine.Collection) {
			_mods = new Kengine.Collection(_mods);
		}
		Kengine.Utils.Events.Fire("mods__mod_manager__find_mods__after", {mod_manager: this, mods: _mods});
		
		for (var m=0;m<array_length(_mods); m++) {
			self.mods.AddOnce(_mods[m]);
		}
	}

	/**
	 * @function ReloadMods
	 * @param {Bool} [discover=true] Whether to discover new mods or not.
	 * @memberof Kengine.Extensions.Mods.ModManager
	 * @description A function to reload mods.
	 * 
	 */
	self.ReloadMods = function(discover=true) {
		if discover {
			self.FindMods();
		}
	}

	/**
	 * @function EnableMod
	 * @memberof Kengine.Extensions.Mods.ModManager
	 * @param {String|Kengine.Extensions.Mods.Mod} _mod The mod to enable.
	 * @param {Real} [force=0] Whether to enable the mod forcefully by enabling its dependencies.
	 * @description Enable a Mod. If forced, enable its dependencies.
	 * 
	 * Returns a struct containing `{success, dependencies_to_enable, dependencies_not_found, dependencies_enabled}`.
	 * 
	 * `success`: Whether enabling was successful.
	 * 
	 * `dependencies_to_enable`: Dependencies that still need to be enabled manually. If `force` is `true`, This should be an empty array.
	 * 
	 * `dependencies_not_found`: Dependencies that are needed but not found as initiated Mods.
	 *
	 * `dependencies_enabled`: Dependencies that are enabled as a result of calling this function.
	 *
	 * @return {Struct}
	 *
	 */
	self.EnableMod = function(_mod, force=0) {
		if is_string(_mod) {
			var mod_ind = self.mods.GetInd(_mod, Kengine.Utils.Cmps.cmp_val1_val2_name);
			if mod_ind == -1 {
				throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__mod__does_not_exist, string("Mod \"{0}\" does not exist.", _mod));
			}
			_mod = self.mods.Get(mod_ind);
		}

		_mod.ResolveDependencies();
		var _dependencies = _mod.dependencies;
		var _dependencies_to_enable = [];
		var _dependencies_not_found = [];
		var _dependencies_enabled = [];
		var _dependencies_met = 0;
		var _r;

		// Find dependencies structure, add them to the relevant arrays. Enable them if force.
		for (var _i=0; _i<array_length(_dependencies); _i++) {
			if is_string(_dependencies[_i]) {
				_dependencies_not_found[array_length(_dependencies_not_found)] = _dependencies[_i];
			} else if not _dependencies[_i].enabled {
				if (force >= 1) {
					_r = self.EnableMod(_dependencies[_i], true);
					if _r.success {
						_dependencies_enabled[array_length(_dependencies_enabled)] = _dependencies[_i];
						_dependencies_met ++;
					}
				} else {
					_dependencies_to_enable[array_length(_dependencies_to_enable)] = _dependencies[_i];
				}
			}
		}

		if _dependencies_met == array_length(_dependencies) {
			_mod.Enable();
			return {
				success: true,
				dependencies_to_enable: _dependencies_to_enable,
				dependencies_not_found: _dependencies_not_found,
				dependencies_enabled: _dependencies_enabled,
			};
		} else {
			return {
				success: false,
				dependencies_to_enable: _dependencies_to_enable,
				dependencies_not_found: _dependencies_not_found,
				dependencies_enabled: _dependencies_enabled,
			};
		}
	}

	/**
	 * @function DisableMod
	 * @memberof Kengine.Extensions.Mods.ModManager
	 * @param {String|Kengine.Extensions.Mods.Mod} _mod The mod to disable.
	 * @param {Real} [_force=0] Whether to disable the mod forcefully by disabling its dependants and dependencies.
	 * @description Disable a Mod. If forced, disable its dependants and dependencies.
	 *
	 * Returns a struct containing `{success, mods_disabled, dependants_to_disable, dependencies_to_disable}`.
	 *
	 * `success`: Whether disabling was successful.
	 *
	 * `mods_disabled`: All mods that have been disabled as a result of calling this function.
	 *
	 * `dependants_to_disable`: An array of `Mod` objects, which are dependants on the mod, if there are any that need to be disabled. If `force` is `1`, They are disabled and this is an empty array.
	 *
	 * `dependencies_to_disable`: An array of `Mod` objects, which are the dependencies of the mod, if there are any that are preferrably to be disabled (they are unused now). If `force` is `2`, They are disabled and this is an empty array.
	 *
	 * @return {Struct}
	 *
	 */
	self.DisableMod = function(_mod, _force=0) {
		var _mods;
		if is_string(_mod) {
			var mod_ind = self.mods.GetInd(_mod, Kengine.Utils.Cmps.cmp_val1_val2_name);
			if mod_ind == -1 {
				throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__mod__does_not_exist, string("Mod \"{0}\" does not exist.", _mod));
			}
			_mod = self.mods.Get(mod_ind);
		}

		_mod.ResolveDependencies();
		var _dependencies = _mod.dependencies;
		var _dependencies_to_disable = [];
		var _dependants_to_disable = [];
		var _mods_disabled = [];

		// Find dependencies structure, add them to the relevant arrays. Disable them if force.
		var do_disable;
		_mods = self.mods.GetAll();
		for (var _i=0; _i<array_length(_dependencies); _i++) {
			if is_string(_dependencies[_i]) {
				_dependencies_to_disable[array_length(_dependencies_to_disable)] = _dependencies[_i];
			} else if _dependencies[_i].enabled {
				if (_force >= 2) {
					do_disable = true;
					if do_disable {
						// if there are no other dependants that are active, disable them (without disabling further dependants).
						self.DisableMod(_dependencies[_i], 1);
						_mods_disabled[array_length(_mods_disabled)] = _dependencies[_i];
					}
				} else {
					_dependencies_to_disable[array_length(_dependencies_to_disable)] = _dependencies[_i];
				}
			}
		}

		// Find dependants and disable them if force.
		_mods = self.mods.Filter(method({_mod}, function(val) {
			return array_contains(val.dependencies, _mod);
		}));
		var _is_disabled = false;
		for (var _i=0; _i<array_length(_mods); _i++) {
			if (_force >= 1) {
				_is_disabled = self.DisableMod(_mods[_i], _force).success;
				if _is_disabled {
					_mods_disabled[array_length(_mods_disabled)] = _mods[_i];
				}
			} else {
				_dependants_to_disable[array_length(_dependants_to_disable)] = _mods[_i]
			}
		}

		if array_length(_dependencies_to_disable) == 0 {
			_mod.Disable();
			return {
				success: true,
				mods_disabled: _mods_disabled,
				dependants_to_disable: _dependants_to_disable,
				dependencies_to_disable: _dependencies_to_disable,
			};
		} else {
			return {
				success: false,
				mods_disabled: [],
				dependants_to_disable: _dependants_to_disable,
				dependencies_to_disable: _dependencies_to_disable,
			};
		}
	}

	/// feather disable GM1063
	self.mods = is_array(self.mods) ? new __KengineCollection(self.mods) : self.mods;

	Kengine.Utils.Events.Fire("mods__mod_manager__init__after", {mod_manager: this});
}
