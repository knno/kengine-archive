/// feather disable all

// ********************* KENGINE BEGIN *********************

#region internal

/**
 * @namespace Kengine
 * @description The Kengine namespace.
 * 
 */
function Kengine() constructor {

	static __opts = {
		private: true,
		public: [
			"initiated",
			"main_object",
		]
	}

	static initiated = false;

	static main_object = undefined;

	/**
	 * @namespace cmps
	 * @memberof Kengine
	 * @description A struct containing Kengine comparing functions.
	 * 
	 */
	static cmps = {

		/**
		 * @function cmp_val1_val2
		 * @memberof Kengine.cmps
		 * @description Return whether val1 equals val2.
		 * @param {Any} val1
		 * @param {Any} val2
		 * @return {Bool}
		 * 
		 */
		cmp_val1_val2: function(val1,val2) {return val1 == val2;},

		/**
		 * @function cmp_val1_val2_id
		 * @memberof Kengine.cmps
		 * @description Return whether val1 equals val2.id.
		 * @param {Any} val1
		 * @param {Any} val2
		 * @return {Bool}
		 * 
		 */
		cmp_val1_val2_id: function(val1,val2) {return val1 == val2.id;},

		/**
		 * @function cmp_val1_id_val2_id
		 * @memberof Kengine.cmps
		 * @description Return whether val1.id equals val2.id.
		 * @param {Any} val1
		 * @param {Any} val2
		 * @return {Bool}
		 * 
		 */
		cmp_val1_id_val2_id: function(val1,val2) {return val1.id == val2.id;},

		/**
		 * @function cmp_val1_name_val2_name
		 * @memberof Kengine.cmps
		 * @description Return whether val1.name equals val2.name.
		 * @param {Any} val1
		 * @param {Any} val2
		 * @return {Bool}
		 * 
		 */
		cmp_val1_name_val2_name: function(val1,val2) {return val1.name == val2.name;},

		/**
		 * @function cmp_val1_val2_name
		 * @memberof Kengine.cmps
		 * @description Return whether val1 equals val2.name.
		 * @param {Any} val1
		 * @param {Any} val2
		 * @return {Bool}
		 * 
		 */
		cmp_val1_val2_name: function(val1,val2) {return val1 == val2.name;},

		/**
		 * @function cmp_val1_val2_index
		 * @memberof Kengine.cmps
		 * @description Return whether val1 equals val2.index.
		 * @param {Any} val1
		 * @param {Any} val2
		 * @return {Bool}
		 * 
		 */
		cmp_val1_val2_index: function(val1,val2) {return val1 == val2.index;},

		/**
		 * @function cmp_unique_id_name
		 * @memberof Kengine.cmps
		 * @description Return whether val1.id equals val2.id AND val1.name equals val2.name. (Thus, the function name)
		 * @param {Any} val1
		 * @param {Any} val2
		 * @return {Bool}
		 * 
		 */
		cmp_unique_id_name: function(val1,val2) {return (val1.id == val2.id) and (val1.name == val2.name);},

		/**
		 * @function cmp_unique_attrs
		 * @memberof Kengine.cmps
		 * @description Return whether val1 and val2 have unique attributes via given method struct {unique_attrs}
		 * If the array has any attr as a subarray, it is considered a unique_together. Otherwise, compare that attr for val1 and val2.
		 * Unique together must be both equal.
		 * @param {Any} val1
		 * @param {Any} val2
		 * @return {Bool}
		 * 
		 * @example
		 * // Compare function for id and name. Attributes must be both the same to consider val1 and val2 equal.
		 * my_cmp = method({unique_attrs: [["id", "name"]]}, cmp_unique_attrs);
		 * 
		 * 
		 */
		cmp_unique_attrs: function(val1,val2) {
			var i=0; var j=0; var a; var h;
			var val1attrs_unique = []; var val2attrs_unique = [];
			var results = [];

			for (i=0; i<array_length(unique_attrs); i++) {
				if is_array(unique_attrs[i]) {
					for (j=0; j<array_length(unique_attrs[i]); j++) {
						a = unique_attrs[i][j];
						h = variable_get_hash(a);
						if struct_exists(val1, a) and struct_exists(val2, a) {
							array_push(val1attrs_unique, struct_get_from_hash(val1, h));
							array_push(val2attrs_unique, struct_get_from_hash(val2, h));
						}
					}
					if array_equals(val1attrs_unique, val2attrs_unique) {
						results[i] = true;
					} else {
						results[i] = false;
					}
				} else {
					a = unique_attrs[i];
					h = variable_get_hash(a);
					if struct_exists(val1, a) and struct_exists(val2, a) {
						if struct_get_from_hash(val1, h) == struct_get_from_hash(val2, h) {
							results[i] = true;
						} else {
							results[i] = false;
						}
					}
				}
			}
			for (i=0; i<array_length(results); i++) {
				if results[i] != true {
					return false;
				}
			}
			if array_length(results) == 0 {
				return false;
			}
			return true;
		},

		/**
		 * @function _cmp_id_or_name
		 * @memberof Kengine.cmps
		 * @private
		 * @param {Any} val
		 * @param {Any} ind
		 * @description A function that takes {id_or_name} method struct, and compares `val` attributes with it.
		 * This is used internally for {@link Kengine.AssetType.get_asset_replacement}
		 * 
		 */
		_cmp_id_or_name: function(val, ind) {
			if is_string(id_or_name) {
				return val.name == id_or_name or val.real_name == id_or_name;
			} else {
				return val.id == id_or_name;
			}
		},
	}

	/**
	 * @name instances
	 * @type {Kengine.Collection}
	 * @memberof Kengine
	 * @description This collection contains all {@link Kengine.Instance} instances created.
	 */
	static instances = new __KengineCollection();

	/**
	 * @name current_room_asset
	 * @type {Kengine.Asset|Undefined}
	 * @memberof Kengine
	 * @description The Room-type {@link Kengine.Asset} currently active as room.
	 */
	static current_room_asset = undefined;

	/**
	 * @member asset_type_options
	 * @type {Struct}
	 * @memberof Kengine
	 * @description A struct of asset types definitions. This is used at the start of the game to configure asset types.
	 * 
	 * @example
	 * // You can customize this in a ken_customize script
	 * Kengine.asset_type_options.sprite.indexing_range = [0,9]; // this will let only 9 sprites to be indexed.
	 * Kengine.asset_type_options.sprite.do_index = true;
	 * 
	 */
	static asset_type_options = {
		/**
		 * @name script
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type script in the YYP only. Required.
		 *
		 */
		script: {
			name: "script", // The name to call this asset type.
			asset_kind: asset_script, // This should be provided if representing a YYAsset. Required for indexing.
			exclude_prefixes: ["__", "ken__", "txr_", "anon_"], // Prefixes to exclude when indexing assets.
			
			/**
			 * When indexing, assets get the name from the real name (at runtime) of the asset.
			 * This name attribute can be renamed here. and the real name is kept.
			 * Also, the previous name (before renaming) is kept under `_original_name` attribute.
			 * 
			 * See: {@link Kengine.AssetType.rename_rules}
			 * 
			 */
			rename_rules: [
				// Rename rule 1: ken_script_ -> scr_
				{
					kind: "prefix", // Replace prefix.
					search: "ken_script_",
					replace_by: "scr_",
					// A function to call when renaming happens.
					when_successful: function() {
						// "this" refers to the script asset. We set it as public since it will be available to the end users
						// Presuming that using this prefix in the name means so.
						Kengine.utils.set_private(this, false);
					},
				},
				// Rename rule 2: Same as above, just remove ken_scr_
				{
					kind: "prefix",
					search: "ken_scr_",
					replace_by: "",
					when_successful: function() {
						Kengine.utils.set_private(this, false);
					},
				},
			],

			// Both are false, this means loading this asset type confs from mod files is disabled.
			is_addable: false, // Whether this script asset is addable in mod manager.
			is_replaceable: false, // Whether this script asset is replaceable in mod manager.

			// Var struct is for attributes to set to the asset type.
			var_struct: {
				// Whether scripts are exposed by default (asset type scope).
				default_private: false,
				// A filter function for when indexing script assets.
				index_asset_filter: function(asset) {
					// Remove script assets (even if renamed) that are added already to the index.
					// This happens because Script assets and function references are returned as 2d array by asset_get_ids.
					// What we want is the function references.
					var ind = asset.type.assets.get_ind(asset, function(val1,val2) {
						return (val1.real_name == val2.real_name) or (val1._original_name == val2.real_name);
					})
					if (ind != -1) {
						asset.type.assets.remove_by_ind(ind);
					}
					return true;
				},
			},

			// Assets var struct is for attributes to set to the assets when created of their type.
			assets_var_struct: {
			},

			do_index: true, // Index the assets.
		},

		/**
		 * @name sprite
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type sprite in the YYP and sprite-type assets.
		 * Set it to `undefined` to disable the sprite asset type functionality.
		 */
		sprite: {
			name: "sprite",
			index_range: [0,999999],
			exclude_prefixes: ["ken__", "__",],
			asset_kind: asset_sprite, // This should be provided if representing a YYAsset.
			unique_attrs: [], // Allow anything when adding assets.

			do_index: true,
		},
		
		/**
		 * @name tileset
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents sprites as tilesets.
		 * Set it to `undefined` to disable the tileset asset type functionality.
		 */
		tileset: {
			name: "tileset",
			index_range: [0,0],
			exclude_prefixes: ["ken__", "__",],
			asset_kind: KENGINE_CUSTOM_ASSET_KIND, // This should be provided if representing a YYAsset.
			unique_attrs: [], // Allow anything when adding assets.

			var_struct: {
				assets_conf_resolve: function (asset, conf, assetconf) {
					var vs = struct_get_names(conf);
					for (var i=0; i<array_length(vs); i++) {
						if vs[i] == "sprite" {
							conf.__sprite = conf.sprite;
							conf.sprite = Kengine.utils.get_asset("sprite", conf.sprite);
							if is_string(conf.sprite) or is_undefined(conf.sprite) {
								throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "sprite", conf.sprite), true);
							}
						}
					}
				},
			},

			do_index: true,
		},

		/**
		 * @name sound
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type sound in the YYP and sound-type assets.
		 *
		 */
		sound: {
			name: "sound",
			index_range: [0,9999],
			exclude_prefixes: ["__", "ken__", "txr_", "anon_",],
			asset_kind: asset_sound, // This should be provided if representing a YYAsset.
		
			do_index: true,
		},

		/**
		 * @name object
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type object in the YYP and object-type assets. Required.
		 *
		 */
		object: {
			name: "object",
			index_range: [0,999999],
			exclude_prefixes: [KENGINE_MAIN_OBJECT_RESOURCE, "obj_ken_object", "__", ],
			asset_kind: asset_object, // This should be provided if representing a YYAsset.
			unique_attrs: [], // Allow anything when adding assets.

			var_struct: {
				assets_conf_resolve: function (asset, conf, assetconf) {
					var vs = struct_get_names(conf);
					for (var i=0; i<array_length(vs); i++) {
						// Resolve parent
						if vs[i] == "parent" {
							conf.__parent = conf.parent;
							if conf.parent == "noone" {
								conf.parent = noone;
								continue;
							}
							conf.parent = Kengine.utils.get_asset("object", conf.parent);
							if is_string(conf.parent) or is_undefined(conf.parent) {
								throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "parent", conf.parent), true);
							}
						} else if vs[i] == "sprite" {
							conf.__sprite = conf.sprite;
							conf.sprite = Kengine.utils.get_asset("sprite", conf.sprite);
							if is_string(conf.sprite) or is_undefined(conf.sprite) {
								throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "sprite", conf.sprite), true);
							}
						} else if vs[i] == "event_scripts" {
							conf.__event_scripts = variable_clone(conf.event_scripts);
							var _is_error = false;
							var evs = struct_get_names(conf.event_scripts);
							for (var j=0; j<array_length(evs); j++) {
								if string_starts_with(conf.event_scripts[$ evs[j]], "@") {
									// keep as is
									continue;
								}
								var filepath = filename_dir(assetconf.source_mod.source);
								var f = filepath + "/" + conf.event_scripts[$ evs[j]]
								if string_ends_with(f, KENGINE_CUSTOM_SCRIPT_EXTENSION) {
									// A reference to a file of a custom script.
									_ev_custom_script_text = Kengine.mods.read_file(f, true);
									if _ev_custom_script_text != undefined {
										_ev_custom_script = new Kengine.Asset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, assetconf.source_mod.name + "__" + conf.name + "__ev_" + evs[j], false);
										_ev_custom_script.src = _ev_custom_script_text;
										_ev_custom_script.compile();
									} else {
										_is_error = true
									}
								} else {
									// A reference to a defined custom script.
									_ev_custom_script = Kengine.utils.get_asset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, conf.event_scripts[$ evs[j]]);
									if _ev_custom_script != undefined {
										if not _ev_custom_script.is_compiled {
											_ev_custom_script.compile();
										}
									} else {
										_is_error = true;
									}
								}
								if _is_error {
									throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "event_scripts["+evs[j]+"]", conf.event_scripts[$ evs[j]]), true);
								}
								conf.event_scripts[$ evs[j]] = _ev_custom_script;
							}
						}
					}
				},
			},

			do_index: true,
		},

		/**
		 * @name rm
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type rooms in the YYP and room-type assets. Required.
		 */
		rm: {
			name: "rm",
			index_range: [0,9999],
			exclude_prefixes: ["__",],
			asset_kind: asset_room,
			is_addable: true,
			is_replaceable: false,
			unique_attrs: [],
			/*
			 * When a room asset is resolved, some elements are added to its data with a leading underscore.
			 * It is like adding a room to the game, but not to the current room.
			 * To "apply" the room asset to the current room, activation and deactivation are the terms used.
			 *
			 * The methods can be replaced for managing the room activation and deactivation with your own code or library.
			 *
			 */
			assets_var_struct: {
				is_active: false,
				activate: function() { // {this}
					// TODO: iterate room_info and add stuff to the room.
					Kengine.current_room_asset.deactivate();
					this.is_active = true;
				},
				deactivate: function() { // {this}
					// TODO: iterate room_created_info and remove from the room.
					// unless it is persistent.

					if this.is_active == false {
						return;
					}
					this.is_active = false;
				},
			},
			var_struct: {
				assets_conf_resolve: function (asset, conf, assetconf) {
					var vs = struct_get_names(conf);
					var path_kind = undefined;
					var data;
					if array_contains(vs, "path") {
						if string_ends_with(conf.path, ".yy") {
							path_kind = "yy";
						} else if string_ends_with(conf.path, ".tmx") {
							path_kind = "tmx";
						} else if string_ends_with(conf.path, ".json") {
							path_kind = "json";
						}
						conf.__data = __kengine_load_room_file(assetconf.source_mod_base + "/" + conf.path, path_kind);
						conf.data = variable_clone(conf.__data);

					} else if !array_contains(vs, "data") {
						throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" data/path property not found.", assetconf), true);
					} else {
						conf.__data = conf.data;
						conf.data = variable_clone(conf.__data);
					}

					data = Kengine.utils.structs.get(conf, "data");
					if data != undefined {
						asset.room_info = {
							width: Kengine.utils.structs.get(conf.data, "width") ?? 200,
							height: Kengine.utils.structs.get(conf.data, "height") ?? 200,
							creation_script_name: Kengine.utils.structs.get(conf.data, "creation_script_name") ?? undefined, // TODO workaround for kscript.
							physicsWorld: Kengine.utils.structs.get(conf.data, "physicsWorld") ?? false,
							physicsGravityX: Kengine.utils.structs.get(conf.data, "physicsGravityX") ?? 0,
							physicsGravityY: Kengine.utils.structs.get(conf.data, "physicsGravityY") ?? 0,
							physicsPixToMeters: Kengine.utils.structs.get(conf.data, "physicsPixToMeters") ?? 0.1,
							presistent: false, // conf.data.persistent,
							enableViews: Kengine.utils.structs.get(conf.data, "enableViews") ?? false,
							clearDisplayBuffer: Kengine.utils.structs.get(conf.data, "clearDisplayBuffer") ?? true,
							clearViewportBackground: Kengine.utils.structs.get(conf.data, "clearViewportBackground") ?? true,
							colour: Kengine.utils.structs.get(conf.data, "colour") ?? c_white,
							instances: Kengine.utils.structs.get(conf.data, "instances") ?? [],
							layers: Kengine.utils.structs.get(conf.data, "layers") ?? [],
							views: Kengine.utils.structs.get(conf.data, "views") ?? [],
						};

						// Instances.
						var r = undefined; var a, b, c;
						for (var i=0; i<array_length(asset.room_info.instances); i++) {
							a = asset.room_info.instances[i];
							if !Kengine.utils.structs.exists(a, "x") or !Kengine.utils.structs.exists(a,"y")
							or !Kengine.utils.structs.exists(a, "object_index") or !Kengine.utils.structs.exists(a, "id") {
								throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("Room \"{0}\" essential properties of instance struct(s) missing.", assetconf), true);
							}

							if (is_string(Kengine.utils.structs.get(a, "object_index"))) {
								if (not Kengine.utils.structs.exists(a, "_object_name")) {
									c = a.object_index;
								} else {
									c = a._object_name;
								}
								r = Kengine.utils.get_asset("object", c);
								if r == undefined {
									throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("Room \"{0}\" instance {1} object not found.", assetconf, string(a.id)), true);
								}
								a._object_name = r.name;
								a.object_index = r.index;
							}
							/* Do these when creating */
							/*
							if (is_string(Kengine.utils.structs.get(a, "creation_script_name"))) {
								r = Kengine.utils.get_asset("script", a.creation_script_name);
								a.creation_script_name = r.name;
							}
							if (is_string(Kengine.utils.structs.get(a, "pre_creation_script_name"))) {
								r = Kengine.utils.get_asset("script", a.pre_creation_script_name);
								a.pre_creation_script_name = r.name;
							}*/
						}

						// Layers.
						for (var i=0; i<array_length(asset.room_info.layers); i++) {
							a = asset.room_info.layers[i];
							b = a.elements;
							for (var j=0; j<array_length(b); j++) {
								switch (b[j].type) {
									case layerelementtype_instance:
										break;

									case layerelementtype_sequence:
										break;

									case layerelementtype_background:
									case layerelementtype_sprite:
										if (Kengine.utils.structs.exists(b[j], "sprite_index")) {
											if (not Kengine.utils.structs.exists(b[j], "_sprite_name")) {
												c = b[j].sprite_index;
											} else {
												c = b[j]._sprite_name;
											}
											r = Kengine.utils.get_asset("sprite", c);
											if r == undefined {
												throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} sprite not found.", assetconf, string(i)), true);
											}
											b[j]._sprite_name = r.name;
											b[j].sprite_index = r.id;
										} else {
											throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} sprite not set.", assetconf, string(i)), true);
										}
										break;
									case layerelementtype_tilemap:
										if (Kengine.utils.structs.exists(b[j], "tileset_index")) {
											if (not Kengine.utils.structs.exists(b[j], "_tileset_name")) {
												c = b[j].tileset_index;
											} else {
												c = b[j]._tileset_name;
											}
											r = Kengine.utils.get_asset("tileset", c);
											if r == undefined {
												throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} tileset not found.", assetconf, string(i)), true);
											}
											b[j]._tileset_name = r.name;
											b[j].tileset_index = r.id;
										} else {
											throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} tileset not set.", assetconf, string(i)), true);
										}
										break;
									
								}
							}
							
						}

						// Views.
						for (var i=0; i<array_length(asset.room_info.views); i++) {
							a = asset.room_info.views[i];
							if (is_string(Kengine.utils.structs.get(a, "object"))) { // target can be object or instance.
								if (not Kengine.utils.structs.exists(a, "_object_name")) {
									c = a.object;
								} else {
									c = a._object_name;
								}
								r = Kengine.utils.get_asset("object", c);
								if r == undefined {
									r = Kengine.instances.get_ind(c, Kengine.cmps.cmp_val1_id_val2_id);
									if r == undefined {
										throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("Room \"{0}\" view camera {1} object/instance \"{1}\" not found.", assetconf, string(a.cameraID), string(c)), true);
									} else {
										r = Kengine.utils.get_asset("object", r.instance.id); // real ID.
										if r != undefined {
											a._object_name = r.name;
											a.object = r.index;
										}
									}
								} else {
									a._object_name = r.name;
									a.object = r.index;
								}
								// TODO: Override when the first instance is set in the room to make the camera_set_view_target. (controller, step?)
							}

						}

						// TODO: Change tilesets to custom Kengine tilesets?
					}
				}
			},

			do_index: true,
		}

	};

	/**
	 * @member asset_types
	 * @type {Struct}
	 * @memberof Kengine
	 * @description The asset types struct of Kengine.
	 *
	 */
	static asset_types = {};

	/**
	 * @namespace utils
	 * @memberof Kengine
	 * @description Kengine utils library.
	 * 
	 */
	static utils = {

		/**
		 * @function start
		 * @memberof Kengine.utils
		 * @private
		 * @description Start Kengine and its extensions.
		 */
		start: function() {
			Kengine.utils.events.fire("start__before");

			// Kengine.utils.set_private(Kengine)
			Kengine.utils.set_private(Kengine.utils.hashkeys);
			Kengine.utils.set_private(Kengine.utils.parser);

			Kengine.AssetType = __KengineAssetType;
			Kengine.Asset = __KengineAsset;
			Kengine.Instance = __KengineInstance;

			// Placeholder console.
			Kengine._console_backlog = [];
			Kengine.console = {
				echo_error: function(msg) {
					Kengine._console_backlog[array_length(Kengine._console_backlog)] = {
						msg,
						kind: "echo_error",
					}
				},
				echo_ext: function(msg, color, notify=false, write=false) {
					Kengine._console_backlog[array_length(Kengine._console_backlog)] = {
						msg,
						color,
						kind: "echo_ext",
						notify,
						write,
					}
				},
				echo: function(msg) {
					Kengine._console_backlog[array_length(Kengine._console_backlog)] = {
						msg,
						kind: "echo",
					}			
				},
				debug: function(msg) {
					Kengine._console_backlog[array_length(Kengine._console_backlog)] = {
						msg,
						kind: "debug",
					}
				},
				verbose: function(msg, verbosity) {
					if KENGINE_VERBOSITY >= verbosity {
						Kengine._console_backlog[array_length(Kengine._console_backlog)] = {
							msg,
							kind: "debug",
						};
					}
				}
			}

			if (KENGINE_BENCHMARK) {
				var timer = get_timer(); var diff = timer - Kengine._timings[0]; Kengine._timings[0] = timer;
				Kengine.console.verbose("Kengine: Benchmark: Start: " + string(diff/1000) + "ms", 1);
			}

			if (KENGINE_BENCHMARK) {
				var timer = get_timer(); var diff = timer - Kengine._timings[0]; Kengine._timings[0] = timer;
				Kengine.console.verbose("Kengine: Benchmark: Indexing - Begin: " + string(diff/1000) + "ms", 1);
			}

			// Create AssetTypes.
			var _assettype, _assettype_name, _assettype_opts, _assettype_names = struct_get_names(Kengine.asset_type_options);
			for (var i=0; i<array_length(_assettype_names); i++) {
				_assettype_name = _assettype_names[i];
				_assettype_opts = Kengine.utils.structs.get(Kengine.asset_type_options, _assettype_name);
				if _assettype_opts != undefined {
					_assettype = new Kengine.AssetType(_assettype_opts);
					// Index sprites.
					if struct_exists(_assettype_opts, "do_index") {
						if _assettype_opts.do_index {
							_assettype.index_assets();
						}
						if (KENGINE_BENCHMARK) {
							var timer = get_timer(); var diff = timer - Kengine._timings[0]; Kengine._timings[0] = timer;
							Kengine.console.verbose("Kengine: Benchmark: Indexing " + string(_assettype.name) + " - Complete: " + string(diff/1000) + "ms", 1);
						}
					}
				}
			}

			// Define default object asset.
			Kengine._default_object_asset = new Kengine.Asset(Kengine.asset_types.object, "obj_default_object", true, obj_ken_object);
			Kengine._default_object_asset.real_name = "obj_ken_object";
			// @feather ignore GM1008
			Kengine._default_object_asset.id = obj_ken_object; // Resource
			Kengine._default_object_asset.parent = undefined;
			Kengine._default_object_asset.event_scripts = {};
		
			if (KENGINE_BENCHMARK) {
				var timer = get_timer(); var diff = timer - Kengine._timings[0]; Kengine._timings[0] = timer;
				Kengine.console.verbose("Kengine: Benchmark: Indexing - Complete: " + string(diff/1000) + "ms", 1);
			}

			var exts = Kengine.utils.exts.find_extensions(); // {my_ext: <Asset >, ...}
			Kengine.utils.events.fire("extensions__before", {extension_assets: exts,});
			var exts_names = struct_get_names(exts);
			var exts_order = Kengine.utils.structs.get(Kengine.utils.exts, "exts_order");
			if exts_order != undefined {
				array_sort(exts_names, method({names: exts_order}, function(elm1, elm2) {
					var e1 = array_get_index(names, elm1);
					var e2 = array_get_index(names, elm2);
					return e1 >= e2;
				}));
			}
			for (var i=0; i<array_length(exts_names); i++) {
				var ext_name = exts_names[i];
				var h = variable_get_hash(ext_name);
				var extstruct = {
					name: ext_name,
					asset: struct_get_from_hash(exts, h),
				};
				Kengine.utils.events.fire("extension__start__before", {extension: extstruct});
				Kengine.utils.exts.start_extension(extstruct);
				Kengine.utils.events.fire("extension__start__after", {extension: extstruct});
			}
			Kengine.utils.events.fire("extensions__after", {extensions: exts,});
			Kengine.utils.events.fire("start__after");
			if (KENGINE_BENCHMARK) {
				var timer = get_timer(); var diff = timer - Kengine._timings[1]; Kengine._timings[1] = timer;
				Kengine.console.verbose("Kengine: Benchmark: Complete in " + string(diff/1000) + "ms", 1);
			}
		},

		/**
		 * @function get_asset
		 * @memberof Kengine.utils
		 * @description Retrieve an {@link Kengine.Asset} from an AssetType.
		 * @param {Kengine.AssetType|String} asset_type The type of the asset to retrieve.
		 * @param {Real|String} id_or_name The real ID or name of the asset.
		 * @return {Kengine.Asset|Undefined} An asset, or `undefined`.
		 *
		 */
		get_asset: function(asset_type, id_or_name) {
			if is_string(asset_type) {
				asset_type = Kengine.utils.structs.get(Kengine.asset_types, asset_type);
			}
			var asset = asset_type.get_asset_replacement(id_or_name, "asset", 0);
			return asset;
		},

		/**
		 * @function is_public
		 * @memberof Kengine.utils
		 * @description Return whether `object` member `member_name` is public or not. (`.__opts.public`)
		 * @param {Any} _object
		 * @param {String} member_name
		 * @param {Any} [default_val=undefined]
		 * @return {Bool}
		 *		 
		 */
		is_public: function(_object, member_name=undefined, default_val=undefined) {
			var halt = undefined;
			var rules = KENGINE_PARSER_FIELD_RULES;
			var opts = Kengine.utils.structs.get(_object, "__opts");
			var _pub = false;
			if is_struct(opts) {
				_pub = Kengine.utils.structs.get(opts, "public");
			}
			if _pub == false or _pub == undefined {
				if array_length(rules) > 0 {
					var r = "";
					for (var j=0; j<array_length(rules); j++) {
						switch (rules[j]) {
							case "?": // allow only not private
								if Kengine.utils.is_private(_object) == false {
									continue;
								}
								halt = Kengine.utils.parser._TXR.System._sfmt("Cannot access private members of (%).", string(_object));
								break;

							case "!?": // allow only is private
								if Kengine.utils.is_private(_object) == true {
									continue;
								}
								halt = Kengine.utils.parser._TXR.System._sfmt("Cannot access members of (%).", string(_object));
								break;

							default:
								if string_starts_with(rules[j], "!") {
									r = string_copy(rules[j], 2, string_length(rules[j]) - 1);
									if string_starts_with(member_name, r) {
										halt = Kengine.utils.parser._TXR.System._sfmt("Cannot access private members of (%).", string(_object));
										break;
									}
								} else {
									r = rules[j];
									if not string_starts_with(member_name, r) {
										halt = Kengine.utils.parser._TXR.System._sfmt("Cannot access private members of (%).", string(_object));
										break;
									}
								}
								break;
						}
					}
				}
			} else if is_array(_pub) {
				if !array_contains(_pub, member_name) {
					halt = true; //"Cannot access members of (%)"
				}
			} else if _pub == true {
				halt = undefined;
			} else {
				halt = true; // "Cannot access members of (%)"
			}
			if halt != undefined {
				return false;
			} else {
				return true;
			}
		},

		/**
		 * @function is_private
		 * @memberof Kengine.utils
		 * @description Return whether `object` is private or not. (`.__opts.private`)
		 * @param {Any} _object
		 * @param {String|Undefined} [member_name=undefined] The member if you want to get its access privacy.
		 * @param {Bool} [default_val=undefined]
		 * @return {Bool} Whether it is private or not.
		 *
		 */
		is_private: function(_object, member_name=undefined, default_val=undefined) {
			if default_val == undefined {
				default_val = Kengine.utils.parser.constants.default_private
			}
			if is_array(_object) {
				if member_name == undefined {
					return default_val;
				} else {
					throw Kengine.utils.errors.create(Kengine.utils.errors.types.array__access_with_name);
				}
			}

			// Mini hack for Assets
			var tde = undefined;
			if is_instanceof(_object, Kengine.Asset) {
				tde = Kengine.utils.structs.get(_object.type, "default_private");
			}

			var o, val;
			if is_method(_object) {
				o = static_get(_object);
			} else {
				o = _object;
			}

			if member_name != undefined {
				// Get if the member is private as access AND itself.
				var _dots = string_split(member_name, ".");
				if array_length(_dots) > 1 {
					var _dot = array_pop(_dots);
					_dots = string_join_ext(".", _dots);
					var oo = Kengine.utils.structs.dotget(o, _dot);
					return Kengine.utils.structs.is_private(oo, _dot, default_val);
				} else {
					val = Kengine.utils.structs.dotget(o, "__opts.private");
				}
			} else {
				// No member name, Check for the current object itself.
				val = Kengine.utils.structs.dotget(o, "__opts.private") ?? default_val;
			}

			if val == undefined {
				if tde != undefined { return tde; }
			}
			if is_array(val) {
				if member_name != undefined {
					return array_contains(val, member_name);
				} else {
					return false; // Only privates are in the array.
				}
			}
			if is_method(val) {return val();} else {return val;}
		},

		/**
		 * @function set_private
		 * @memberof Kengine.utils
		 * @description Set `object` is private or not. (`.__opts.private`)
		 * @param {Any} _object
		 * @param {String|Undefined} [member_name=undefined] The member if you want to set the privacy on its access.
		 * @param {Bool} private Whether it is private or not.
		 *
		 */
		set_private: function(_object, member_name=undefined, private=true) {
			if is_array(_object) {
				throw Kengine.utils.errors.create(Kengine.utils.errors.types.array__cannot_be_private);
			}

			var o, val;
			if is_method(_object) {
				o = static_get(_object);
			} else {
				o = _object;
			}

			if member_name != undefined {
				// Set the member private as access.. add it to the list.
				var _dots = string_split(member_name, ".");
				if array_length(_dots) > 1 {
					// If a dot is provided...
					var _dot = array_pop(_dots);
					_dots = string_join_ext(".", _dots);
					var oo = Kengine.utils.structs.dotget(o, _dot);
					return Kengine.utils.structs.set_private(oo, _dot, private);
				} else {
					val = Kengine.utils.structs.dotget(o, "__opts.private");
					if not is_array(val) {
						val = []
					}
					array_push(val, member_name);
					Kengine.utils.structs.dotset(o, "__opts.private", val);
				}
			} else {
				// No member name, Set for the current object itself as private, by using a bool.
				Kengine.utils.structs.dotset(o, "__opts.private", private);
			}
		},

		/**
		 * @function is_readonly
		 * @memberof Kengine.utils
		 * @description Return whether `object` is readonly or not. (`.__opts.readonly`)
		 * @param {Any} _object
		 * @param {String|Undefined} [member_name=undefined] The member if you want to get its access readonliness.
		 * @param {Bool} [default_val=undefined]
		 * @return {Bool} Whether it is private or not.
		 *
		 */
		is_readonly: function(_object, member_name=undefined, default_val=undefined) {
			if default_val == undefined {
				default_val = false; // DEFAULT READONLY.
			}

			if is_array(_object) {
				if member_name == undefined {
					return default_val;
				} else {
					throw Kengine.utils.errors.create(Kengine.utils.errors.types.array__access_with_name);
				}
			}

			var o, val;
			if is_method(_object) {
				o = static_get(_object);
			} else {
				o = _object;
			}
			
			if member_name != undefined {
				// Get if the member is readonly as access AND itself.
				var _dots = string_split(member_name, ".");
				if array_length(_dots) > 1 {
					var _dot = array_pop(_dots);
					_dots = string_join_ext(".", _dots);
					var oo = Kengine.utils.structs.dotget(o, _dot);
					return Kengine.utils.structs.is_readonly(oo, _dot, default_val);
				} else {
					val = Kengine.utils.structs.dotget(o, "__opts.readonly");
				}
			} else {
				// No member name, Check for the current object itself.
				val = Kengine.utils.structs.dotget(o, "__opts.readonly") ?? default_val;
			}

			if is_array(val) {
				if member_name != undefined {
					return array_contains(val, member_name);
				} else {
					return false; // Only readonlies are in the array.
				}
			}
			if is_method(val) {return val();} else {return val;}
		},

		set_readonly: function(_object, member_name=undefined, readonly=true) {
			if is_array(_object) {
				throw Kengine.utils.errors.create(Kengine.utils.errors.types.array__cannot_be_readonly);
			}

			var o, val;
			if is_method(_object) {
				o = static_get(_object);
			} else {
				o = _object;
			}

			if member_name != undefined {
				// Set the member private as access.. add it to the list.
				var _dots = string_split(member_name, ".");
				if array_length(_dots) > 1 {
					// If a dot is provided...
					var _dot = array_pop(_dots);
					_dots = string_join_ext(".", _dots);
					var oo = Kengine.utils.structs.dotget(o, _dot);
					return Kengine.utils.structs.set_readonly(oo, _dot, private);
				} else {
					val = Kengine.utils.structs.dotget(o, "__opts.readonly");
					if not is_array(val) {
						val = []
					}
					array_push(val, member_name);
					Kengine.utils.structs.dotset(o, "__opts.readonly", val);
				}
			} else {
				// No member name, Set for the current object itself as private, by using a bool.
				Kengine.utils.structs.dotset(o, "__opts.readonly", readonly);
			}
		},

		/**
		 * @namespace exts
		 * @memberof Kengine.utils
		 * @description Kengine utility functions that deal with Kengine extensions.
		 */
		exts: {
			
			exts_order: [
				"parser", "mods", "panels", "tests",
			],

			/**
			 * @function find_extensions
			 * @private
			 * @memberof Kengine.utils.exts
			 * @description Find extensions to start. The name of script assets that starts with `ken_init_ext_` are matched.
			 * @return {Array<Kengine.Asset>} Assets of function scripts that are extensions.
			 *
			 */
			find_extensions: function() {
				var exts = {};
				var founds = Kengine.asset_types.script.assets.filter(function (val) {
					return string_starts_with(val.name, "ken_init_ext_");
				});
				for (var i=0; i<array_length(founds); i++) {
					var ext_name = string_replace(founds[i].name, "ken_init_ext_", "");
					exts[$ ext_name] = founds[i];
				}
				return exts;
			},
						
			/**
			 * @function start_extension
			 * @private
			 * @memberof Kengine.utils.exts
			 * @description Start extension.
			 * @param {Struct} extstruct contains name and asset keys with their values.
			 *
			 */
			start_extension: function(extstruct) {
				Kengine.console.debug("Kengine: Starting extension: " + extstruct.name);
				extstruct.asset.id(); // Real ID.
			},

		},

		/**
		 * @namespace strings
		 * @memberof Kengine.utils
		 * @description Kengine utility functions that deal with strings.
		 * 
		 */
		strings: {

			/**
			 * @function string_pos_direction
			 * @memberof Kengine.utils.strings
			 * @description	Find position of the next string that is after sep, starting from pos, in direction dir.
			 * @param {String} text The main text.
			 * @param {String} sep The separation of text words.
			 * @param {Real} [dir=1] The direction to look.
			 * @param {Real} [pos=0] The position to start.
			 * @return {Real} The position of the first occurence of a word.
			 *
			 */ 
			string_pos_direction: function(text, sep, dir=1, pos=0) {
				var i, j;
				j = string_length(text);
				if (dir == 1) { 
					for (i = min(j, pos); i>= 1; i--)
						{
						if (string_char_at(text, i) == sep)
							{
							if (i==1)
								{
								return i;
								}
							else
								{
								if (string_char_at(text, i-1) != sep)
									{
									return i;
									}
								}
							}
						}
					return 0;
				} else {
					for (i = pos; i<=j; i++) {
						if (string_char_at(text, i) == sep)
							{
							if (i == j)
								{
								return i;
								}
							else
								{
								if (string_char_at(text, i+1) != sep)
									{
									return i-1;
									}
								}
							}
						}
					return j;
				}
			},

		},

		/**
		 * @namespace errors
		 * @memberof Kengine.utils
		 * @description A struct containing Kengine error creation function and error types.
		 * 
		 */
		errors: {

			/**
			 * @function create
			 * @memberof Kengine.utils.errors
			 * @description Create an error struct that is thrown.
			 * @param {String} [error_type="unknown"] Error type as a string, or as a reference to an attribute of `Kengine.utils.errors.types`.
			 * @param {String} [longMessage=""]
			 * @param {Bool} [useLong=false]
			 * @return {Struct}
			 * 
			 */
			create: function(error_type="unknown", longMessage="", useLong=false) {
				var _types = Kengine.utils.errors.types;
				if not Kengine.utils.structs.exists(_types, error_type) {
					var names = struct_get_names(_types);
					for (var i = 0; i < array_length(names); i++) {
						var name = names[i];
						var value = struct_get(_types, name);
						if (value == error_type) {
							error_type = name;
							break;
						}
					}
					if error_type == "unknown" {
						error_type = _types.error__does_not_exist;
					}
				}
				return {
					error_source: "kengine",
					error_type: error_type,
					stacktrace: debug_get_callstack(),
					message: useLong ? longMessage : Kengine.utils.structs.get(_types, error_type),
					longMessage: longMessage,
				}
			},

			/**
			 * @member {Struct} types
			 * @memberof Kengine.utils.errors
			 * @description Preset error types. These errors are extendable through Kengine extensions.
			 * 
			 */
			types: {

				toString: function(){ return "list"; },

				/**
				 * @member {String} unknown
				 * @memberof Kengine.utils.errors.types
				 * @description Unknown error occured.
				 */
				unknown: "Unknown error occured.",

				/**
				 * @member {String} array__access_with_name
				 * @memberof Kengine.utils.errors.types
				 * @description Cannot access array by name.
				 */
				array__access_with_name: "Cannot access array by name.",
				
				/**
				 * @member {String} array__cannot_be_private
				 * @memberof Kengine.utils.errors.types
				 * @description Arrays cannot become private.
				 */
				array__cannot_be_private: "Arrays cannot become private.",
				
				/**
				 * @member {String} array__cannot_be_readonly
				 * @memberof Kengine.utils.errors.types
				 * @description Arrays cannot become readonly.
				 */
				array__cannot_be_readonly: "Arrays cannot become readonly.",

				/**
				 * @member {String} error__does_not_exist
				 * @memberof Kengine.utils.errors.types
				 * @description Error is not defined.
				 * 
				 */
				error__does_not_exist: "Error is not defined.",

				/**
				 * @member {String} asset__asset_type__does_not_exist 
				 * @memberof Kengine.utils.errors.types
				 * @description Cannot create asset (non-existent AssetType). 
				 * 
				 */
				asset__asset_type__does_not_exist: "Cannot create asset (non-existent AssetType).",

				/**
				 * @member {String } asset__asset_type__cannot_replace
				 * @memberof Kengine.utils.errors.types
				 * @description Cannot replace Asset (AssetType is not replaceable).
				 *
				 */
				asset__asset_type__cannot_replace: "Cannot replace Asset (AssetType is not replaceable).",
				
				/**
				 * @member {String } asset__cannot_replace
				 * @memberof Kengine.utils.errors.types
				 * @description Cannot replace Asset.
				 *
				 */
				asset__cannot_replace: "Cannot replace Asset.",

				/**
				 * @member {String } asset__asset_type__cannot_add
				 * @memberof Kengine.utils.errors.types
				 * @description Cannot add Asset (AssetType is not addable).
				 *
				 */
				asset__asset_type__cannot_add: "Cannot add Asset (AssetType is not addable).",

				/** 
				 * @member {String} asset_type__asset_type__exists
				 * @memberof Kengine.utils.errors.types
				 * @description AssetType already defined.
				 * 
				*/
				asset_type__asset_type__exists: "AssetType already defined.",

				/** 
				 * @member {String} asset_type__does_not_exist
				 * @memberof Kengine.utils.errors.types
				 * @description AssetType does not exist.
				 * 
				*/
				asset_type__does_not_exist: "AssetType does not exist.",

				/** 
				 * @member {String} instance__asset__does_not_exist
				 * @memberof Kengine.utils.errors.types
				 * @description Cannot create instance from asset (non-existent Asset).
				 * 
				 */
				instance__asset__does_not_exist: "Cannot create instance from asset (non-existent Asset).",

				/**
				 * @member {String} script_exec__script__does_not_exist
				 * @memberof Kengine.utils.errors.types
				 * @description Cannot execute script (non-existent script). 
				 * 
				 */
				script_exec__script__does_not_exist: "Cannot execute script (non-existent script).",
			}
		},

		/**
		 * @namespace arrays
		 * @memberof Kengine.utils
		 * @description A struct containing Kengine extra array manipulation functions.
		 * 
		 */
		arrays: {
			
			/**
			 * @function delete_value
			 * @memberof Kengine.utils.arrays
			 * @description Delete value from an array.
			 * @param {Array<Any>} array
			 * @param {Any} value
			 * @param {Bool} _all
			 * @return {Real} Count of deleted indices.
			 * 
			 */
			delete_value: function(array, value, _all=false) {
				var index = 0;
				if (!_all) {
					repeat (array_length(array)) {
						if (array[index] == value){ array_delete(array, index, 1); return 1;}
						index++;
					}
				} else {
					var count = 0;
					repeat (array_length(array)) {
						if (array[index] == value) {array_delete(array, index, 1); count++;} else {index++;};
					}
					return count;
				}
				return 0;
			},
			
			/** 
			 * @function min_max
			 * @memberof Kengine.utils.arrays
			 * @description Return the minimum and maximum numbers in an array
			 * @param {Array} arr The input array
			 * @returns {Array<Any>} An array containing the minimum and maximum numbers
			 * 
			 */
			min_max: function(arr) {
				var min_val = arr[0];
				var max_val = arr[0];

				for (var i = 1; i < array_length(arr); i++) {
					if (arr[i] < min_val) {
						min_val = arr[i];
					}
					if (arr[i] > max_val) {
						max_val = arr[i];
					}
				}

				return [min_val, max_val];
			},

		},

		/**
		 * @namespace structs
		 * @memberof Kengine.utils
		 * @description Kengine utility functions that deal with structs.
		 * 
		 */
		structs: {

			/**
			 * @function exists
			 * @memberof Kengine.utils.structs
			 * @description Check whether a struct member exists.
			 * @param {Struct} _struct The struct.
			 * @param {String|Struct} name The name or hash key.
			 * @return {Bool} Whether the struct member exists.
			 *
			 */
			exists: function(_struct, name) {
				if !is_struct(_struct) {
					return variable_instance_exists(_struct, name);
				} else if is_string(name) {
					return struct_exists(_struct, name);
				} else if is_struct(name) {
					return struct_exists(_struct, name.name);
				} else {
					return struct_get_from_hash(_struct, name) != undefined;
				}
			},

			/**
			 * @function get
			 * @memberof Kengine.utils.structs
			 * @description Get a struct member.
			 * @param {Struct} _struct The struct to get from.
			 * @param {String|Real|Struct} name The hash key to use. If it's a struct, uses "hash" attr.
			 * @return {Any} The value.
			 * 
			 */
			get: function(_struct, name) {
				if exists(_struct, name) {
					if !is_struct(_struct) {
						return variable_instance_get(_struct, name);
					}
					return struct_get_from_hash(_struct, Kengine.utils.hashkeys.hash(name));
				}
			},

			/**
			 * @function set_default
			 * @memberof Kengine.utils.structs
			 * @description Set a struct member with a default value if it's undefined, otherwise it keeps the value.
			 * @param {Struct} _struct The struct.
			 * @param {String|Struct} name The name or hash key.
			 * @param {Any} value The value.
			 * @return {Any} The new value. Or the default value.
			 *
			 */
			set_default: function(_struct, name, value) {
				if not exists(_struct, name) {
					set(_struct, name, value);
				}
				return get(_struct, name);
			},

			/**
			 * @function set
			 * @memberof Kengine.utils.structs
			 * @description Set a struct member.
			 * @param {Struct} _struct The struct.
			 * @param {String|Struct} name The name or hash key.
			 *
			 */
			set: function(_struct, name, value) {
				if !is_struct(_struct) {
					variable_instance_set(_struct, name, value);
				}
				struct_set_from_hash(_struct, Kengine.utils.hashkeys.hash(name), value);
			},

			/**
			 * @function merge
			 * @memberof Kengine.utils.structs
			 * @description	Merge struct2 to struct1 recursively.
			 * @param {Struct} struct1 The main struct.
			 * @param {Struct} struct2 The secondary struct.
			 * @param {Bool} merge_arrays Whether to merge arrays.
			 * @return {Struct} The first struct after being merged.
			 *
			*/
			merge: function(struct1, struct2, merge_arrays=false) {
				var props = struct_get_names(struct2);
				for(var i = 0; i < array_length(props); i++) {
					var val = struct2[$ props[i]];
					if (is_struct(val)) {
						if !struct_exists(struct1, props[i]) {
							struct1[$ props[i]] = val;
						} else {
							merge(struct1[$ props[i]], val, merge_arrays);
						}
					} else {
						if is_array(val) and is_array(struct1[$ props[i]]) and merge_arrays {
							struct1[$ props[i]] = array_concat(struct1[$ props[i]], val);
						} else {
							struct1[$ props[i]] = val;
						}
					}
				}
				return struct1;
			},

			/**
			 * @function dotset
			 * @memberof Kengine.utils.structs
			 * @description Set a struct member using dot notation.
			 * @param {Struct} _struct The struct.
			 * @param {String} key The dot notation of key.
			 * @param {String} val The value.
			 *
			 */
			dotset: function(_struct, key, val) {
				var keys = string_split(key, ".");
				var curr = _struct;
				var i = 0;
				for (i=0; i<array_length(keys)-1; i++) {
					if not exists(curr, keys[i]) {
						set(curr, keys[i], {});
					}
					curr = get(curr, keys[i]);
				}
				return set(curr, keys[i], val);
			},

			/**
			 * @function dotget
			 * @memberof Kengine.utils.structs
			 * @description Get a struct member using dot notation.
			 * @param {Struct} _struct The struct.
			 * @param {String} key The dot notation of key.
			 * @param {Any} [default_val=undefined] The default value to return.
			 *
			 */
			dotget: function(_struct, key, default_val=undefined) {
				var keys = string_split(key, ".");
				var curr = _struct;
				var i = 0;
				for (i=0; i<array_length(keys)-1; i++) {
					if exists(curr, keys[i]) {
						curr = get(curr, keys[i]);
					} else {
						return default_val;
					}
				}
				return get(curr, keys[i]) ?? default_val;
			},

		},

		/**
		 * @namespace ascii
		 * @memberof Kengine.utils
		 * @description A struct containing certain ASCII strings functions.
		 * 
		 */
		ascii: {
			toString: function() {return "struct"; },
			__current_braille: "",
			__current_braille_timer: 0,
			__current_spinner: "◴",
			__current_spinner_timer: 0,
			get_braille_dot: function() {
				return Kengine.utils.ascii.__current_braille;
			},
			get_spinner: function() {return Kengine.utils.ascii.__current_spinner;}
		},

		/**
		 * @namespace input
		 * @memberof Kengine.utils
		 * @description A struct containing input functions.
		 * 
		 */
		input: {
			/**
			 * @function ken_keyboard_check_released
			 * @memberof Kengine.utils.input
			 * @description Return whether key is released.
			 * @param {Struct|Real} key
			 * @return {Bool}
			 *
			 */
			keyboard_check_released: function(key) {
				if is_struct(key) {
					for (var i=0; i<array_length(key.bindings); i++) {
						if keyboard_check_released(key.bindings[i]) return true;
					}
					return false;
				} else {
					return keyboard_check_released(key);
				}
			},

			/**
			 * @function keyboard_check
			 * @memberof Kengine.utils.input
			 * @description Return whether key is being held down.
			 * @param {Struct|Real} key
			 * @return {Bool}
			 *
			 */
			keyboard_check: function(key) {
				if is_struct(key) {
					for (var i=0; i<array_length(key.bindings); i++) {
						if keyboard_check(key.bindings[i]) return true;
					}
					return false;
				} else {
					return keyboard_check(key);
				}
			},

			/**
			 * @function keyboard_check_pressed
			 * @memberof Kengine.utils.input
			 * @description Return whether key is pressed.
			 * @param {Struct|Real} key
			 * @return {Bool}
			 *
			 */
			keyboard_check_pressed: function(key) {
				if is_struct(key) {
					for (var i=0; i<array_length(key.bindings); i++) {
						if keyboard_check_pressed(key.bindings[i]) return true;
					}
					return false;
				} else {
					return keyboard_check_pressed(key);
				}
			},

			/**
			 * @function keyboard_clear
			 * @memberof Kengine.utils.input
			 * @description Clear keyboard key state.
			 * @param {Struct|Real} key
			 * @return {Bool|Undefined}
			 *
			 */
			keyboard_clear: function(key) {
				if is_struct(key) {
					for (var i=0; i<array_length(key.bindings); i++) {
						keyboard_clear(key.bindings[i]);
					}
					return true;
				} else {
					return keyboard_clear(key);
				}	
			},

		},

		/**
		 * @namespace easing
		 * @memberof Kengine.utils
		 * @description A struct containing methods for easing values.
		 *
		 */
		easing: {
			/** 
			 * @function ease_in
			 * @memberof Kengine.utils.easing
			 * @description Take a value and apply ease-in transition on, starting from `_start` and ending after `_duration` with added `_change`.
			 * @param {Real} value The value to be applied.
			 * @param {Real} start The start value.
			 * @param {Real} change The end or change of the value.
			 * @param {Real} duration The duration in steps.
			 * @see Kengine.utils.easing.ease_out
			 * @see Kengine.utils.easing.ease_inout
			 * @example
			 * // Step event
			 * _x2 = ease_in(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in.
			 * @return {Real} Converted real value to ease-in
			 * 
			 */
			ease_in: function(value, start, change, duration){
				value /= duration;
				return change*value*value + start;
			},
			
			/** 
			 * @function ease_inout
			 * @memberof Kengine.utils.easing
			 * @description Take a value and apply ease-in-out transition on, starting from `_start` and ending after `_duration` with added `_change`.
			 * @param {Real} value The value to be applied.
			 * @param {Real} start The start value.
			 * @param {Real} change The end or change of the value.
			 * @param {Real} duration The duration in steps.
			 * @see Kengine.utils.easing.ease_in
			 * @see Kengine.utils.easing.ease_out
			 * @example
			 * // Step event
			 * _x2 = ease_inout(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-in-out.
			 * @return {Real} Converted real value to ease-in-out
			 *
			 */
			ease_inout: function(value, start, change, duration){
				value /= duration/2;
				if (value < 1) return change/2*value*value+ start;
				value -= 1;
				return -change/2 * (value*(value-2) - 1) + start;
			},

			/** 
			 * @function ease_out
			 * @memberof Kengine.utils.easing
			 * @description Take a value and apply ease-out transition on, starting from `_start` and ending after `_duration` with added `_change`.
			 * @param {Real} value The value to be applied.
			 * @param {Real} start The start value.
			 * @param {Real} change The end or change of the value.
			 * @param {Real} duration The duration in steps.
			 * @see Kengine.utils.easing.ease_in
			 * @see Kengine.utils.easing.ease_inout
			 * @example
			 * // Step event
			 * _x2 = ease_out(_x1, 0, 2, 60); // _x2 is from 0 to 2 in 60 steps eased-out.
			 * @return {Real} Converted real value to ease-out
			 *
			 */
			ease_out: function(value, start, change, duration){
				value /= duration;
				return -change * value*(value-2) + start;
			},
			
		},

		/**
		 * @namespace data
		 * @memberof Kengine.utils
		 * @description A struct containing certain data functions.
		 * 
		 */
		data: {
			/**
			 * @function values_map
			 * @memberof Kengine.utils.data
			 * @param {Struct|Array<Any>} struct_or_array
			 * @param {Function} func
			 * @param {Struct|Array<Any>} [par] A parameter for recursive calls.
			 * @description Visit a struct's or array's values (that are not structs or arrays) and do a function with the values.
			 * The returned value from the func is the new value. It accepts argument `val`.
			 *
			 * Note - Disabling copy on write behavior for arrays is required.
			 *
			 */
			values_map: function(struct_or_array, func, par=undefined) {
				if is_struct(struct_or_array) {
					var n = struct_get_names(struct_or_array);
					for (var i=0; i<array_length(n); i++) {
						Kengine.utils.data.values_map(struct_or_array[$ n[i]], func, {struct: struct_or_array, ind: n[i]});
					}
				} else if is_array(struct_or_array) {
					var n = array_length(struct_or_array);
					for (var i=0; i<n; i++) {
						Kengine.utils.data.values_map(struct_or_array[i], func, {array: struct_or_array, ind: i});
					}
				} else {
					if par != undefined {
						if Kengine.utils.structs.exists(par, "array") {
							par.array[par.ind] = func(struct_or_array);
						} else {
							par.struct[$ par.ind] = func(struct_or_array);
						}
					}
				}
			},

			/**
			 * @function to_boolean
			 * @memberof Kengine.utils.data
			 * @description	Convert a value to a boolean. such as "ON", 1, 0, or "false"
			 * @param {Any} value The value to be converted.
			 * @return {Bool} Boolean equivalent of the value.
			 *
			 */
			to_boolean: function(value) {
				if typeof(value) == ty_real {
					if value > 0 {
						return true;
					}
					return false;
				} else if typeof(value) == "string" {
					var _str;
					_str = string_trim(value, ["\""]);
					_str = string_trim(_str, ["'"]);
					_str = string_lower(_str);
					switch(_str) {
						case "on": case "true": case "yes": case "1": case "1.0": return true;
						default: return false;
					}
				} else {
					return bool(value);
				}
			},

			/**
			 * @function ini_read_bool
			 * @memberof Kengine.utils.data
			 * @description	Read a key from opened INI and converts it to a boolean value.
			 * @param {String} section
			 * @param {String} key
			 * @param {Bool} default_val
			 * @return {Bool}
			 *
			 */
			ini_read_bool: function(section, key, default_val) {
				var _t = ini_read_string(section, key, "false");
				return Kengine.utils.data.to_boolean(_t);
			},

			/**
			 * @function is_booleanable
			 * @memberof Kengine.utils.data
			 * @description	Return whether a value can be a boolean. such as "ON", 1, or "true".
			 * @param {Any} value The value to be checked as boolean.
			 * @return {Bool} Whether it accepts to_boolean or not.
			 *
			 */
			is_booleanable: function(value) {
				if typeof(value) == "real" {
					if value == 1 or value == 0 or value == 1.0 or value == 0.0 {
						return true;
					}
					return false;
				} else if typeof(value) == "string" {
					var _str;
					_str = string_trim(value, ["\""]);
					_str = string_trim(_str, ["'"]);
					_str = string_lower(_str);
					switch(_str) {
						case "on": case "true": case "yes": case "1": case "1.0": return true;
						case "off": case "false": case "no": case "0": case "0.0": return true;
						default: return false;
					}
				}
				return false;
			},

			/**
			 * @function get_font_character_range
			 * @memberof Kengine.utils.data
			 * @description	Return array of min, max for the characters in the provided string. Useful for creating fonts.
			 * @param {String} strs A string that contains characters to be used for the range.
			 * @return {Array<Real>} [min, max]
			 *
			 */
			get_font_character_range: function(strs) {
				var s = undefined;
				var e = undefined;
				var r = [];
				var ds = ds_list_create();

				var texts;
				var struct_names = variable_struct_get_names(strs);
				for (var i=0; i<array_length(struct_names); i++) {
					var arrr = variable_struct_get(strs, struct_names[i]);
					if array_length(arrr) > 0 {
						texts[i] = string_join_ext(" ", arrr);
					} else {
						return [0, 1608];
					}
				}

				var str = string_join_ext("\n", texts);

				var uni = undefined;
				for (var i=0; i<string_length(str); i++) {
					uni = ord(string_char_at(str,i))
					if ds_list_find_index(ds, uni) == -1 {
						ds_list_add(ds, uni)
					}
				}

				var j = undefined;
				for (var i=0; i<ds_list_size(ds); i++) {
					j = ds_list_find_value(ds, i);
					if s == undefined {
						s = j;
						e = j;
					} else if j == e or j == e + 1 {
						e = j;
					} else {
						array_push(r, [s,e]);
						s = j
						e = j;
					}
				}
				if s != undefined {
					array_push(r, [s,e]);
				}

				ds_list_destroy(ds);	

				var minimum = 0;
				var maximum = 1608;
				for (var i=0; i<array_length(r); i++) {
					minimum = min(r[i][0], minimum);
					maximum = max(r[i][1], maximum);
				}
				return [min(31,minimum), maximum];
			},

			


		},

		/**
		 * @namespace events
		 * @memberof Kengine.utils
		 * @description Kengine utility functions that deal with events.
		 * 
		 */
		events: {

			/**
			 * @function define
			 * @memberof Kengine.utils.events
			 * @description Define an event.
			 * @param {String} event The event name.
			 * @param {Array<Function>} [listeners] The event listener functions
			 *
			 */
			define: function(event, listeners=[]) {
				if !Kengine.utils.structs.exists(Kengine.utils.events._all, event) {
					Kengine.utils.structs.set(Kengine.utils.events._all, event, []);
				}
			},

			/**
			 * @function add_listener
			 * @memberof Kengine.utils.events
			 * @description Add an event listener (function) or more to the events.
			 * @param {String} event The event name.
			 * @param {Function|Array<Function>} listener The event listener function(s)
			 * @return {Bool} Whether added successfuly (if the event is defined) or not.
			 *
			 */
			add_listener: function(event, listener) {
				if Kengine.utils.structs.exists(Kengine.utils.events._all, event) {
					var event_arr = Kengine.utils.structs.get(Kengine.utils.events._all, event);
					if is_array(listener) {
						for (var i=0; i<array_length(listener); i++) {
							array_push(event_arr, listener[i]);
						}
					} else {
						array_push(event_arr, listener);
					}
					return true;
				} else {
					return false
				}
			},

			/**
			 * @function remove_listener
			 * @memberof Kengine.utils.events
			 * @description Remove an event listener (function) or more from the events.
			 * @param {String} event The event name.
			 * @param {Function|Array<Function>} listener The event listener function(s)
			 * @param {Bool} [_all=true] Whether to remove all occurences of the function. Defaults to `true`.
			 * @return {Bool} Whether removed successfuly (if the event is defined) or not.
			 *
			 */
			remove_listener: function (event, listener, _all=false) {
				if Kengine.utils.structs.exists(Kengine.utils.events._all, event) {
					var event_arr = Kengine.utils.structs.get(Kengine.utils.events._all, event);
					if is_array(listener) {
						for (var i=0; i<array_length(listener); i++) {
							Kengine.utils.arrays.delete_value(event_arr, listener[i], _all);
						}
					} else {
						Kengine.utils.arrays.delete_value(event_arr, listener, _all);
					}
					return true;
				} else {
					return false
				}
			},

			/**
			 * @function fire
			 * @memberof Kengine.utils.events
			 * @description Fire an event with arguments.
			 * @param {String} event The event name.
			 * @param {Any} args The event arguments
			 * @return {Bool} Whether the event is registered.
			 *
			 */
			fire: function(event, args=undefined) {
				return true;
				var event_arr = Kengine.utils.structs.get(Kengine.utils.events._all, event);
				if event_arr == undefined return false;

				for (var i=0; i<array_length(event_arr); i++) {
					if event_arr[i] != undefined {
						event_arr[i](event, args);
					}
				}
				if (KENGINE_BENCHMARK and event != "start__before") {
					var timer = get_timer(); var diff = timer - Kengine._timings[0]; Kengine._timings[0] = timer;
					Kengine.console.verbose("Kengine: Benchmark: Event: " + event + ": " + string(diff/1000) + "ms", 2);
				}
				return true;
			},

			/**
			 * @member _all
			 * @type {Struct}
			 * @memberof Kengine.utils.events
			 * @description A struct that contains Kengine events as keys and an array of functions (listeners) to call on event fire.
			 * 
			 */
			_all: {

				/**
				 * @event start__before
				 * @type {Array<Function>}
				 * @description An event that fires before Kengine starts.
				 * 
				 */
				start__before: [],

				/**
				 * @event start__after
				 * @type {Array<Function>}
				 * @description An event that fires after Kengine starts.
				 *
				 * Functions accept one argument: `event`.
				 *
				 * `event`: The event name as string.
				 *
				 */
				start__after: [],

				/**
				 * @event extensions__before
				 * @type {Array<Function>}
				 * @description An event that fires after Kengine finds extensions.
				 * 
				 * Functions accept two arguments, the second is a struct: `event, {extension_assets}`.
				 * 
				 * `event`: The event name as string.
				 *
				 * `extension_assets`: The script assets struct that are found, keyed by their extension name.
				 *
				 */
				extensions__before: [],

				/**
				 * @event extension__start__before
				 * @type {Array<Function>}
				 * @description An event that fires before Kengine starts an extension.
				 * 
				 * Functions accept two arguments, the second is a struct: `event, {extension}`.
				 * 
				 * `event`: The event.
				 *
				 * `extension`: A struct that contains `name, asset`.
				 *
				 */
				extension__start__before: [],

				/**
				 * @event extension__start__after
				 * @type {Array<Function>}
				 * @description An event that fires after Kengine starts an extension.
				 * 
				 * Functions accept two arguments, the second is a struct: `event, {extension}`.
				 * 
				 * `event`: The event.
				 *
				 * `extension`: A struct that contains `name, asset`.
				 *
				 */
				extension__start__after: [],

				/**
				 * @event extensions__after
				 * @type {Array<Function>}
				 * @description An event that fires after Kengine starts all extensions.
				 * 
				 * Functions accept two arguments, the second is a struct: `event, {extensions}`.
				 * 
				 * `event`: The event.
				 *
				 * `extension_assets`: The same struct in {@link event:extensions__before}
				 *
				 */
				extensions__after: [],

				/**
				 * @event asset_type__init__before
				 * @type {Array<Function>}
				 * @description An event that fires before initializing Kengine's AssetType.
				 * If you have totally substituted the class, you need to reimplement this event.
				 * 
				 * Functions accept two arguments, the second is a struct: `event, {asset_type}`.
				 * 
				 * `event`: The event.
				 *
				 * `asset_type`: The {@link Kengine.AssetType} being constructed.
				 *
				 */
				asset_type__init__before: [],

				/**
				 * @event asset_type__init__after
				 * @type {Array<Function>}
				 * @description An event that fires after initializing Kengine's AssetType.
				 * If you have totally substituted the class, you need to reimplement this event.
				 * 
				 * Functions accept two arguments, the second is a struct: `event, {asset_type}`.
				 * 
				 * `event`: The event.
				 *
				 * `asset_type`: The {@link Kengine.AssetType} being constructed.
				 *
				 */
				asset_type__init__after: [],

				/**
				 * @event asset_type__index_assets__before
				 * @type {Array<Function>}
				 * @description An event that fires at the beginning of Kengine's AssetType index_assets function.
				 * If you have replaced the class's method, you need to reimplement this event.
				 *
				 * Functions accept two arguments, the second is a struct: `event, {asset_type}`.
				 *
				 * `event`: The event.
				 *
				 * `asset_type`: The {@link Kengine.AssetType} that is indexing its assets.
				 *
				 */
				asset_type__index_assets__before: [],

				/**
				 * @event asset_type__index_assets__after
				 * @type {Array<Function>}
				 * @description An event that fires at the end of Kengine's AssetType index_assets function.
				 * If you have replaced the class's method, you need to reimplement this event.
				 *
				 * Functions accept two arguments, the second is a struct: `event, {asset_type}`.
				 *
				 * `event`: The event.
				 *
				 * `asset_type`: The {@link Kengine.AssetType} that is indexing its assets.
				 *
				 */
				asset_type__index_assets__after: [],

				/**
				 * @event asset__init__before
				 * @type {Array<Function>}
				 * @description An event that fires before initializing a Kengine's Asset.
				 * If you have replaced the class, you need to reimplement this event.
				 *
				 * Functions accept two arguments, the second is a struct: `event, {asset}`.
				 *
				 * `event`: The event.
				 *
				 * `asset`: The {@link Kengine.Asset} being constructed.
				 *
				 */
				asset__init__before: [],

				/**
				 * @event asset__init__after
				 * @type {Array<Function>}
				 * @description An event that fires after initializing a Kengine's Asset.
				 * If you have replaced the class, you need to reimplement this event.
				 *
				 * Functions accept two arguments, the second is a struct: `event, {asset}`.
				 *
				 * `event`: The event.
				 *
				 * `asset`: The {@link Kengine.Asset} being constructed.
				 *
				 */
				asset__init__after: [],

				/**
				 * @event asset__index__before
				 * @type {Array<Function>}
				 * @description An event that fires at the beginning of {@link Kengine.AssetType.index_asset} of an Asset's AssetType.
				 * If you have replaced the method, you need to reimplement this event.
				 *
				 * Functions accept two arguments, the second is a struct: `event, {asset, result}`.
				 *
				 * `event`: The event.
				 *
				 * `asset`: The {@link Kengine.Asset} being indexed.
				 *
				 * `result`: The result array. First is whether it is successful, the second is its index in the assets Collection.
				 *
				 */
				asset__index__before: [],

				/**
				 * @event asset__index__after
				 * @type {Array<Function>}
				 * @description An event that fires at the end of {@link Kengine.AssetType.index_asset} of an Asset's AssetType.
				 * Only if the asset is indexed into assets Collection.
				 * If you have replaced the method, you need to reimplement this event.
				 *
				 * Functions accept two arguments, the second is a struct: `event, {asset, result}`.
				 *
				 * `event`: The event.
				 *
				 * `asset`: The {@link Kengine.Asset} indexed.
				 *
				 * `result`: The result array. First is whether it is successful, the second is its index in the assets Collection.
				 *
				 */
				asset__index__after: [],

			},
		},

		/**
		 * @namespace hashkeys
		 * @memberof Kengine.utils
		 * @description A mini library that contains hashkey functions.
		 * 
		 */
		hashkeys: {
			/**
			 * @function add
			 * @memberof Kengine.utils.hashkeys
			 * @description Add a hash to _hashkeys.
			 * @param {String} name The name.
			 * @return {Struct} The key struct which contains name and hash attrs.
			 *
			 */
			add: function(name) {
				_all[$ name] = {name: name, hash: variable_get_hash(name)};
			},

			/**
			 * @function hash
			 * @memberof Kengine.utils.hashkeys
			 * @description Convert hashkey or string or hash to just hash.
			 * @param {Struct|String|Real} name The name as a string, real or hash key.
			 * @return {Real} The hash to use.
			 *
			 */
			hash: function(name) {
				var key;
				if is_struct(name) {
					key = name.hash; // hash key
				} else if is_real(name) {
					key = name; // hash
				} else if is_string(name) {

					if !Kengine.utils.structs.exists(Kengine.utils.hashkeys._all, name) {
						Kengine.utils.hashkeys.add(name);
					}
					key = Kengine.utils.hashkeys._all[$ name].hash;
		
				}
				return key;
			},

			/**
			 * @member _all
			 * @type {Struct}
			 * @memberof Kengine.utils.hashkeys
			 * @description A struct that contains name and hash structs for structs.
			 * 
			 */
			_all: {
				alarm: {name: "alarm", hash: variable_get_hash("alarm")},
				create: {name: "create", hash: variable_get_hash("create")},
				clean_up: {name: "clean_up", hash: variable_get_hash("clean_up")},
				collision: {name: "collision", hash: variable_get_hash("collision")},
				destroy: {name: "destroy", hash: variable_get_hash("destroy")},
				draw: {name: "draw", hash: variable_get_hash("draw")},
				other_: {name: "other", hash: variable_get_hash("other")},
				user: {name: "user", hash: variable_get_hash("user")},
				step: {name: "step", hash: variable_get_hash("step")},
				// So on...
			},
		},

	};

	static _timings = [
		get_timer(), get_timer(), get_timer(),
	];

	/**
	* @member _uids
	* @type {Real}
	* @memberof Kengine
	* @description The current UID reached for the Kengine's UID generator.
	* 
	*/
	static _uids = 0;
	static new_uid = function() {return _uids++;};

	/**
	 * @constant initiated
	 * @memberof Kengine
	 * @description Whether Kengine has been initiated or not.
	 * @type {Bool}
	 * @readonly
	 * 
	 */
	// ken_init();
}

