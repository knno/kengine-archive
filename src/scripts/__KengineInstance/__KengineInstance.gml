/**
 * @function Instance
 * @memberof Kengine
 * @param {Id.Instance|Undefined} [object=undefined] The object to wrap.
 * @param {Kengine.Asset|String|Undefined} [asset=undefined] The object asset. You can omit this.
 * @description A Kengine.Instance is basically a wrapper for created game real instances.
 * To make objects addable, this technique is required, which is to create a `Kengine.Instance` wrapper that wraps an object called `obj_ken_object` which in turn is just a placeholder with event codes.
 * You can also create an `Instance` to wrap any object you create in game. Which makes it seamlessly easier to manage.
 *
 * The wrapped instance will get attributes such as `is_wrapped` and `wrapper`.
 * Note - It is recommended to use {@link Kengine.Utils.Instance.CreateLayer} and {@link Kengine.Utils.Instance.CreateDepth} functions whenever possible.
 *
 * @see Kengine.Utils.Instance.CreateLayer
 * @see {@link Kengine.Utils.Instance.CreateDepth}
 *
 * @example
 *
 * // This creates a `Kengine.Instance`, from the first `Asset` of the `AssetType` object which is `obj_default_object`, all while creating a room instance at 5,5 in the "Instances" layer.
 * my_object = Kengine.Instance.Create(5, 5, "Instances");
 * my_object = Kengine.Utils.Instance.CreateLayer(5, 5, "Instances")
 *
 * // This creates an Instance using depth instead of layer
 * my_object = Kengine.Utils.Instance.CreateDepth(5, 5, -100, "obj_default_object")
 *
 * // This only creates a `Kengine.Instance` wrapping an existing instance with id 10005
 * my_object = new Kengine.Instance(10005, "my-awesome-object-asset"});
 *
 */
