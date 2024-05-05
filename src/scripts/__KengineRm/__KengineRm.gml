/**
	* Rm:
	{
		width,
		height,
		creation_script_name,
		__creation_script_kind,
		pre_creation_script_name,
		__pre_creation_script_kind,
		physicsWorld,
		physicsGravityX,
		physicsGravityY,
		physicsPixToMeters,
		enableViews,
		clearDisplayBuffer,
		clearViewportBackground,
		colour,
		instances:
			[
				{
				    x : 96,
				    y : 32,
				    xscale : 1,
				    yscale : 1,
				    image_speed : 1,
				    creation_code : -1,
				    pre_creation_code : -1,
				    object_index : "obj_ken_test_tiling_old",
				    colour : -1,
				    angle : 0, 
				    id : "inst_ALAA",
				    image_index : 0
				},
			],
		layers:
			{
				"id": 0,
	            "name": "Instances",
	            "visible": true,
	            "depth": 0,
	            "xoffset": 0,
	            "yoffset": 0,
	            "hspeed": 0,
	            "Vspeed": 0,
	            "effectEnabled": 0,
	            "effectToBeEnabled": 0,
	            "effect": -1,
	            "shaderID": null,
	            "elements":
					[
						{
							"id": 1,
							"type": 2,
							"inst_id": "inst_ALAA"
						}
					],
			},
		views,
	}
*/