Kengine();

/**
 * @function Collection
 * @memberof Kengine
 * @constructor
 * @param {Array<Any>|Undefined} [array] The initial array to use.
 * @param {Function|Undefined} [defaultcmp] A default cmp to be used in functions such as get_ind.
 * @description A collection is a just an array with add, remove, get, and set functions.
 * When removing a value from the collection, the index of the value would be reused.
 *
 */
function __KengineCollection(array=undefined, defaultcmp=undefined) constructor {

	_all = array ?? [];
	_cmp = defaultcmp ?? Kengine.cmps.cmp_val1_val2;

	/**
	 * @function get_all
	 * @memberof Kengine.Collection
	 * @description Return all values inside the collection.
	 * @return {Array<Any>|Any|Undefined}
	 */
	get_all = function() { return _all;}

	/**
	 * @function get
	 * @memberof Kengine.Collection
	 * @description Return value searched by collection index.
	 * @param {Real} ind The index of the value in the collection.
	 * @return {Any} The value held in the collection index.
	 */
	get = function(ind) {
		return _all[ind];
	}

	/**
	 * @function get_ind
	 * @memberof Kengine.Collection
	 * @description Return index of the value in the collection.
	 * @param {Any} val The value in the collection to be searched for its collection index.
	 * @param {Function} [cmp] A `Function` that takes `val`, `val2`, where `val2` is from the collection to compare `val` with. Return `true` to match. Defaults to initial `defaulcmp`.
	 * @return {Real} The index of the value in the collection.
	 */
	get_ind = function(val, cmp=undefined) {
		cmp = cmp ?? _cmp;
		for (var i=0; i<array_length(_all); i++) {
			if _all[i] == undefined continue;
			if cmp(val, _all[i]) == true return i;
			if _all[i] == val return i;
		}
		return -1;
	}

	/**
	 * @function exists
	 * @memberof Kengine.Collection
	 * @description Return whether value is already in the collection.
	 * @param {Any} val The value in the collection to be searched for.
	 * @param {Function} [cmp] A `Function` that takes `val`, `val2`, where `val2` is from the collection to compare `val` with. Return `true` to match. Defaults to initial `defaultcmp`.
	 * @return {Bool} Whether the value exists or not.
	 */
	exists = function(val, cmp=undefined) {
		if get_ind(val, cmp) == -1 {
			return false;
		}
		return true;
	}

	/**
	 * @function add
	 * @memberof Kengine.Collection
	 * @description Add the value to the collection.
	 * @param {Any} val The value to be added to the collection.
	 * @return {Real} The collection index of the added value.
	 */
	add = function(val) {
		for (var i=0; i<array_length(_all); i++) {
			if _all[i] == undefined {_all[i] = val; return i;}
		}
		_all[array_length(_all)] = val;
		return array_length(_all) - 1;
	}

	/**
	 * @function add_once
	 * @memberof Kengine.Collection
	 * @description Add the value to the collection, only if it does not exist already.
	 * @param {Any} val The value to be added to the collection only if it does not exist already.
	 * @param {Function} [cmp] A `Function` that takes `val`, `val2`, where `val2` is from the collection to compare `val` with. Return `true` to match. Defaults to initial `defaultcmp`.
	 * @return {Real} The collection index of the value whether added or found.
	 */
	add_once = function(val, cmp=undefined) {
		var _ind = get_ind(val, cmp);
		if _ind == -1 return add(val);
		return _ind;
	}

	/**
	 * @function remove
	 * @memberof Kengine.Collection
	 * @description Remove the value from the collection.
	 * @param {Any} val The value to be removed from the collection.
	 * @param {Function} [cmp] A `Function` that takes `val`, `val2`, where `val2` is from the collection to compare `val` with. Return `true` to match. Defaults to initial `defaultcmp`.
	 * @return {Any} The removed value or undefined.
	 */
	remove = function(val, cmp=undefined) {
		var ind = get_ind(val, cmp);
		if ind != -1 {
			return remove_by_ind(ind);
		} else {
			return undefined;
		}
	}

	/**
	 * @function remove_by_ind
	 * @memberof Kengine.Collection
	 * @description Remove a looked-up value by the provided index from the collection.
	 * @param {Real} ind The index which value is to be removed.
	 */
	remove_by_ind = function(ind) {
		var _a = _all[ind];
		array_delete(_all, ind, 1);
		return _a;
	}

	/**
	 * @function length
	 * @memberof Kengine.Collection
	 * @description Return length of the values in the collection.
	 * @return {Real} The length of the values in the collection.
	 *
	 */
	length = function() {
		return array_length(_all);
	}
	 
	 /**
	  * @function filter
	  * @memberof Kengine.Collection
	  * @description Return a filtered array from the collection values.
	  * @param {Function} func A `Function` that takes `value`. Return `true` to take.
	  * @return {Array<Any>|Array<Pointer>|Array<Undefined>}
	  *
	  */
	filter = function(func) {
		var _a = [];
		for (var i=0; i<array_length(_all); i++) {
		if func(_all[i]) == true {
			_a[array_length(_a)] = _all[i];
		};
		}
		return _a;
	}
	  
	 /**
	  * @function self_filter
	  * @memberof Kengine.Collection
	  * @description Return a filtered copy of self from the collection values.
	  * @param {Function} func A `Function` that takes `value`. Return `true` to take.
	  * @param {Bool} [return_array=false]
	  * @return {Kengine.Collection}
	  *
	  */
	self_filter = function(func) {
		return new __KengineCollection(filter(func));
	}
}