function __KengineInstance(object=undefined, asset=undefined) : __KengineStruct() constructor {

    var this = self;

    if object == undefined and asset == undefined return;

    var _x, _y, _var_struct, _i;
    var _oi = object;
    var _create = object==undefined;

    /**
     * @name instance
     * @type {Id.Instance}
     * @memberof Kengine.Instance
     * @description The instance this wrapper is wrapping. `noone`, `obj_ken_object`, or a YYAsset object.
     *
     */
    self.instance = object;

	// Feather disable GM1044
    var _asset = asset ?? __KengineStructUtils.Get(Kengine, "__default_object_asset");

	if typeof(_asset) == "string" {
	    _asset =  Kengine.asset_types.object.assets.GetInd(_asset, __KengineCmpUtils.cmp_val1_val2_name);
	    if _asset != -1 {
	        _asset = Kengine.asset_types.object.assets.Get(_asset);
	    } else {
	        throw Kengine.Utils.Errors.Create("instance__asset__does_not_exist", string("Cannot create instance with non-existent Asset \"{0}\".", _asset));
	    }
	} else if is_instanceof(_asset, Kengine.Asset) {
		//
	} else if asset_get_type(_asset) == asset_object and object_exists(_asset) {
	    _asset =  Kengine.asset_types.object.assets.GetInd(_asset, __KengineCmpUtils.cmp_val1_val2_id);
		if _asset != -1 {
			_asset = Kengine.asset_types.object.assets.Get(_asset);
		} else {
	        throw Kengine.Utils.Errors.Create("instance__asset__does_not_exist", string("Cannot create instance with non-existent Asset \"{0}\".", _asset));
		}
	} else if is_undefined(_asset) {
		if not is_undefined(object) {
			_asset = asset;
		}
	}

    /**
     * @name asset
     * @type {Kengine.Asset}
     * @memberof Kengine.Instance
     * @description The asset provided to create this wrapper. Similar to `object_index`. Defaults to the object-type {@link Kengine.Asset} that represents `obj_ken_object`.
     *
     */
    self.asset = _asset ?? asset;

    /**
     * @function Create
     * @memberof Kengine.Instance
     * @param {Real} [x=0] The X position.
     * @param {Real} [y=0] The Y position.
     * @param {String} [layer=KENGINE_DEFAULT_INSTANCES_LAYER] The layer name. Defaults to `{@link KENGINE_DEFAULT_INSTANCES_LAYER}`.
     * @param {Kengine.Asset|Asset.GMObject|String} [asset=undefined] The Kengine asset or object index to use. Defaults to `{@link KENGINE_WRAPPED_OBJECT}`.
     * @param {Struct} [var_struct=undefined] The initial instance variables to provide the real instance with.
	 * @return {Kengine.Instance}
	 * 
     */
    static Create = function(x=undefined, y=undefined, layer=undefined, asset=undefined, var_struct=undefined) {
		var _kinstance;
		var _instance;

        x = x ?? 0;
        y = y ?? 0;

        asset = asset ?? Kengine.__default_object_asset;

        if typeof(asset) == "string" {
            asset =  Kengine.asset_types.object.assets.GetInd(asset, __KengineCmpUtils.cmp_val1_val2_name);
        } else if is_instanceof(asset, Kengine.Asset) {
			//
		} else if asset_get_type(asset) == asset_object {
            asset =  Kengine.asset_types.object.assets.GetInd(asset, __KengineCmpUtils.cmp_val1_val2_id);
        }
        if is_real(asset) {
            if asset != -1 {
                asset = Kengine.asset_types.object.assets.Get(asset);
            } else {
                throw Kengine.Utils.Errors.Create("instance__asset__does_not_exist", string("Cannot create instance with non-existent Asset \"{0}\".", asset));
            }
        } else if is_undefined(asset) {
			
		}

        var _oi = asset.id;
		if _oi == -1 _oi = Kengine.__default_object_asset.id;

        layer = layer ?? KENGINE_DEFAULT_INSTANCES_LAYER;
        var _var_struct = (var_struct != undefined) ? variable_clone(var_struct) : {};
        _var_struct.is_wrapped = true;

        var _ivar_struct = __KengineStructUtils.Get(asset, "instance_var_struct");
        if _ivar_struct != undefined {
            // Add instance_var_struct variables from Asset to the Instance's instance.
            var vss = struct_get_names(_ivar_struct);
            var val;
            for (var i=0; i<array_length(vss); i++) {
                val = _ivar_struct[$ vss[i]];
                if is_method(val) {
                    _var_struct[$ vss[i]] = method({_kinstance}, val);
                } else {
                    _var_struct[$ vss[i]] = val;
                }
            }
        }

        // Take any properties and set it to the created yy instance.
		_kinstance = new __KengineInstance(undefined, asset)
		_kinstance.asset = asset;
		_var_struct.wrapper = _kinstance;

		var _spr = __KengineStructUtils.Get(asset, "sprite");
        if _spr != undefined {
            if typeof(_spr) == "ref" {
                _var_struct.sprite_index = _spr;
            } else {
                _var_struct.sprite_index = _spr.id;
            }
        }
		
		if layer != undefined {
			_instance = instance_create_layer(x, y, layer, _oi, _var_struct);	
		} else {
			var _depth = __KengineStructUtils.Get(_var_struct, "depth");
			if _depth != undefined {
				struct_remove(_var_struct, "depth");
			} else {
				_depth = 0;
			}
			_instance = instance_create_depth(x, y, _depth, _oi, _var_struct);	
		}

		_kinstance.instance = _instance;

		with _kinstance.instance {
            __kengine_do_ev(__KengineHashkeyUtils.__all.create);
        }
        return _kinstance
    }

    /**
     * @name is_wrapper
     * @type {Bool}
     * @memberof Kengine.Instance
     * @description Whether this is a wrapper or not, by default it is `true`.
     * @defaultvalue true
     *
     */
    is_wrapper = true;

    /**
     * @function Destroy
     * @memberof Kengine.Instance
     * @description Destroy the real instance and remove this from the [instances]{@link Kengine.instances} collection.
     *
     */
    self.Destroy = method(this, function() {
        if self.is_wrapper and instance_exists(self.instance) {
            instance_destroy(self.instance);
            self.instance = noone;
            Kengine.instances.Remove(self, __KengineCmpUtils.cmp_val1_id_val2_id);
        }
    })

	if _create {
	    self.id =  Kengine.instances.Add(self);
	}

    self.toString = function() {return string("<KInstance {0} ({1})>", string(self.asset), (self.instance != noone ? self.instance.id : undefined));}


}
__KengineInstance();
