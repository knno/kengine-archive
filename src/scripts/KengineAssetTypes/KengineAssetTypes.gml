#region Internal
/**
 * @function KengineMapper
 * @constructor
 * @description A KengineMapper is used to resolve an asset_conf's confs members.
 * For example, you might want to update the "parent" to an object instead of a string.
 * @param {String} attribute The attribute to map
 * @param {Function} func The function to run for resolving. Takes two arguments: (value, asset_conf).
 */
function KengineMapper(attribute, func) constructor {
	/**
	 * @name attribute
	 * @memberof KengineMapper
	 * @type {String}
	 *
	 */
	self.attribute = attribute;

	/**
	 * @name func
	 * @memberof KengineMapper
	 * @type {Function}
	 *
	 */
	self.func = func;

	/**
	 * @function Resolve
	 * @memberof KengineMapper
	 * @param {Kengine.Extensions.Mods.AssetConf} asset_conf the asset_conf to resolve the attribute.
	 * @description An internally-called function. It sets the original value in the __opts.original_attributes of the conf struct.
	 *
	 */
	Resolve = function(asset_conf) {
		asset_conf.conf.__opts.original_attributes[$ self.attribute] = asset_conf.conf[$ self.attribute];
		asset_conf.conf[$ self.attribute] = self.func(variable_clone(asset_conf.conf[$ self.attribute]), asset_conf);
	}

	/**
	 * @function Unresolve
	 * @memberof KengineMapper
	 * @param {Kengine.Extensions.Mods.AssetConf} asset_conf the asset_conf to resolve the attribute.
	 * @description An internally-called function. It sets back the attribute to the original value from the __opts.original_attributes of the conf struct.
	 *
	 */
	Unresolve = function(asset_conf) {
		asset_conf.conf[$ self.attribute] = asset_conf.conf.__opts.original_attributes[$ self.attribute];
	}
}

#endregion

