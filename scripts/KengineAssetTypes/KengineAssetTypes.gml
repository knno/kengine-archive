/**
 * @function KengineAssetTypes
 * @type {Struct}
 * @memberof Kengine
 * @description Return a struct of asset types definitions. This is used at the start of the game to configure asset types.
 *
 */
function KengineAssetTypes(){
	var asset_type_options = {
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
			indexing_options: {
				exclude_prefixes: ["__", "ken__", "anon_", "anon@", "__Kengine"], // Prefixes to exclude when indexing assets.
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
							__KengineStructUtils.SetPrivate(this, false);
						},
					},
					// Rename rule 2: Same as above, just remove ken_scr_
					{
						kind: "prefix",
						search: "ken_scr_",
						replace_by: "",
						when_successful: function() {
							__KengineStructUtils.SetPrivate(this, false);
						},
					},
				],
			},

			// Var struct is for attributes to set to the asset type.
			var_struct: {
				// Both are false, this means loading this asset type confs from mod files is disabled.
				is_addable: false, // Whether this script asset is addable in mod manager.
				is_replaceable: false, // Whether this script asset is replaceable in mod manager.
				// Whether scripts are exposed by default (asset type scope).
				default_private: false,
				// A filter function for when indexing script assets.
				index_asset_filter: function(asset) {
					// Remove script assets (even if renamed) that are added already to the index.
					// This happens because Script assets and function references are returned as 2d array by asset_get_ids.
					// What we want is the function references.
					var ind = asset.type.assets.GetInd(asset, function(val1,val2) {
						return (val1.real_name == val2.real_name) or (val1.__original_name == val2.real_name);
					})
					if (ind != -1) {
						asset.type.assets.RemoveInd(ind);
					}
					return true;
				},
				// Assets var struct is for attributes to set to the assets when created of their type.
				assets_var_struct: {
				},
			},

			auto_index: true, // Index the assets.
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
			asset_kind: asset_sprite, // This should be provided if representing a YYAsset.
			indexing_options: {
				index_range: [0,999999],
				exclude_prefixes: ["ken__", "__",],
				unique_attrs: [], // Allow anything when adding assets.
			},

			auto_index: true,
		},
		
		/**
		 * @name tileset
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type tileset in the YYP.
		 * 
		 * Set it to `undefined` to disable the tileset asset type functionality.
		 */
		tileset: {
			name: "tileset",
			asset_kind: KENGINE_CUSTOM_ASSET_KIND, // This should be provided if representing a YYAsset.
			indexing_options: {
				index_range: [0,0],
				exclude_prefixes: ["ken__", "__",],
				unique_attrs: [], // Allow anything when adding assets.
			},
			var_struct: {
				assets_conf_resolve: function (asset, conf, assetconf) {
					var vs = struct_get_names(conf);
					for (var i=0; i<array_length(vs); i++) {
						if vs[i] == "sprite" {
							conf.__sprite = conf.sprite;
							conf.sprite = Kengine.Utils.GetAsset("sprite", conf.sprite);
							if is_string(conf.sprite) or is_undefined(conf.sprite) {
								throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "sprite", conf.sprite), true);
							}
						}
					}
				},
			},

			auto_index: true,
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
			asset_kind: asset_sound, // This should be provided if representing a YYAsset.
			indexing_options: {	
				index_range: [0,9999],
				exclude_prefixes: ["__", "ken__", "txr_", "anon_",],
			},

			auto_index: true,
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
			asset_kind: asset_object, // This should be provided if representing a YYAsset.
			indexing_options: {
				index_range: [0,999999],
				exclude_prefixes: [KENGINE_MAIN_OBJECT_RESOURCE, "obj_ken_object", "__", ],
				unique_attrs: [], // Allow anything when adding assets.

			},
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
							conf.parent = Kengine.Utils.GetAsset("object", conf.parent);
							if is_string(conf.parent) or is_undefined(conf.parent) {
								throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "parent", conf.parent), true);
							}
						} else if vs[i] == "sprite" {
							conf.__sprite = conf.sprite;
							conf.sprite = Kengine.Utils.GetAsset("sprite", conf.sprite);
							if is_string(conf.sprite) or is_undefined(conf.sprite) {
								throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "sprite", conf.sprite), true);
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
										_ev_custom_script.Compile();
									} else {
										_is_error = true
									}
								} else {
									// A reference to a defined custom script.
									_ev_custom_script = Kengine.Utils.GetAsset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, conf.event_scripts[$ evs[j]]);
									if _ev_custom_script != undefined {
										if not _ev_custom_script.is_compiled {
											_ev_custom_script.Compile();
										}
									} else {
										_is_error = true;
									}
								}
								if _is_error {
									throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "event_scripts["+evs[j]+"]", conf.event_scripts[$ evs[j]]), true);
								}
								conf.event_scripts[$ evs[j]] = _ev_custom_script;
							}
						}
					}
				},
			},

			auto_index: true,
		},

		/**
		 * @name rm
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type rooms in the YYP and room-type assets. Required.
		 */
		rm: {
			name: "rm",
			asset_kind: asset_room,
			indexing_options: {
				index_range: [0,9999],
				exclude_prefixes: ["__",],
				unique_attrs: [],
			},

			var_struct: {
				is_addable: true,
				is_replaceable: false,
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
						throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" data/path property not found.", assetconf), true);
					} else {
						conf.__data = conf.data;
						conf.data = variable_clone(conf.__data);
					}

					data = __KengineStructUtils.Get(conf, "data");
					if data != undefined {
						asset.room_info = {
							width: __KengineStructUtils.Get(conf.data, "width") ?? 200,
							height: __KengineStructUtils.Get(conf.data, "height") ?? 200,
							creation_script_name: __KengineStructUtils.Get(conf.data, "creation_script_name") ?? undefined, // TODO workaround for kscript.
							physicsWorld: __KengineStructUtils.Get(conf.data, "physicsWorld") ?? false,
							physicsGravityX: __KengineStructUtils.Get(conf.data, "physicsGravityX") ?? 0,
							physicsGravityY: __KengineStructUtils.Get(conf.data, "physicsGravityY") ?? 0,
							physicsPixToMeters: __KengineStructUtils.Get(conf.data, "physicsPixToMeters") ?? 0.1,
							presistent: false, // conf.data.persistent,
							enableViews: __KengineStructUtils.Get(conf.data, "enableViews") ?? false,
							clearDisplayBuffer: __KengineStructUtils.Get(conf.data, "clearDisplayBuffer") ?? true,
							clearViewportBackground: __KengineStructUtils.Get(conf.data, "clearViewportBackground") ?? true,
							colour: __KengineStructUtils.Get(conf.data, "colour") ?? c_white,
							instances: __KengineStructUtils.Get(conf.data, "instances") ?? [],
							layers: __KengineStructUtils.Get(conf.data, "layers") ?? [],
							views: __KengineStructUtils.Get(conf.data, "views") ?? [],
						};

						// Instances.
						var r = undefined; var a, b, c;
						for (var i=0; i<array_length(asset.room_info.instances); i++) {
							a = asset.room_info.instances[i];
							if !__KengineStructUtils.Exists(a, "x") or !__KengineStructUtils.Exists(a,"y")
							or !__KengineStructUtils.Exists(a, "object_index") or !__KengineStructUtils.Exists(a, "id") {
								throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" essential properties of instance struct(s) missing.", assetconf), true);
							}

							if (is_string(__KengineStructUtils.Get(a, "object_index"))) {
								if (not __KengineStructUtils.Exists(a, "_object_name")) {
									c = a.object_index;
								} else {
									c = a._object_name;
								}
								r = Kengine.Utils.GetAsset("object", c);
								if r == undefined {
									throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" instance {1} object not found.", assetconf, string(a.id)), true);
								}
								a._object_name = r.name;
								a[$ "object_index"] = r.index;
							}
							/* Do these when creating */

							/*
							if (is_string(__KengineStructUtils.Get(a, "creation_script_name"))) {
								r = Kengine.Utils.GetAsset("script", a.creation_script_name);
								a.creation_script_name = r.name;
							}
							if (is_string(__KengineStructUtils.Get(a, "pre_creation_script_name"))) {
								r = Kengine.Utils.GetAsset("script", a.pre_creation_script_name);
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
										if (__KengineStructUtils.Exists(b[j], "sprite_index")) {
											if (not __KengineStructUtils.Exists(b[j], "_sprite_name")) {
												c = b[j].sprite_index;
											} else {
												c = b[j]._sprite_name;
											}
											r = Kengine.Utils.GetAsset("sprite", c);
											if r == undefined {
												throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} sprite not found.", assetconf, string(i)), true);
											}
											b[j]._sprite_name = r.name;
											b[j].sprite_index = r.id;
										} else {
											throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} sprite not set.", assetconf, string(i)), true);
										}
										break;
									case layerelementtype_tilemap:
										if (__KengineStructUtils.Exists(b[j], "tileset_index")) {
											if (not __KengineStructUtils.Exists(b[j], "_tileset_name")) {
												c = b[j].tileset_index;
											} else {
												c = b[j]._tileset_name;
											}
											r = Kengine.Utils.GetAsset("tileset", c);
											if r == undefined {
												throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} tileset not found.", assetconf, string(i)), true);
											}
											b[j]._tileset_name = r.name;
											b[j].tileset_index = r.id;
										} else {
											throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} tileset not set.", assetconf, string(i)), true);
										}
										break;
									
								}
							}
							
						}

						// Views.
						for (var i=0; i<array_length(asset.room_info.views); i++) {
							a = asset.room_info.views[i];
							if (is_string(__KengineStructUtils.Get(a, "object"))) { // target can be object or instance.
								if (not __KengineStructUtils.Exists(a, "_object_name")) {
									c = a.object;
								} else {
									c = a._object_name;
								}
								r = Kengine.Utils.GetAsset("object", c);
								if r == undefined {
									r = Kengine.instances.GetInd(c, __KengineCmpUtils.cmp_val1_id_val2_id);
									if r == undefined {
										throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" view camera {1} object/instance \"{1}\" not found.", assetconf, string(a.cameraID), string(c)), true);
									} else {
										r = Kengine.Utils.GetAsset("object", r.instance.id); // real ID.
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
				},

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
						if this.is_active == false {
							if Kengine.current_room_asset != undefined {
								Kengine.current_room_asset.deactivate();
							}
							this.is_active = true;
						}
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
			},

			auto_index: true,
		},

		/**
		 * @name <kscript>
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type custom-script (script-type assets), thus can be added or replaced. Required.
		 * 
		 * This definition name is changeable by changing the value of {@link KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME}.
		 * 
		 */
		KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME: {
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
							throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", self, "path", conf.path), true);
						}
					}
				},
				assets_var_struct: {
					is_compiled: false,
					Compile: function() { // {this}
						var asset = this;
						asset.pg = __KengineParserUtils.__Interpreter.Compiler._compile(asset.src);
						if asset.pg == undefined {
							Kengine.console.echo_error("Compile failure for script: " + string(asset.name)+ ", " + string(Kengine.Utils.Parser.__Interpreter.System._error));
							return
						}
						asset.is_compiled = true;
					},
					Run: function(that, dict, args) {
						return __KengineParserUtils.__InterpretAsset(this, that, dict, args);
					}
				},
			},

			auto_index: true, // Basically nothing since There are no included custom scripts essentially in project.

		},

	}


	struct_remove(asset_type_options, "rm");
	struct_remove(asset_type_options, "tileset");

	return asset_type_options
}