Kengine.utils.structs.set(Kengine, "Collection", __KengineCollection);

/**
 * @typedef {Struct} AssetTypeOptions
 * @memberof Kengine.AssetType
 * @description AssetType options struct.
 * @property {String} name The name of the asset type (singular).
 * @property {Array<Real>} [index_range=[0,999999]]] An array of min, max for the indexing range.
 * @property {Array<String>} [exclude_prefixes=["scr_",]]] An array of prefixing strings that should be excluding when indexing.
 * @property {Constant.AssetType} [asset_kind=KENGINE_CUSTOM_ASSET_KIND] A default asset kind if it's a YYAsset (asset_room, asset_object, etc.) or {@link KENGINE_CUSTOM_ASSET_KIND} if it's custom.
 * @property {Array<String|Array<String>>} [unique_attrs=["id","name","real_name",]]] A list of attribute names that are unique by nature. So when indexing happens, it is only added once, otherwise replaced. Attributes such as `id` and `real_name` must be unique when adding assets. You can also use array of attrs inside to make them unique together.
 * @property {Struct} [var_struct] A struct of attributes to add to this asset type. If there is a function value, it is copied as a method with self as this asset type.
 */
 
/**
 * @function AssetType
 * @constructor
 * @memberof Kengine
 * @description An asset type is a group of assets, such as rooms or custom levels. It can be a custom type (`KAsset`) or default type (`YYAsset`).
 * @param {Kengine.AssetType.AssetTypeOptions} options A struct containing key-value configuration of the asset type. {@link Kengine.AssetType.AssetTypeOptions}
 *
 * @example
 * // This example defines an AssetType for the room YYAsset. Then it indexes all rooms in the game.
 * my_asset_type = new Kengine.AssetType({
 *      name: "rm",
 *      index_range: [0,999999],
 *      exclude_prefixes: ["_rm_",],
 *      asset_kind: asset_room, // This should be provided if representing a YYAsset.
 *		unique_attrs: ["id", "name", "real_name",], // Using default attrs.
 * });
 * 
 * my_asset_type.index_assets();
 * 
 */
