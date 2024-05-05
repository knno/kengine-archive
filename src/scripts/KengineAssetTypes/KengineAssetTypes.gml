/**
 * @function KengineMapper
 * @constructor
 * @param {String} attribute The attribute to map
 * @param {function} func The function to run
 */
function KengineMapper(attribute, func) constructor {
	self.attribute = attribute;
	self.func = func;

	Resolve = function(assetconf) {
		show_debug_message(assetconf);
		assetconf.conf.__opts.original_attributes[$ self.attribute] = assetconf.conf[$ self.attribute];
		assetconf.conf[$ self.attribute] = self.func(variable_clone(assetconf.conf[$ self.attribute]), assetconf);
	}

	Unresolve = function(assetconf) {
		assetconf.conf[$ self.attribute] = assetconf.conf.__opts.original_attributes[$ self.attribute];
	}
}

/**
 * @function KengineAssetTypes
 * @type {Struct}
 * @memberof Kengine
 * @description Return a struct of asset types definitions. This is used at the start of the game to configure asset types.
 * @return {Struct}
 *
 */
function KengineAssetTypes() {	
	static schema = {
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
				exclude_prefixes: ["ken__", "anon_", "anon@", "__Kengine"], // Prefixes to exclude when indexing assets.
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
							Kengine.Utils.Structs.SetPrivate(this, false);
						},
					},
					// Rename rule 2: Same as above, just remove ken_scr_
					{
						kind: "prefix",
						search: "ken_scr_",
						replace_by: "",
						when_successful: function() {
							Kengine.Utils.Structs.SetPrivate(this, false);
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
		 *
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
				asset_conf_mapping: function(assetconf) {
					var asset = assetconf.asset;
					var conf = assetconf.conf;

					// Sprite
					var _spr = Kengine.Utils.Structs.Get(conf, "sprite");
					if is_undefined(_spr) {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1} not found.", assetconf, "sprite"), true);
					}
					var v = Kengine.Utils.GetAsset("sprite", conf.sprite);
					if is_string(v) or is_undefined(v) {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "sprite", value), true);
					}
					asset.sprite = v;

					// Tileset
					var _tile_count = Kengine.Utils.Structs.Get(conf, "tile_count");
					if is_undefined(_tile_count) {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1} not found.", assetconf, "tile_count"), true);
					}
					asset.tile_count = _tile_count;

					// Animations
					var _frame_count = Kengine.Utils.Structs.Get(conf, "frame_count");
					_frame_count = _frame_count ?? 1;
					asset.frame_count = _frame_count;

					var _frames = Kengine.Utils.Structs.Get(conf, "frames");

					if !is_undefined(_frame_count) and !is_undefined(_frames) {
						v = buffer_create(4*_tile_count*_frame_count, buffer_fixed, 4);
						for (var _i=0; _i<array_length(_frames); _i++) {
							buffer_write(v, buffer_u32, _frames[_i]);
						}
						asset.frames_buffer = v;
					} else { 
						v = buffer_create(4*_tile_count, buffer_fixed, 4);
						for (var _i=0; _i<array_length(_tile_count); _i++) {
							buffer_write(v, buffer_u32, _i);
						}
						asset.frames_buffer = v;
					}
				},

				assets_var_struct: {
					GetTexture: function() { // {this}
						if sprite_exists(this.sprite.id) {
							return sprite_get_texture(this.sprite.id, 0);
						}
						return -1;
					},
					GetFrameIndex: function(tile_index, frame) { // {this}
						return buffer_peek(this.frames_buffer, 4*tile_index*this.frame_count + 4*frame, buffer_u32);
					},
				}
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
				exclude_prefixes: ["__", "ken__", "anon_",],
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
				// An asset_conf_mapping function is what maps the configuration from an assetconf, to the asset being applied to.
				asset_conf_mapping: [
					new KengineMapper("parent", function(value, assetconf) {
						if value == "noone" {
							return noone;
						}
						var v = Kengine.Utils.GetAsset("object", value);
						if is_string(v) or is_undefined(v) {
							throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "parent", value), true);
						}
						return v;
					}),
					new KengineMapper("sprite", function(value, assetconf) {
						var v = Kengine.Utils.GetAsset("sprite", value);
						if is_string(v) or is_undefined(v) {
							throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "sprite", value), true);
						}
						return v;
					}),
					new KengineMapper("event_scripts", function(value, assetconf) {
						var _is_error = false;
						var evs = struct_get_names(value);
						var _ev_custom_script;
						var _ev_custom_script_text;
						for (var j=0; j<array_length(evs); j++) {
							if string_starts_with(value[$ evs[j]], "@") {
								// keep as is
								continue;
							}
							var filepath = filename_dir(assetconf.source_mod.source);
							var f = filepath + "/" + value[$ evs[j]]
							if string_ends_with(f, KENGINE_CUSTOM_SCRIPT_EXTENSION) {
								// A reference to a file of a custom script.
								_ev_custom_script_text = Kengine.Extensions.Mods.ReadFileSync(f);
								if _ev_custom_script_text != undefined {
									_ev_custom_script = new Kengine.Asset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, assetconf.source_mod.name + "__" + "event_scripts" + "__ev_" + evs[j], false);
									_ev_custom_script.src = _ev_custom_script_text;
									_ev_custom_script.Compile();
								} else {
									_is_error = true
								}
							} else {
								// A reference to a defined custom script.
								_ev_custom_script = Kengine.Utils.GetAsset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, value[$ evs[j]]);
								if _ev_custom_script != undefined {
									if not _ev_custom_script.is_compiled {
										_ev_custom_script.Compile();
									}
								} else {
									_is_error = true;
								}
							}
							if _is_error {
								throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", assetconf, "event_scripts["+evs[j]+"]", value[$ evs[j]]), true);
							}
							value[$ evs[j]] = _ev_custom_script;
						}
						return value;
					}),
				],
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
				asset_conf_mapping: function (assetconf) {
					var asset = assetconf.asset;
					var conf = assetconf.conf;

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
						conf.__data = __kengine_load_room_file(filename_dir(assetconf.source_mod.source) + "/" + conf.path, path_kind);
						conf.data = variable_clone(conf.__data);

					} else if !array_contains(vs, "data") {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" data/path property not found.", assetconf), true);
					} else {
						conf.__data = conf.data;
						conf.data = variable_clone(conf.__data);
					}
					
					if is_instanceof(asset.rm, __KengineRm) {
						delete asset.rm;
					}
					asset.rm = new __KengineRm(asset, conf);

					// TODO: Change tilesets to custom Kengine tilesets?
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
					rm: undefined,
					is_active: false,
					Activate: function() { // {this}
						if this.is_active == false {
							if Kengine.current_room_asset != undefined {
								Kengine.current_room_asset.Deactivate();
							}
							this.is_active = true;
							
							if this.rm != undefined {
								this.rm.Activate();
							}
						}
					},
					Deactivate: function() { // {this}
						// TODO: iterate room_created_info and remove from the room.
						// unless it is persistent.
						// - Instances are automatically deleted.

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
			indexing_options: {
				index_range: [0,1],
				exclude_prefixes: ["__",],
				unique_attrs: [],
			},
			asset_kind: KENGINE_CUSTOM_ASSET_KIND,
			var_struct: {
				asset_conf_mapping: function (assetconf) {
					var asset = assetconf.asset;
					var conf = assetconf.conf;

					var filepath = filename_dir(assetconf.source_mod.source);
					var f = filepath + "/" + conf.path;
					if string_ends_with(f, KENGINE_CUSTOM_SCRIPT_EXTENSION) {
						// A reference to a custom script file.
						var _ev_custom_script_text = Kengine.Extensions.Mods.ReadFileSync(f);
						if _ev_custom_script_text != undefined {
							asset.src = _ev_custom_script_text;
						} else {
							throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1}=\"{2}\" not found.", self, "path", conf.path), true);
						}
					}
				},
				assets_var_struct: {
					is_compiled: false,
					Compile: function() { // {this}
						var asset = this;
						asset.pg = Kengine.Utils.Parser.interpreter.Compiler._compile(asset.src);
						if asset.pg == undefined {
							Kengine.console.echo_error("Compile failure for script: " + string(asset.name)+ ", " + string(Kengine.Utils.Parser.interpreter.System._error));
							return
						}
						asset.is_compiled = true;
					},
					Run: function(that, dict, args) {
						return Kengine.Utils.Parser.InterpretAsset(this, that, dict, args);
					}
				},
			},
			auto_index: false,
		},

	}

	return schema;
}