/// TODO: Docs
function __KengineRm(asset, conf) constructor {
	var this = self;

	asset.rm = this;
	this.asset = asset;

	if not is_undefined(conf.data[$ "pre_creation_script_name"]) {
		this.pre_creation_script_name = conf.pre_creation_script_name;
	} else {
		this.pre_creation_script_name = undefined;
	}

	if not is_undefined(conf.data[$ "creation_script_name"]) {
		this.creation_script_name = conf.creation_script_name;
	} else {
		this.creation_script_name = undefined;
	}

	if not is_undefined(conf.data[$ "layers"]) {
		this.layers = conf.data.layers;
	} else {
		this.layers = [];
	}

	width = Kengine.Utils.Structs.Get(conf.data, "width") ?? 200
	height = Kengine.Utils.Structs.Get(conf.data, "height") ?? 200
	physicsWorld = Kengine.Utils.Structs.Get(conf.data, "physicsWorld") ?? false
	physicsGravityX = Kengine.Utils.Structs.Get(conf.data, "physicsGravityX") ?? 0
	physicsGravityY = Kengine.Utils.Structs.Get(conf.data, "physicsGravityY") ?? 0
	physicsPixToMeters = Kengine.Utils.Structs.Get(conf.data, "physicsPixToMeters") ?? 0.1
	presistent = false // conf.data.persistent,
	enableViews = Kengine.Utils.Structs.Get(conf.data, "enableViews") ?? false
	clearDisplayBuffer = Kengine.Utils.Structs.Get(conf.data, "clearDisplayBuffer") ?? true
	clearViewportBackground = Kengine.Utils.Structs.Get(conf.data, "clearViewportBackground") ?? true
	colour = Kengine.Utils.Structs.Get(conf.data, "colour") ?? c_white
	instances = Kengine.Utils.Structs.Get(conf.data, "instances") ?? []
	layers = Kengine.Utils.Structs.Get(conf.data, "layers") ?? []
	views = Kengine.Utils.Structs.Get(conf.data, "views") ?? []

	// Instances.
	var r = undefined; var a, b, c;
	for (var i=0; i<array_length(instances); i++) {
		a = instances[i];
		if !Kengine.Utils.Structs.Exists(a, "x") or !Kengine.Utils.Structs.Exists(a,"y")
		or !Kengine.Utils.Structs.Exists(a, "object_index") or !Kengine.Utils.Structs.Exists(a, "id") {
			throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" essential properties of instance struct(s) missing.", asset.name), true);
		}

		if (is_string(Kengine.Utils.Structs.Get(a, "object_index"))) {
			if (not Kengine.Utils.Structs.Exists(a, "_object_name")) {
				c = a.object_index;
			} else {
				c = a._object_name;
			}
			r = Kengine.Utils.GetAsset("object", c);
			if r == undefined {
				throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" instance {1} object not found.", asset.name, string(a.id)), true);
			}
			a._object_name = r.name;
			a.object_index = r.index;
		}
	}

	// Layers.
	for (var i=0; i<array_length(layers); i++) {
		a = layers[i];
		b = a.elements;
		for (var j=0; j<array_length(b); j++) {
			switch (b[j].type) {
				case layerelementtype_instance:
					a.instances = a[$ "instances"] ?? {};
					a.instances[$ b[j].inst_id] = array_filter(instances, method({b, j}, function(inst) {
						return inst.id == b[j].inst_id;
					}))
					if array_length(a.instances[$ b[j].inst_id]) == 0 {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} instance {2} not found.", name, string(i), string(b[j].inst_id)), true);
					}
					a.instances[$ b[j].inst_id] = a.instances[$ b[j].inst_id][0];
					break;

				case layerelementtype_sequence:
					// Not supported yet
					break;

				case layerelementtype_background:
				case layerelementtype_sprite:
					if (Kengine.Utils.Structs.Exists(b[j], "sprite_index")) {
						if (not Kengine.Utils.Structs.Exists(b[j], "_sprite_name")) {
							c = b[j].sprite_index;
						} else {
							c = b[j]._sprite_name;
						}
						r = Kengine.Utils.GetAsset("sprite", c);
						if r == undefined {
							throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} sprite not found.", name, string(i)), true);
						}
						b[j]._sprite_name = r.name;
						b[j].sprite_index = r.id;
					} else {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} sprite not set.", name, string(i)), true);
					}
					break;
				case layerelementtype_tilemap:
					if (Kengine.Utils.Structs.Exists(b[j], "tileset_index")) {
						if (not Kengine.Utils.Structs.Exists(b[j], "_tileset_name")) {
							c = b[j].tileset_index;
						} else {
							c = b[j]._tileset_name;
						}
						r = Kengine.Utils.GetAsset("tileset", c);
						if r == undefined {
							throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} tileset not found.", name, string(i)), true);
						}
						b[j]._tileset_name = r.name;
						b[j].tileset_index = r.id;
					} else {
						throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" layer {1} tileset not set.", name, string(i)), true);
					}
					break;
			}
		}
	}

	// Views.
	for (var i=0; i<array_length(views); i++) {
		a = views[i];
		if (is_string(Kengine.Utils.Structs.Get(a, "object"))) { // target can be object or instance.
			if (not Kengine.Utils.Structs.Exists(a, "_object_name")) {
				c = a.object;
			} else {
				c = a._object_name;
			}
			r = Kengine.Utils.GetAsset("object", c);
			if r == undefined {
				r = Kengine.instances.GetInd(c, Kengine.Utils.Cmps.cmp_val1_id_val2_id);
				if r == undefined {
					throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.mods__asset_conf__no_resolve, string("Room \"{0}\" view camera {1} object/instance \"{1}\" not found.", asset.name, string(a.cameraID), string(c)), true);
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

	// Pre creation Script
	this.__pre_creation_script_kind = 0;
	if (is_string(this.pre_creation_script_name)) {
		r = Kengine.Utils.GetAsset("script", this.pre_creation_script_name);
		if r != undefined {
			this.pre_creation_script_name = r.name;
			this.__pre_creation_script_kind = 1;
		} else {
			r = Kengine.Utils.GetAsset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, this.pre_creation_script_name);
			if r != undefined {
				this.pre_creation_script_name = r.name;
				this.__pre_creation_script_kind = 2;
			} else {
				throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.asset__invalid, string("Room Asset \"{0}\" pre creation script not found.", asset.name), true);
			}
		}
	}
	
	// Creation Script
	this.__creation_script_kind = 0;
	if (is_string(this.creation_script_name)) {
		r = Kengine.Utils.GetAsset("script", this.creation_script_name);
		if r != undefined {
			this.creation_script_name = r.name;
			this.__creation_script_kind = 1;
		} else {
			r = Kengine.Utils.GetAsset(KENGINE_CUSTOM_SCRIPT_ASSETTYPE_NAME, this.creation_script_name);
			if r != undefined {
				this.creation_script_name = r.name;
				this.__creation_script_kind = 2;
			} else {
				throw Kengine.Utils.Errors.Create(Kengine.Utils.Errors.Types.asset__invalid, string("Room Asset \"{0}\" creation script not found.", asset.name), true);
			}
		}
	}

	// Create an empty room.
	asset.room = asset.type.__add();

	room_set_width(asset.room, width);
	room_set_height(asset.room, height);
	if (enableViews) {
		room_set_view_enabled(asset.room, enableViews);
		for (var _i=0; _i<array_length(views); _i++) {
			room_set_viewport(asset.room, views[_i].cameraID-1, views[_i].visible, views[_i].xview, views[_i].yview, views[_i].wview, views[_i].hview);
		}
	}

	/// TODO: Docs
	Activate = function() {
		// Iterate room_info and add stuff to the room.
		room_goto(asset.room)
		if !asset.__is_yyp {
			var a, b, c, _k, inst;
			for (var _i=0; _i<array_length(layers); _i++) {
				a = layers[_i];
				b = a.elements;
				for (var _j=0; _j<array_length(b); _j++) {
					switch (b[_j].type) {
						// Create instances.
						case layerelementtype_instance:
							_k = a.instances[$ b[_j].inst_id];
							inst = Kengine.Utils.Instance.CreateDepth(_k.x,_k.y, a.depth, _k._object_name);
							inst.image_xscale = _k[$ "xscale"] ?? 1;
							inst.image_yscale = _k[$ "yscale"] ?? 1;
							inst.image_speed = _k[$ "image_speed"] ?? 1;
							inst.image_blend = _k[$ "image_blend"] ?? c_white;
							inst.image_angle = _k[$ "image_angle"] ?? 0;
							inst.image_index = _k[$ "image_index"] ?? 0;
							break;
					}
				}
			}
		}
	}
}