function __KengineAssetType(options) constructor {

	var this = self;

	if struct_exists(Kengine.asset_types, options.name) {
		throw Kengine.utils.errors.create(Kengine.errors.types.asset_type__asset_type__exists, string("AssetType \"{0}\" already exists.", options.name));
	}

	/**
	 * @name options
	 * @type {Kengine.AssetType.AssetTypeOptions}
	 * @memberof Kengine.AssetType
	 * @private
	 * @description The initial `options` provided when creating the `AssetType`.
	 * 
	 */
	self.options = options;
	Kengine.utils.structs.set_default(self.options, "unique_attrs", ["id", "name", "real_name",]);

	// Kengine.utils.events.fire("asset_type__init__before", {asset_type: this,});

	/**
	 * @name name
	 * @type {String}
	 * @memberof Kengine.AssetType
	 * @description The name property of the AssetType. Can be provided in creation options. Required.
	 * 
	 */
	self.name = self.options.name;

	/**
	 * @name is_addable
	 * @type {Bool}
	 * @memberof Kengine.AssetType
	 * @description Whether assets can be added to this asset type in general. Can be provided in creation options.
	 * @defaultvalue true
	 *
	 */
	self.is_addable = Kengine.utils.structs.set_default(self.options, "is_addable", true);

	/**
	 * @name is_replaceable
	 * @type {Bool}
	 * @memberof Kengine.AssetType
	 * @description Whether assets can be added to this asset type in general. Can be provided in creation options.
	 * @defaultvalue true
	 *
	 */
	self.is_replaceable = Kengine.utils.structs.set_default(self.options, "is_replaceable", true);

	/**
	 * @name asset_kind
	 * @type {String}
	 * @memberof Kengine.AssetType
	 * @description The `asset_kind` property of the AssetType. Can be provided in creation options. Defaults to `{@link KENGINE_CUSTOM_ASSET_KIND}.
	 * @defaultvalue KENGINE_CUSTOM_ASSET_KIND
	 * 
	 */
	self.asset_kind = Kengine.utils.structs.set_default(self.options, "asset_kind", KENGINE_CUSTOM_ASSET_KIND);

	/**
	 * @name rename_rules
	 * @type {Undefined|Array<Struct>}
	 * @memberof Kengine.AssetType
	 * @description A set of rules to rename assets.
	 * 
	 * Each rule (struct) contains `{kind, search, replace_by}`
	 *
	 * `kind`: Search kind as a string, one of `"prefix", "suffix", "any", "one"`. Where any means anywhere in the name.
	 *
	 * `search`: A string to search in the original asset name.
	 *
	 * `replace_by`: A string to replace the match in the asset name.
	 *
	 * The asset will have a new attribute called `_original_name`.
	 */
	self.rename_rules = Kengine.utils.structs.set_default(self.options, "rename_rules", undefined);

	/**
	 * @function get_asset_replacement
	 * @memberof Kengine.AssetType
	 * @description Return an [Asset]{@link Kengine.Asset} by id or name. This function looks up the replacement chain of found asset, and iterates until it finds the final replacement of the asset and returns it.
	 * @param {String|Real} id_or_name The real ID or name of the asset.
	 * @param {String} [return_type="asset"] What to return. "asset" (the asset itself), "id" (the asset id), or "index" (the index of the asset in the {@link Kengine.Collection}). Defaults to "asset"
	 * @param {Real} [replacement_depth=0] If the asset is marked as replaced, take the replacement.. and repeat that for replacement_depth` times. Use `0` to get last in the chain. Use `-1` to get the first in chain. Use `false` to not lookup replacements.
	 * @return {Any} The wanted return type. Could be asset, its id or its index in the collection. `undefined` if not found.
	 * @example
	 * my_asset1 = my_asset_type.get_asset_replacement("spr_character01", "index"); // Return the correct index of the asset in the asset collection.
	 *
	 * // Assuming `Mods` changed spr_character02 sprite:
	 * my_asset2 = my_asset_type.get_asset_replacement("spr_character02", "index"); // Return the correct index of the asset (the newest one, if more than one, and with the latest YYAsset real ID) in the asset collection.
	 *
	 */
	self.get_asset_replacement = function(id_or_name, return_type="asset", replacement_depth=0) {
		var _types, _a_by_types, _asset_aind;
		_a_by_types = Kengine.utils.structs.get(Kengine.asset_types, self.name).assets.get_all();
		_asset_aind = array_find_index(_a_by_types, method({id_or_name}, Kengine.cmps._cmp_id_or_name));

		if _asset_aind == -1 return undefined;
		
		var _a = _a_by_types[_asset_aind];

		if not is_bool(replacement_depth) and replacement_depth != undefined {
			// look-up chain, get latest replacement.
			var _a_chain = _a.get_replacements(-1);
			_a = _a_chain[max(0, min(array_length(_a_chain)-1, replacement_depth == 0 ? 100000 : replacement_depth))];	
		}

		if return_type == "asset" {
			return _a;
		} else if return_type == "id" {
			return _a.id;
		} else if return_type == "uid" {
			return _a.uid;
		} else if return_type == "index" {
			return _a.index;
		}

	};

	/**
	 * @name index_asset_filter
	 * @type {Function}
	 * @memberof Kengine.AssetType
	 * @description A function that returns `true` if the provided asset should be indexed, `false` otherwise.
	 * @param {Kengine.Asset} asset The asset to check before indexing.
	 * @param {Kengine.AssetType} The main AssetType.
	 * 
	 */
	self.index_asset_filter = Kengine.utils.structs.set_default(self.options, "index_asset_filter", undefined);

	/**
	 * @function index_assets
	 * @memberof Kengine.AssetType
	 * @description The asset indexing functions (index_assets, index_asset) prepare and adds all the assets of this type, or only prepares and adds the provided {@link Kengine.Asset} to the {@link kengine.Collection}, returning whether operation was successful.
	 * @return {Bool} Whether successful indexing occured or not.
	 * 
	 */
	self.index_assets = function() {
		var this = self;
		if self._get_name != undefined and self._exists != undefined {
			var indexed_assets = [];
			Kengine.utils.events.fire("asset_type__index_assets__before", {asset_type: this,});
			var index_range = Kengine.utils.structs.set_default(self.options, "index_range", [0,999999]);
			var exclude_prefixes = [];
			exclude_prefixes = Kengine.utils.structs.set_default(self.options, "exclude_prefixes", exclude_prefixes);
			var _n, ass, _rn, _tags;
			var c = 0;
			var j = 0;
			var _skip2 = false;
			var __assets = [];
			var _indexes_are_same = false;
			
			if is_string(self.asset_kind) {
				// If it's a custom asset (KAsset) then asset IDs are from 0 to 9999+ or per index ranges.
				_indexes_are_same = true;
			} else {
				// Or if it's a real asset (YYAsset) then just use the real IDs.
				__assets = asset_get_ids(self.asset_kind);
				index_range[0] = 0;
				index_range[1] = array_length(__assets);
			}

			for (var i=index_range[0]; i<index_range[1]; i++) {
				_n = undefined;
				if _indexes_are_same {
					if self._exists(i) {
						_n = self._get_name(i);
					}
				} else {
					if self._exists(__assets[i]) {
						_n = self._get_name(__assets[i]);
					}
				}
				if _n == "<undefined>" or _n == "<unknown>" or _n == "undefined" or _n == undefined or _n == pointer_null {
					if self.asset_kind == asset_script or self.asset_kind == asset_object {
						continue;
					} else {
						break;
					}
				}
				_skip2 = false;
				for (j=0; j<array_length(exclude_prefixes); j++) {
					if _n == exclude_prefixes[j] {
						_skip2 = true;
						break;
					}							
					if string_starts_with(_n, exclude_prefixes[j]) {
						_skip2 = true;
						break;
					}
				}
				if _skip2 == true {
					continue;
				}
				_rn = _n;
				ass = new Kengine.Asset(self, _n, true, _indexes_are_same ? i : __assets[i]); // Indexing a YYAsset.
				self.index_asset(ass);
				array_push(indexed_assets, ass);
				c ++;
			}
			Kengine.utils.events.fire("asset_type__index_assets__after", {asset_type: self, indexed_assets});
			return true;
		}
		return false;
	};

	/**
	 * @function index_asset
	 * @memberof Kengine.AssetType
	 * @description The asset indexing functions (index_assets, index_asset) prepare and adds all the assets of this type, or only prepares and adds the provided {@link Kengine.Asset} to the {@link kengine.Collection}, returning whether operation was successful.
	 * @param {Kengine.Asset} asset The asset to index.
	 * @return {Array<Any>} A two-value array containing whether the asset was added or not, and the index of the asset or -1.
	 * 
	 */
	self.index_asset = function(asset) {
		var unique_attrs = self.options.unique_attrs;
		var result = [];
		if asset != undefined {
			Kengine.utils.events.fire("asset__index__before", {asset, result});
			if asset.is_indexed {
				if array_length(result) == 0 {
					result = [false, asset.index];
				}
				return result;
			}
			var _tags;
			if not struct_exists(asset, "tags") {
				if asset.is_yyp {
					// Feather disable GM1044
					_tags = asset_get_tags(asset.id, self.asset_kind);
					_tags[array_length(_tags)] = "YYAsset";
				} else {
					_tags = [KENGINE_CUSTOM_ASSET_KIND];
				}
				asset.tags = new __KengineCollection(_tags);
				asset.tags._all = array_unique(asset.tags._all);
			}
			var ind, accepted;
			var _cmp
			if is_array(unique_attrs) {
				_cmp = method({unique_attrs}, Kengine.cmps.cmp_unique_attrs);
				var _ind = self.assets.get_ind(asset, _cmp);

				if _ind != -1 {
					result = [false, _ind];
					return result;
				}
				accepted = true;
				if (self.index_asset_filter != undefined) {
					accepted = self.index_asset_filter(asset, self);
				}
				if (accepted) {
					ind = self.assets.add_once(asset, _cmp);
				}
			} else {
				accepted = true;
				if (self.index_asset_filter != undefined) {
					accepted = self.index_asset_filter(asset, self);
				}
				if (accepted) {
					ind = self.assets.add_once(asset, Kengine.cmps.cmp_unique_id_name);
				}
			}

			if asset.real_name == "" {
				asset.real_name = self._get_name(asset.id);
			}

			if self.rename_rules != undefined {
				var rule;
				for (var i=0; i<array_length(self.rename_rules); i++) {
					rule = self.rename_rules[i];
					switch (rule.kind) {
						case "prefix":
							if string_starts_with(asset.name, rule.search) {
								asset._original_name = asset.name;
								asset.name = string_replace(asset.name, rule.search, rule.replace_by);
							}
							break;
						case "suffix":
							if string_ends_with(asset.name, rule.search) {
								asset._original_name = asset.name;
								var l0 = string_length(asset.name);
								var l1 = string_length(rule.search);
								asset.name = string_delete(asset.name, l0-l1, l1) + rule.replace_by;
							}
							break;
						case "one":
							asset._original_name = asset.name;
							asset.name = string_replace(asset.name, rule.search, rule.replace_by);
							break;
						case "any":
						case "anywhere":
							asset._original_name = asset.name;
							asset.name = string_replace_all(asset.name, rule.search, rule.replace_by);
							break;
					}
				}

				if asset.name != asset._original_name {
					asset.is_renamed = true;
					if Kengine.utils.structs.exists(rule, "when_successful") {
						method({this: asset, rename_rule: rule}, rule.when_successful)();
					}
				}
			}

			if asset.uid == undefined {
				asset.uid = Kengine.new_uid();
			}
			if not accepted {
				result = [false, -1];
			} else {
				result = [true, ind];
			}
		}

		Kengine.utils.events.fire("asset__index__after", {asset, result});
		return result;
	};

	switch (self.asset_kind) {
		case asset_font:
			self._get_name = method(self, font_get_name);
			self._add = method(self, font_add);
			self._delete = method(self, font_delete);
			self._exists = method(self, font_exists);
			break;
		case asset_object:
			self._get_name = method(self, object_get_name);
			self._add = undefined;
			self._delete = undefined;
			self._exists = method(self, object_exists);
			break;
		case asset_path:
			self._get_name = method(self, path_get_name);
			self._add = method(self, path_add);
			self._delete = method(self, path_delete);
			self._exists = method(self, path_exists);
			break;
		case asset_room:
			self._get_name = method(self, room_get_name);
			self._add = method(self, room_add);
			self._delete = undefined;
			self._exists = method(self, room_exists);
			break;
		case asset_script:
			self._get_name = method(self, script_get_name);
			self._add = undefined;
			self._delete = undefined;
			self._exists = method(self, script_exists);
			break;
		case asset_sound:
			self._get_name = method(self, audio_get_name);
			self._add = undefined;
			self._delete = undefined;
			self._exists = method(self, audio_exists);
			break;
		case asset_sprite:
			self._get_name = method(self, sprite_get_name);
			self._add = method(self, sprite_add);
			self._delete = method(self, sprite_delete);
			self._exists = method(self, sprite_exists);
			break;
		case asset_timeline:
			self._get_name = method(self, timeline_get_name);
			self._add = method(self, timeline_add);
			self._delete = method(self, timeline_delete);
			self._exists = method(self, timeline_exists);
			break;
		case asset_unknown:
			self._get_name = undefined;
			self._add = undefined;
			self._delete = undefined;
			self._exists = undefined;
			break;
		default:

			/**
			 * @function _get_name
			 * @memberof Kengine.AssetType
			 * @description A function that returns the {@link Kengine.Asset} name by its real ID.
			 * @private
			 * @param {Real} _id The real ID of the {@link Kengine.Asset}.
			 * @return {String|Undefined} The name of the asset.
			 *
			 */
			self._get_name = function (_id) { 
				var ass = self.get_asset_replacement(_id, "asset", false);
				if ass != undefined {
					return ass.name;
				}
				return undefined;
			};
			/**
			 * @function exists
			 * @memberof Kengine.AssetType
			 * @description A function that returns whether {@link Kengine.Asset} with the real ID exists. Use this function instead of `sprite_exists` ...etc.
			 * @private
			 * @param {Real} id The real ID of the {@link Kengine.Asset}.
			 * @return {Bool} Whether the asset exists or not.
			 *
			 */
			self._exists = function (_id) {
				var ass = self.get_asset_replacement(_id, "id", false);
				if ass != undefined { return true;}
				return false;
			};
			

			// Note - ASSETTYPES - _add and _delete are not used, see mods.

			break;
	}

	/**
	 * @name assets
	 * @type {Kengine.Collection}
	 * @memberof Kengine.AssetType
	 * @description The AssetType's collection.
	 * 
	 * @example
	 * Kengine.asset_types[my_type.name].assets == my_type.assets // Return true
	 *
	 */
	self.assets = new __KengineCollection();

	self.toString = function() {return string("<AssetType: {0}>", self.name);}

	Kengine.asset_types[$ self.name] = self;

	// Autoindex
	// self.index_assets();

	if struct_exists(self.options, "var_struct") {
		var vss = struct_get_names(self.options.var_struct);
		var val;
		for (var i=0; i<array_length(vss); i++) {
			val = self.options.var_struct[$ vss[i]];
			if is_method(val) {
				this = self;
				self[$ vss[i]] = method({this}, val);
			} else {
				self[$ vss[i]] = val;
			}
		}
	}

	Kengine.utils.events.fire("asset_type__init__after", {asset_type: this,});
};