/**
 * @function KengineAssetTypes
 * @type {Struct}
 * @memberof Kengine
 * @description Returns a struct of asset types definitions. This is used at the start of the game to configure asset types.
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
					if string_count("@",asset.name) > 0 return false; // Filter out all unncessary scripts.

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
					Run: function(that, args) { // {this}
						return Kengine.Utils.Execute(that, args);
					},
				},
			},
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
			var_struct: {
				assets_var_struct: {
					GetWidth: function() { // {this}
						return sprite_get_width(this.id);
					},
					GetHeight: function() { // {this}
						return sprite_get_height(this.id);
					},
				},
			},
		},

		/**
		 * @name path
		 * @type {Struct}
		 * @memberof Kengine.asset_type_options
		 * @description An {@link Kengine.AssetType} definition that represents assets of type path in the YYP and path-type assets.
		 *
		 */
		path: {
			name: "path",
			asset_kind: asset_path, // This should be provided if representing a YYAsset.
			indexing_options: {
				index_range: [0,999999],
				exclude_prefixes: ["ken__", "__",],
				unique_attrs: [], // Allow anything when adding assets.
			},
			var_struct: {
				asset_conf_mapping: function (assetconf) {
					var asset = assetconf.asset;
					var conf = assetconf.conf;
					
					/// feather ignore GM1008
					asset.id = path_add();

					for (var _i=0; _i<array_length(conf.data); _i++) {
						path_add_point(asset.id, conf.data[_i].x, conf.data[_i].y, conf.data[_i][$ "speed"] ?? 100);
					}
					var v = false;

					if __KengineDataUtils.IsBoolable(conf[$ "closed"]) {
						v = __KengineDataUtils.ToBool(conf.closed);
					}
					path_set_closed(asset.id, v);

					if conf[$ "precision"] != undefined {
						path_set_precision(asset.id, real(conf.precision));
					}
					if conf[$ "kind"] != undefined {
						switch (string_lower(string(conf[$ "kind"]))) {
							case "0": case "straight": 
								path_set_kind(asset.id, 0) break;
							case "1": case "smooth": 
								path_set_kind(asset.id, 1) break;
						}
					}
				},
				assets_var_struct: {
					Remove: function() { // {this}
						path_delete(this.id);
					},
					GetLength: function() { // {this}
						return path_get_length(this.id);
					},
				},
			},
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

					// Tile width/height
					var _td = Kengine.Utils.Structs.Get(conf, "tile_width");
					if is_undefined(_td) {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1} not found.", assetconf, "tile_width"), true);
					}
					asset.tile_width = _td;
					_td = Kengine.Utils.Structs.Get(conf, "tile_height");
					if is_undefined(_td) {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("AssetConf \"{0}\" property {1} not found.", assetconf, "tile_height"), true);
					}
					asset.tile_height = _td;

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
							buffer_write(v, buffer_u32, _i); // Simple index of tile
						}
						asset.frames_buffer = v;
					}

					// FPS
					/// feather ignore GM1008
					var _v = Kengine.Utils.Structs.Get(conf, "fps");
					if !is_undefined(_v) {
						asset.fps = _v;
					} else {
						asset.fps = game_get_speed(gamespeed_fps);
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
			var_struct: {
				asset_conf_mapping: function (assetconf) {
					var asset = assetconf.asset;
					var conf = assetconf.conf;

					var filepath = filename_dir(assetconf.source_mod.source);
					var f = filepath + "/" + conf.path;
					if string_ends_with(f, ".wav") {
						var threed = false;
						if __KengineDataUtils.IsBoolable(conf[$ "is_3d"]) {
							threed = __KengineDataUtils.ToBool(conf.is_3d);
						}
						/// feather ignore GM1008
						asset.id = __kengine_load_sound(f, conf.name, threed);
					}

					asset.__id = undefined
				},
				assets_var_struct: {
					Remove: function() { // {this}
						audio_free_buffer_sound(this.id);
					},
					Play: function(priority, loops) { // {this}
						this.__id = audio_play_sound(this.id, priority, loops);
						return this.__id;
					},
					Stop: function() { // {this}
						return audio_stop_sound(this.__id ?? this.id);
					},
				},
			},
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
				// An asset_conf_mapping function is what maps the configuration from an assetconf to the asset being applied to.
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
				__GetRoomSlot: function() {
					static room_curr = rm_ken_01;
					room_curr = (room_curr == rm_ken_01) ? rm_ken_02 : rm_ken_01;
					return room_curr;
				},
				asset_conf_mapping: function (assetconf) {
					var asset = assetconf.asset;
					var conf = assetconf.conf;

					var vs = struct_get_names(conf);
					var path_kind = undefined;
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

					if not is_undefined(conf.data[$ "pre_creation_script_name"]) {
						asset.pre_creation_script_name = conf.data.pre_creation_script_name;
					} else {
						asset.pre_creation_script_name = undefined;
					}
					if not is_undefined(conf.data[$ "creation_script_name"]) {
						asset.creation_script_name = conf.data.creation_script_name;
					} else {
						asset.creation_script_name = undefined;
					}
					if not is_undefined(conf.data[$ "layers"]) {
						asset.layers = conf.data.layers;
					} else {
						asset.layers = [];
					}

					asset.width = Kengine.Utils.Structs.Get(conf.data, "width") ?? 200
					asset.height = Kengine.Utils.Structs.Get(conf.data, "height") ?? 200
					asset.physicsWorld = Kengine.Utils.Structs.Get(conf.data, "physicsWorld") ?? false
					asset.physicsGravityX = Kengine.Utils.Structs.Get(conf.data, "physicsGravityX") ?? 0
					asset.physicsGravityY = Kengine.Utils.Structs.Get(conf.data, "physicsGravityY") ?? 0
					asset.physicsPixToMeters = Kengine.Utils.Structs.Get(conf.data, "physicsPixToMeters") ?? 0.1
					asset.persistent = false; // Not implemented.
					asset.enableViews = Kengine.Utils.Structs.Get(conf.data, "enableViews") ?? false
					asset.clearDisplayBuffer = Kengine.Utils.Structs.Get(conf.data, "clearDisplayBuffer") ?? true
					asset.clearViewportBackground = Kengine.Utils.Structs.Get(conf.data, "clearViewportBackground") ?? true
					asset.colour = Kengine.Utils.Structs.Get(conf.data, "colour") ?? c_white
					asset.instances = Kengine.Utils.Structs.Get(conf.data, "instances") ?? []
					asset.views = Kengine.Utils.Structs.Get(conf.data, "views") ?? []

					// Instances.
					var r = undefined; var a, b, c;
					for (var i=0; i<array_length(asset.instances); i++) {
						a = asset.instances[i];
						if !Kengine.Utils.Structs.Exists(a, "x") or !Kengine.Utils.Structs.Exists(a,"y")
						or !Kengine.Utils.Structs.Exists(a, "object_index") or !Kengine.Utils.Structs.Exists(a, "id") {
							throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" essential properties of instance struct(s) missing.", asset.name), true);
						}

						if (is_string(Kengine.Utils.Structs.Get(a, "object_index"))) {
							if (not Kengine.Utils.Structs.Exists(a, "__object_name")) {
								c = a.object_index;
							} else {
								c = a.__object_name;
							}
							r = Kengine.Utils.GetAsset("object", c);
							if r == undefined {
								throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" instance {1} object not found.", asset.name, string(a.id)), true);
							}
							a.__object_name = r.name;
							/// feather ignore GM1008
							a.object_index = r.index;
						}
					}

					// Layers.
					for (var i=0; i<array_length(asset.layers); i++) {
						a = asset.layers[i];
						b = a.elements;
						for (var j=0; j<array_length(b); j++) {
							switch (b[j].type) {
								case layerelementtype_instance:
									a.instances = a[$ "instances"] ?? {};
									a.instances[$ b[j].inst_id] = array_filter(asset.instances, method({b, j}, function(inst) {
										return inst.id == b[j].inst_id;
									}))
									if array_length(a.instances[$ b[j].inst_id]) == 0 {
										throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} instance {2} not found.", asset.name, string(i), string(b[j].inst_id)), true);
									}
									a.instances[$ b[j].inst_id] = a.instances[$ b[j].inst_id][0];
									break;

								case layerelementtype_background:
								case layerelementtype_sprite:
									if (Kengine.Utils.Structs.Exists(b[j], "sprite_index")) {
										if (not Kengine.Utils.Structs.Exists(b[j], "__sprite_name")) {
											c = b[j].sprite_index;
										} else {
											c = b[j].__sprite_name;
										}
										r = Kengine.Utils.GetAsset("sprite", c);
										if r == undefined {
											throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} sprite not found.", asset.name, string(i)), true);
										}
										b[j].__sprite_name = r.name;
										b[j].sprite_index = r.id;
									} else {
										throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} sprite not set.", asset.name, string(i)), true);
									}
									break;
								case layerelementtype_tilemap:
									if (Kengine.Utils.Structs.Exists(b[j], "tileset_index")) {
										if (not Kengine.Utils.Structs.Exists(b[j], "__tileset_name")) {
											c = b[j].tileset_index;
										} else {
											c = b[j].__tileset_name;
										}
										r = Kengine.Utils.GetAsset("tileset", c);
										if r == undefined {
											throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} tileset not found.", asset.name, string(i)), true);
										}
										b[j].__tileset_name = r.name;
										b[j].tileset_index = r.id;
									} else {
										throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} tileset not set.", asset.name, string(i)), true);
									}
									break;
							}
						}
					}

					// Views.
					for (var i=0; i<array_length(asset.views); i++) {
						a = asset.views[i];
						if (is_string(Kengine.Utils.Structs.Get(a, "object"))) { // target can be object or instance.
							if (not Kengine.Utils.Structs.Exists(a, "__object_name")) {
								c = a.object;
							} else {
								c = a.__object_name;
							}
							r = Kengine.Utils.GetAsset("object", c); // Get the asset with the name or id
							if r == undefined {
								if is_real(c) {
									r = Kengine.instances.GetInd(c, Kengine.Utils.Cmps.cmp_val1_id_val2_id); // Get the instance with the same id
									if r == undefined {
										throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" view camera {1} object/instance \"{1}\" not found.", asset.name, string(a.cameraID), string(c)), true);
									} else {
										r = Kengine.Utils.GetAsset("object", r.instance.id); // real ID.
										if r != undefined {
											a.__object_name = r.name;
											a.object = r.index;
										}
									}
								}
							} else {
								a.__object_name = r.name;
								a.object = r.index;
							}
							// TODO: Override when the first instance is set in the room to make the camera_set_view_target. (controller, step?)
						}
					}

					// Pre creation Script
					asset.__pre_creation_script_kind = 0;
					if (is_string(asset.pre_creation_script_name)) {
						r = Kengine.Utils.GetAsset("script", asset.pre_creation_script_name);
						if r != undefined {
							asset.pre_creation_script_name = r.name;
							asset.__pre_creation_script = r;
							asset.__pre_creation_script_kind = 1;
						} else {
							r = Kengine.Utils.GetAsset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, asset.pre_creation_script_name);
							if r != undefined {
								asset.pre_creation_script_name = r.name;
								asset.__pre_creation_script = r;
								asset.__pre_creation_script_kind = 2;
							} else {
								throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.asset__invalid, string("Room Asset \"{0}\" pre creation script not found.", asset.name), true);
							}
						}
					}

					// Creation Script
					asset.__creation_script_kind = 0;
					if (is_string(asset.creation_script_name)) {
						r = Kengine.Utils.GetAsset("script", asset.creation_script_name);
						if r != undefined {
							asset.creation_script_name = r.name;
							asset.__creation_script = r;
							asset.__creation_script_kind = 1;
						} else {
							r = Kengine.Utils.GetAsset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, asset.creation_script_name);
							if r != undefined {
								asset.creation_script_name = r.name;
								asset.__creation_script = r;
								asset.__creation_script_kind = 2;
							} else {
								throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.asset__invalid, string("Room Asset \"{0}\" creation script not found.", asset.name), true);
							}
						}
					}
				},

				assets_var_struct: {
					rm: undefined,
					is_active: false,
					Activate: function() { // {this}
						if this.is_active == false {
							if Kengine.current_room_asset != undefined {
								Kengine.current_room_asset.Deactivate();
							}
							this.is_active = true;
							this.Goto();
						}
					},
					Deactivate: function() { // {this}
						if this.is_active == false {
							return;
						}
						this.is_active = false;
					},
					GetInfo: function() { // {this}
						var _instances = this.instances;
						var _layers = this.layers;
						var _views = this.views;

						for (var _i=0; _i<array_length(_instances); _i++) _instances[_i] = __KengineStructUtils.FilterOutPrefixed(_instances[_i]);
						for (var _i=0; _i<array_length(_layers); _i++) _layers[_i] = __KengineStructUtils.FilterOutPrefixed(_layers[_i]);
						for (var _i=0; _i<array_length(_views); _i++) _views[_i] = __KengineStructUtils.FilterOutPrefixed(_views[_i]);

						return {
							width: this.width,
							height: this.height,
							physicsWorld: this.physicsWorld,
							physicsGravityX: this.physicsGravityX,
							physicsGravityY: this.physicsGravityY,
							physicsPixToMeters: this.physicsPixToMeters,
							persistent: this.persistent,
							enableViews: this.enableViews,
							clearDisplayBuffer: this.clearDisplayBuffer,
							clearViewportBackground: this.clearViewportBackground,
							colour: this.colour,
							instances: _instances,
							layers: _layers,
							views: _views,
						}
					},
					Goto: function() { // {this}
						if this.__is_yyp {
							if room != this.id {
								if room_exists(this.id) {
									room_goto(this.id)
								}
							}
							return;
						}

						if Kengine.current_room_asset != this {
							if Kengine.current_room_asset.is_active {
								Kengine.current_room_asset.Deactivate();
							}
						}

						this._room = this.type.__GetRoomSlot();

						room_set_width(this._room, this.width);
						room_set_height(this._room, this.height);
						if (this.enableViews) {
							var views = this.views;
							room_set_view_enabled(this._room, this.enableViews);
							for (var _i=0; _i<array_length(views); _i++) {
								room_set_viewport(this._room, views[_i].cameraID-1, views[_i].visible, views[_i].xview, views[_i].yview, views[_i].wview, views[_i].hview);
							}
						}

						Kengine.current_room_asset = this;
						Kengine.current_room_asset.is_active = true;
						room_goto(this._room)

						if !this.__is_yyp {
							if this.__pre_creation_script_kind == 2 {
								this.__pre_creation_script.Run();
							} else if this.__pre_creation_script_kind == 1 {
								script_execute(this.__pre_creation_script);
							}
							if this.physicsWorld {
								physics_world_create(this.physicsPixToMeters);
								physics_world_gravity(this.physicsGravityX, this.physicsGravityY);
							}
							var a, b, c, _k, inst;
							for (var _i=0; _i<array_length(this.layers); _i++) {
								a = this.layers[_i];
								b = a.elements;
								for (var _j=0; _j<array_length(b); _j++) {
									switch (b[_j].type) {
										// Create instances.
										case layerelementtype_instance:
											_k = a.instances[$ b[_j].inst_id];
											inst = Kengine.Utils.Instance.CreateDepth(_k.x,_k.y, a.depth, _k.__object_name);
											inst.image_xscale = _k[$ "xscale"] ?? 1;
											inst.image_yscale = _k[$ "yscale"] ?? 1;
											inst.image_speed = _k[$ "image_speed"] ?? 1;
											inst.image_blend = _k[$ "image_blend"] ?? (_k[$ "colour"] != -1 ? c_white : _k[$ "colour"]);
											inst.image_angle = _k[$ "angle"] ?? 0;
											inst.image_index = _k[$ "image_index"] ?? 0;
											break;

										// Create tilemaps.
										case layerelementtype_tilemap:
											_k = __KengineUtils.GetAsset("tileset", b[_j].__tileset_name);
											var tmap_obj = __KengineTileUtils.__CreateTilemap(_k, b[_j].tiles, b[_j].x, b[_j].y, b[_j].width, b[_j].height, a.depth);
											tmap_obj.x += a[$ "xoffset"] ?? 0;
											tmap_obj.y += a[$ "yoffset"] ?? 0;
											tmap_obj.hspeed = a[$ "hspeed"] ?? 0;
											tmap_obj.vspeed = a[$ "vspeed"] ?? 0;
											tmap_obj.rm_asset = this;
											break;
									}
								}
							}
							if this.__creation_script_kind == 2 {
								this.__creation_script.Run();
							} else if this.__creation_script_kind == 1 {
								script_execute(this.__creation_script);
							}
						}
					},
				},
			},
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
					Run: function(that, dict, args) { // {this}
						return Kengine.Utils.Parser.InterpretAsset(this, that, dict, args);
					},
					Remove: function() { // {this}
						delete this.pg;
						this.is_compiled = false;
					}
				},
			},
		},
	}

	return schema;
}