/**
 * @name <kscript>
 * @type {Struct}
 * @memberof Kengine.asset_type_options
 * @description An {@link Kengine.AssetType} definition that represents assets of type custom-script (script-type assets), thus can be added or replaced. Required.
 * 
 * This definition name is changeable by changing the value of {@link KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME}.
 * 
 */
Kengine.asset_type_options[$ KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME] = {
	name: KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME,
	index_range: [0,1],
	asset_kind: KENGINE_CUSTOM_ASSET_KIND,
	var_struct: {
		assets_conf_resolve: function (asset, conf, assetconf) {
			var filepath = filename_dir(assetconf.source_mod.source);
			var f = filepath + "/" + conf.path;
			if string_ends_with(f, KENGINE_CUSTOM_SCRIPT_EXTENSION) {
				// A reference to a custom script file.
				var _ev_custom_script_text = Kengine.mods.read_file(f, true);
				if _ev_custom_script_text != undefined {
					asset.src = _ev_custom_script_text;
				} else {
					throw Kengine.utils.errors.create(Kengine.utils.errors.types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", self, "path", conf.path), true);
				}
			}
		},
	},
	assets_var_struct: {
		is_compiled: false,
		compile: function() { // {this}
			var asset = this;
			asset.is_compiled = true;
			asset.pg = Kengine.utils.parser._TXR.Compiler._compile(asset.src);
			if asset.pg == undefined {
				Kengine.console.echo_error("Compile failure for script: " + string(asset.name)+ ", " + string(Kengine.utils.parser._TXR.System._error));
			}
		},
		run: function(that, dict, args) {
			return Kengine.utils.parser.interpret_asset(this, that, dict, args);
		}
	},

	do_index: true, // Basically nothing since There are no included custom scripts essentially in project.
};

/**
 * @member main_object
 * @type {Asset.GMObject}
 * @memberof Kengine
 * @description The main Kengine singleton object. Referenced by `Kengine.main_object`.
*
 */
Kengine.main_object = KENGINE_MAIN_OBJECT_RESOURCE; // obj_kengine

// If there's a customize script, execute it.
var scr = asset_get_index("ken_customize");

if script_exists(scr) {
	script_execute(scr, Kengine);
}

#endregion internal

#region init

/**
 * @function ken_init
 * @description Initializes Kengine. This should be called when rooms are ready to also be able to create a singleton object.
 * You can put `ken_init()` at the very first room creation code. Or whenever you want to start Kengine and use it.
 * @return Whether initialization was successful or not.
 *
 */
function ken_init() {
	Kengine.main_object = self;
	if Kengine.initiated == true {
		return false;
	}
	Kengine._timings[1] = get_timer();
	Kengine.utils.start();
	Kengine.initiated = true;

	// Console is a Panel.
	if KENGINE_CONSOLE_ENABLED {
		var console = new Kengine.panels.Console({
			log_file: KENGINE_CONSOLE_LOG_FILE,
			alpha: 0.8,
		});

		// inputbox is a PanelItem.
		var inputbox = new Kengine.panels.PanelItemInputBox({
			x: 0, y: console.height, width: console.width, height: 25,
			readonly: false, active: true, visible: true, value: "",
			valign: fa_top, autoc_enabled: true, history_enabled: true,
			background: console.box_colors[0], alpha: console.alpha,
		})

		console.add(inputbox);
		console.inputbox = inputbox;

		//console.visible = true;
		//console.collapsed = false;
		var _console_backlog = Kengine._console_backlog;

		for (var i=0; i<array_length(_console_backlog); i++) {
			switch (_console_backlog[i].kind) {
				case "echo_error":
					console.echo_error(_console_backlog[i].msg);
					break;
				case "echo_ext":
					console.echo_ext(_console_backlog[i].msg, _console_backlog[i].color, _console_backlog[i].notify, _console_backlog[i].write);
					break;
				case "echo":
					console.echo(_console_backlog[i].msg);
					break;
				case "debug":
					console.debug(_console_backlog[i].msg);
					break;
			}
		}
		Kengine._console_backlog = undefined;
		Kengine.console = console;
	}
	return true;
}

#endregion Kengine init

#region classes

/**
 * @typedef {Struct} AssetTypeOptions
 * @memberof Kengine.AssetType
 * @description AssetType options struct.
 * @property {String} name The name of the asset type (singular).
 * @property {String} [name_plural] The plural form of the name of the asset type. Defaults to singular form.
 * @property {Array<Real>} [index_range=[0,999999]]] An array of min, max for the indexing range.
 * @property {Array<String>} [exclude_prefixes=["scr_",]]] An array of prefixing strings that should be excluding when indexing.
 * @property {Constant.AssetType} [asset_kind=KENGINE_CUSTOM_ASSET_KIND] A default asset kind if it's a YYAsset (asset_room, asset_object, etc.) or {@link KENGINE_CUSTOM_ASSET_KIND} if it's custom.
 * @property {Array<String|Array<String>>} [unique_attrs=["id","name","real_name",]]] A list of attribute names that are unique by nature. So when indexing happens, it is only added once, otherwise replaced. Attributes such as `id` and `real_name` must be unique when adding assets. You can also use array of attrs inside to make them unique together.
 * @property {Struct} [var_struct] A struct of attributes to add to this asset type. If there is a function value, it is copied as a method with self as this asset type.
 */

/**
 * @function Asset
 * @new_name Kengine.Asset
 * @constructor
 * @memberof Kengine
 * @description An asset that represents sprites, objects, rooms, and can be any other customly defined assets.
 * @param {String|Kengine.AssetType} asset_type The AssetType or its name that this Asset belongs to.
 * @param {String} name The name of this Asset. This name should be the same as the name of the `YYAsset` if it represents one.
 * @param {Bool} [is_yyp] Whether this asset is a representation of a real YYAsset. Defaults to `false`.
 * @param {Real} [_id] The real ID of this Asset. This id should be the same as the index of the `YYAsset` if it represents one. Otherwise it is automatically assigned.
 * @param {String} [real_name] The real name of this Asset. This name should be the same as the name of the `YYAsset` if it represents one. Otherwise you can assign any name.
 * @param {Bool} [do_index] Whether to index the asset or not. Defaults to `true`.
 * @example
 * // This example creates a new room asset, that is indexed automatically, and adds "MyTag" to its tags.
 *
 * my_asset = new Kengine.Asset(my_asset_type, "rm_init", rm_init);
 * my_asset.tags.add_once("MyTag");
 *
 */
function __KengineAsset(asset_type, name, is_yyp=undefined, _id=undefined, real_name=undefined, do_index=undefined) constructor {
	var this = self;

	is_yyp = is_yyp ?? false;
	_id = _id ?? -1;
	real_name = real_name ?? "";
	do_index = do_index ?? true;

	/**
	 * @name replaced_by
	 * @type {Kengine.Asset}
	 * @memberof Kengine.Asset
	 * @description `replaced_by` references an Asset that replaces this Asset, if it is done by `Mods`.
	 *
	 */
	self.replaced_by = undefined;

	/**
	 * @name replaces
	 * @type {Kengine.Asset}
	 * @memberof Kengine.Asset
	 * @description `replaces` references an the Asset that this Asset replaces, if it is done by `Mods`.
	 *
	 */
	self.replaces = undefined;

	/**
	 * @name is_indexed
	 * @type {Bool}
	 * @memberof Kengine.Asset
	 * @description Whether the asset has been indexed or not.
	 * It should be automatically indexed upon its creation.
	 *
	 */
	self.is_indexed = false;
	/**
	 * @name index
	 * @type {Real}
	 * @memberof Kengine.Asset
	 * @description The index of the asset in the asset type collection.
	 *
	 */
	self.index = undefined;
	self.uid = undefined;

	if typeof(asset_type) == "string" {
		if not Kengine.utils.structs.exists(Kengine.asset_types, asset_type) {
			throw Kengine.utils.errors.create(Kengine.utils.errors.types.asset__asset_type__does_not_exist, string("Cannot create asset \"{0}\". AssetType with the name \"{1}\" does not exist.", name, asset_type));
		}
		asset_type = Kengine.utils.structs.get(Kengine.asset_types, asset_type);
	}

	self.options = {asset_type, name, is_yyp, id: _id, real_name, do_index,};

	Kengine.utils.events.fire("asset__init__before", {asset: this,});

	/**
	 * @name type
	 * @type {Kengine.AssetType}
	 * @memberof Kengine.Asset
	 * @description The type of the asset.
	 *
	 */
	self.type = self.options.asset_type;

	/**
	 * @name name
	 * @type {String}
	 * @memberof Kengine.Asset
	 * @description The name of the asset.
	 *
	 */
	self.name = self.options.name;

	/**
	 * @name id
	 * @type {Real}
	 * @memberof Kengine.Asset
	 * @description The real ID of the asset.
	 *
	 */
	self.id = self.options.id;

	/**
	 * @name _original_name
	 * @type {String}
	 * @memberof Kengine.Asset
	 * @description The same as `name` of the asset object, This is not necessarily the real name.
	 *
	 */
	self._original_name = self.name;

	/**
	 * @name is_renamed
	 * @type {Bool}
	 * @memberof Kengine.Asset
	 * @description Whether this asset has been renamed. The original name is at {@link Kengine.Asset._original_name} attribute.
	 *
	 */
	self.is_renamed = false;

	/**
	 * @function get_replacements
	 * @memberof Kengine.Asset
	 * @param {Real} [replaced_by_max=-1]
	 * @param {Real} [replaces_max=-2]
	 * @return {Array<Kengine.Asset>}
	 */
	self.get_replacements = function(replaced_by_max=-1, replaces_max=-2) {
		var _la = [], _ra = [];
		var _a = self;
		var _l = replaces_max;
		var _r = replaced_by_max;
		var _lac;
		var _rac;

		while (_l != -2) {
			_lac = array_length(_la);
			_la[_lac] = _a;
			if _la[_lac].replaces != undefined {
				_lac++;
				_la[_lac] = _a.replaces;
				_a = _la[_lac];
				if _l == -1 {
					for (var i=0; i<_lac; i++) {
						if _a == _la[i] {
							Kengine.console.echo_error(string("Circular replacement detected within replacement chain of Asset \"{0}\".", _a.name));
							_l = -2; break;
						}
					}
					continue;
				}
				_l -= 1;
				if _l == 0 {_l = -2; break;}
			} else {
				_l = -2; break;
			}
		}
		while (_r != -2) {
			_rac = array_length(_ra);
			_ra[_rac] = _a;
			if _ra[_rac].replaced_by != undefined {
				_rac++;
				_ra[_rac] = _a.replaced_by;
				_a = _ra[_rac];
				if _r == -1 {
					for (var i=0; i<_rac; i++) {
						if _a == _ra[i] {
							Kengine.console.echo_error(string("Circular replacement detected within replacement chain of Asset \"{0}\".", _a.name));
							_r = -2; break;
						}
					}
					continue;
				}
				_r -= 1;
				if _r == 0 {_r = -2; break;}
			} else {
				_r = -2; break;
			}
		}
		
		array_pop(_la)
		return array_unique(array_concat(array_reverse(_la), _ra));
	}

	/**
	 * @name is_yyp
	 * @type {Bool}
	 * @memberof Kengine.Asset
	 * @description Whether this asset's `id` is the real ID of a `YYAsset`.
	 *
	 */
	self.is_yyp = self.options.is_yyp;

	/**
	 * @name real_name
	 * @type {String}
	 * @memberof Kengine.Asset
	 * @description The real name of the asset (For YYAssets compatibility).
	 *
	 */
	self.real_name = self.options.real_name;

	if (do_index) {
		var indexer_result = self.type.index_asset(self);
		if indexer_result != undefined {
			self.is_indexed = indexer_result[0];
			self.index = indexer_result[1];
		}
	}

	if self.options.id == -1 {
		if self.id == -1 {
			self.id = self.type.get_asset_replacement(self.name, "id", false);
		}
	} else {
		if self.is_yyp == false {
			if self.real_name == "" {
				self.real_name = self.name;
			}
		}
	}
	self.real_name = (self.real_name != "") ? self.real_name : self.name;

	self.toString = function() {return string("<Asset {0} ({1}) (id/uid: {2}/{3})>", self.name, self.type.name, self.id, self.uid);}

	/**c
	 * @function replace_by
	 * @memberof Kengine.Asset
	 * @description Replaces this asset by the provided argument. It will have {@link KENGINE_ASSET_TAG_REPLACED} in its tags and also a `replaced_by` variable. The replacing asset will have a `replaces` variable.
	 * @param {Kengine.Asset} replacer_asset
	 *
	 */
	replace_by = function(replacer_asset) {
		if self.type.is_replaceable {
			if self.tags.get_ind(KENGINE_ASSET_TAG_FIXED) != -1 {
				throw Kengine.utils.errors.create(Kengine.utils.errors.types.asset__cannot_replace, string("Cannot replace Asset \"{0}\".", self.name));
			}
			self.tags.add_once(KENGINE_ASSET_TAG_REPLACED);
			self.replaced_by = replacer_asset;
			replacer_asset.replaces = self;
		} else {
			throw Kengine.utils.errors.create(Kengine.utils.errors.types.asset__asset_type__cannot_replace, string("Cannot replace Assets of AssetType \"{0}\".", self.type.name));
		}
	}

	// Add var_struct variables for Asset.
	if struct_exists(self.type.options, "assets_var_struct") {
		var vss = struct_get_names(self.type.options.assets_var_struct);
		var val;
		for (var i=0; i<array_length(vss); i++) {
			val = self.type.options.assets_var_struct[$ vss[i]];
			if is_method(val) {
				this = self;
				self[$ vss[i]] = method({this}, val);
			} else {
				self[$ vss[i]] = val;
			}
		}
	}

	Kengine.utils.events.fire("asset__init__after", {asset: this,});
}

Kengine.utils.structs.set(Kengine, "Asset", __KengineAsset);


// ********************* KENGINE CUSTOM CLASSES ********************* 
/**
 * @typedef {Struct} InstanceOptions
 * @memberof Kengine.Instance
 * @description Instance options struct.
 * @property {String} [object_index] The object index to use Defaults to `{@link KENGINE_WRAPPED_OBJECT}`.
 * @property {Real} [x=0] The X position.
 * @property {Real} [y=0] The Y position.
 * @property {String} [layer] The layer name. Defaults to `{@link KENGINE_DEFAULT_INSTANCES_LAYER_NAME}`.
 * @property {Id.Instance} [instance] The instance to wrap. Defaults to none for creating a new wrapper and instance.
 * @property {Struct} [var_struct] The initial instance variables to provide the real instance with.
 */

/**
 * @function Instance
 * @new_name Kengine.Instance
 * @constructor
 * @param {Kengine.Instance.InstanceOptions} options A struct of options to instantiate this instance with.
 * @memberof Kengine
 * @description An Instance is basically a wrapper around an object or asset with the `AssetType` "object".
 * By default this `Instance` wrapper is used in front of the underlying instance from a YYAsset object.
 * To make objects addable, this wrapper is required to create an `Instance` wrapper that wraps an object called `obj_ken_object` which in turn is just a placeholder.
 * You can also create an `Instance` to wrap any object you create in the IDE.
 *
 * The wrapped instance will get attributes such as `is_wrapped` and `wrapper`.
 * Note - It is recommended to use  {@link Kengine.utils.instance_create}  function whenever possible.
 * 
 * @example
 *
 * // This creates an Instance, from the first Asset of the AssetType object which is obj_ken_object, at 5,5 in the "Instances" layer.
 * my_object1 = new Kengine.Instance({x: 5, y: 5, layer: "Instances", object_index: "obj_default_object"});
 * // This is another way to do that.
 * my_object2 = new Kengine.Instance({asset: "obj_ken_object", x: 5, y: 5, layer: "Instances"});
 * 
 * // This creates an Instance wrapping an existing instance, or creates it if it's not there, of 10005 at 5,5 in the "Instances" layer.
 * my_object = new Kengine.Instance({asset: "anything-goes", instance: 10005, x: 5, y: 5, layer: "Instances"});
 *
 */
function __KengineInstance(options) constructor {
	var this = self;
	var _default_asset = Kengine._default_object_asset;
	var _default_layer =  KENGINE_DEFAULT_INSTANCES_LAYER_NAME;
	var _default_object = KENGINE_WRAPPED_OBJECT;

	var _x, _y, _layer, _asset, _var_struct, _i;
	var _oi = _default_object;
	var _create = false;

	/**
	 * @name instance
	 * @type {Id.Instance}
	 * @memberof Kengine.Instance
	 * @description The instance this wrapper is wrapping. `noone`, `obj_ken_object`, or a YYAsset object.
	 *
	 */
	self.instance = noone;

	_oi = Kengine.utils.structs.get(options, "object_index") ?? _default_object;

	if struct_exists(options, "instance") {
		_i = options.instance;
		if instance_exists(_i) {
			self.instance = _i;
		} else {
			_create = true;
		}
	}
	else {
		_create = true;
	}

	_asset = Kengine.utils.structs.get(options, "asset") ?? _default_asset;
	if typeof(_asset) == "string" {
		_asset =  Kengine.asset_types.object.assets.get_ind(_asset, Kengine.cmps.cmp_val1_val2_name);
		if _asset != -1 {
			_asset = Kengine.asset_types.object.assets.get(_asset);
		} else {
			throw Kengine.utils.errors.create(Kengine.utils.errors.types.instance__asset__does_not_exist, string("Cannot create instance with non-existent Asset \"{0}\".", _asset));
		}
	}

	/**
	 * @name asset
	 * @type {Any}
	 * @memberof Kengine.Instance
	 * @description The asset provided to create this wrapper. Similar to `object_index`. Defaults to the object-type {@link Kengine.Asset} that represents `obj_ken_object`.
	 *
	 */
	self.asset = _asset;

	/**
	 * @name is_wrapper
	 * @type {Bool}
	 * @memberof Kengine.Instance
	 * @description Whether this is a wrapper or not, by default it is `true`.
	 * @defaultvalue true
	 *
	 */
	self.is_wrapper = true;


	self.id =  Kengine.instances.add(self);

	/**
	 * @function destroy
	 * @memberof Kengine.Instance
	 * @description Destroy the real instance and remove this from the [instances]{@link Kengine.instances} collection.
	 *
	 */
	self.destroy = method(this, function() {
		if is_wrapper and instance_exists(self.instance) {
			instance_destroy(self.instance);
			self.instance = noone;
			Kengine.instances.remove(self, Kengine.cmps.cmp_val1_id_val2_id);
		}
	})

	if _create {
		_x = options.x ?? 0;
		_y = options.y ?? 0;
		_layer = Kengine.utils.structs.get(options, "layer") ??  _default_layer;
		_var_struct = Kengine.utils.structs.get(options, "var_struct") ?? {};
		_var_struct.wrapper = self;
		_var_struct.is_wrapped = true;
		var _ivar_struct = Kengine.utils.structs.get(self.asset, "instance_var_struct");
		if _ivar_struct != undefined {
			// Add instance_var_struct variables from Asset to the Instance's instance.
			var vss = struct_get_names(_ivar_struct);
			var val;
			for (var i=0; i<array_length(vss); i++) {
				val = _ivar_struct[$ vss[i]];
				if is_method(val) {
					_var_struct[$ vss[i]] = method({this}, val);
				} else {
					_var_struct[$ vss[i]] = val;
				}
			}
		}
		// Take any properties and set it to the created yy instance.
		var _spr = Kengine.utils.structs.get(self.asset, "sprite");
		if _spr != undefined {
			if typeof(_spr) == "ref" {
				_var_struct.sprite_index = _spr;
			} else {
				_var_struct.sprite_index = _spr.id;
			}
		}
		self.instance = instance_create_layer(_x, _y, _layer, _oi, _var_struct);
		with self.instance {
			__kengine_do_ev(Kengine.utils.hashkeys._all.create, 0);
		}
	}

	self.toString = function() {return string("<KInstance {0} ({1})>", string(self.asset), (self.instance != noone ? self.instance.id : undefined));}
}

Kengine.utils.structs.set(Kengine, "Instance", __KengineAsset);

#endregion classes

#region functions

/**
 * @function instance_exist
 * @memberof Kengine.utils
 * @todo Needs documentation
 * @param {Kengine.Asset} asset
 * @return {Bool}
 * 
 */
Kengine.utils.instance_exist = function(asset) {
	return Kengine.instances.exists(asset.name, function(val1, val2) {return val1 == val2.asset.name});
}

/**
 * @function is_ancestor
 * @memberof Kengine.utils
 * @description Checks whether object-type Asset is ancestor of another object-type Asset.
 * @param {Kengine.Asset} obj The object
 * @param {Kengine.Asset} parent The parent
 * @return {Bool}
 */
Kengine.utils.is_ancestor = function(obj, parent) {
	while true {
		if struct_exists(obj, "parent") {
			if obj.parent == undefined {
				break;
			}
			if obj.parent == parent {
				return true;
			}
			obj = obj.parent;
		} else {
			break;
		}
	}
	return false;
}

/**
 * @function instance_create
 * @memberof Kengine.utils
 * @description Create an `Instance` and adds it to the [instances]{@link Kengine.instances} collection. Creating a real instance.
 * @param {Kengine.Asset|String|Real} obj The {@link Kengine.Asset} to use, The object asset real ID, or the simply the name.
 * @param {Real} _x The X position of the instance.
 * @param {Real} _y The Y position of the instance.
 * @param {String} [_layer] The layer to create the instance at.
 * @param {Struct} [var_struct] An initial struct of variables to set for the real instance.
 * @return {Kengine.Instance} The `Instance`.
 */
Kengine.utils.instance_create = function(obj, _x, _y, _layer, var_struct) {
	var _asset = undefined;
	var obj_ind = obj;
	if typeof(obj_ind) != "struct" and typeof(obj_ind) != "string" and typeof(obj_ind) != "real" {
		obj_ind = obj_ind.object_index;
	}
	if is_instanceof(obj_ind, Kengine.Asset) {
		_asset = obj_ind;
	} else if is_string(obj_ind) {
		_asset = Kengine.asset_types.object.get_asset_replacement(obj_ind, "asset");
	} else {
		// If the ID is supplied, find it.
		var _asset_ind = Kengine.asset_types.object.assets.get_ind(obj_ind, Kengine.cmps.cmp_val1_val2_id);
		_asset = Kengine.asset_types.object.assets.get(_asset_ind);
	}

	_asset = _asset ?? Kengine._default_object_asset;

	obj_ind = _asset.id;
	if not _asset.is_yyp {
		obj_ind = Kengine._default_object_asset.id;
	}
	var_struct = var_struct ?? {};
	_layer = _layer ?? KENGINE_DEFAULT_INSTANCES_LAYER_NAME;
	var _instance = new Kengine.Instance({asset: _asset, object_index: obj_ind, x:_x, y:_y, layer:_layer, var_struct}); // Creates an instance.
	return _instance;
}

/** 
 * @function with_instances
 * @memberof Kengine.utils
 * @description A replacement for with statement. Calls the func with all instances in the expr_or_cmp. You can provide a function to filter instances from the collection.
 * @param {Any} expr_or_cmp The instances wanted. Or a filter function that returns true if you want the instance to get func called on. This can be any of the following:
 *  - Function
 *  - Id.Instance
 *  - Kengine.Instance
 *  - Kengine.Collection
 *  - Array<Kengine.Instance>
 *  - Kengine.Asset
 * @param {Function} func The function to call. Takes an argument 'inst' which is the Kengine's Instance.
 *
 */
Kengine.utils.with_instances = function(expr_or_cmp, func) {
	var insts = Kengine.instances.get_all();
	var i, j;
	var to_call_insts;
	if is_instanceof(expr_or_cmp, Kengine.Instance) {
		to_call_insts = [expr_or_cmp];
	} else if is_instanceof(expr_or_cmp, Kengine.Asset) {
		var a = Kengine.asset_types.object.assets.filter(method({expr_or_cmp}, function(ass) {
			if Kengine.utils.structs.exists(ass, "parent") {
				return Kengine.utils.is_ancestor(ass, expr_or_cmp);
			}
			return ass == expr_or_cmp;
		}));
		a = Kengine.instances.filter(method({asset: a[0]}, function(inst) {
			if Kengine.utils.structs.exists(inst.asset, "parent") {
				return Kengine.utils.is_ancestor(inst.asset, asset);
			}
			return inst.asset == asset;
		}));
		if array_length(a) > 0 {
			to_call_insts = a;
		}
	} else if typeof(expr_or_cmp) == "method" {
		to_call_insts = [];
		j = 0;
		for (i=0; i<array_length(insts); i++) {
			if expr_or_cmp(insts[i]) {
				to_call_insts[j] = insts[i];
				j++
			}
		}
	} else if typeof(expr_or_cmp) == "array" {
		to_call_insts = expr_or_cmp;
	} else {
		if expr_or_cmp == noone {
			return;
		} else if expr_or_cmp == all {
			to_call_insts = insts;
		} else if expr_or_cmp == other {
			to_call_insts = Kengine.instances.get_ind(other, Kengine.cmps.cmp_val1_id_val2_id);
			if to_call_insts == -1 {
				return;
			}
			to_call_insts = Kengine.instances.get(to_call_insts);
		} else if typeof(expr_or_cmp) == "ref" {
			if is_instanceof(expr_or_cmp, __KengineCollection) {
				to_call_insts = expr_or_cmp._all;
			} else {
				to_call_insts = Kengine.instances.get_ind(expr_or_cmp, Kengine.cmps.cmp_val1_id_val2_id);
				if to_call_insts == -1 {
					return;
				}
				to_call_insts = Kengine.instances.get(to_call_insts);
			}
		}
	}

	for (i=0; i<array_length(to_call_insts); i++) {
		var _self = self;
		func(to_call_insts[i]);
	}
}

/**
 * @function execute_script
 * @memberof Kengine.utils
 * @description A replacement for execute_script. Executes the script or method or a script-type asset.
 * @param {Function|Kengine.Asset} scr The script to execute.
 * @param {Array<Any>} [args] arguments to use in an array.
 * @return {Any} The return of the script.
 * 
 */
Kengine.utils.execute_script = function(scr, args) {
	args = args ?? [];
	if is_instanceof(scr, Kengine.Asset) {
		if struct_exists(scr, "execute") {
			scr = scr.execute ?? scr.id;
		} else if struct_exists(scr, "run") {
			return scr.run(undefined, {}, args);
		} else {
			scr = scr.id;
		}
	}
	if script_exists(scr) {
		return script_execute_ext(scr, args);		
	} else if typeof(scr) == "method" {
		return script_execute_ext(scr, args);
	}
	throw Kengine.utils.errors.create(Kengine.utils.errors.types.script_exec__script__does_not_exist, string("Cannot execute script with non-existent Asset \"{0}\".", scr));
}

#endregion functions

// ********************* KENGINE COMPLETE *********************
