/**
 * @namespace Instance
 * @memberof Kengine.Utils
 * @description Kengine Instance Utils.
 * 
 */
function __KengineInstanceUtils() : __KengineStruct() constructor {

	/**
	 * @function Exists
	 * @memberof Kengine.Utils.Instance
	 * @param {Kengine.Instance|Kengine.Asset|Id.Instance|Asset.GMObject} value
	 * @return {Bool}
	 * 
	 */
	static Exists = function(value) {
		if is_instanceof(value, __KengineAsset) {
			return Kengine.instances.Exists(value.name, function(val1, val2) {return val1 == val2.asset.name});
		} else if is_instanceof(value, __KengineInstance) {
			return Kengine.instances.Exists(value.name, function(val1, val2) {return val1 == val2.asset.name});
		} else if asset_get_type(value) == asset_object {
			return instance_exists(value);
		} else {
			return instance_exists(value);
		}
	}
		
	/**
	 * @function IsAncestor
	 * @memberof Kengine.Utils.Instance
	 * @description Checks whether object-type Asset is ancestor of another object-type Asset.
	 * @param {Kengine.Asset} obj The object
	 * @param {Kengine.Asset} parent The parent
	 * @return {Bool}
	 */
	static IsAncestor = function(obj, parent) {
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
	 * @function CreateLayer
	 * @memberof Kengine.Utils.Instance
	 * @description Create a Kengine `Instance` and adds it to the [instances]{@link Kengine.instances} collection, creating a real instance in the room.
	 * @param {Real} x The X position of the instance.
	 * @param {Real} y The Y position of the instance.
	 * @param {String} [layer=undefined] The layer to create the instance at.
     * @param {Kengine.Asset|Asset.GMObject|String|Real} [asset=undefined] The {@link Kengine.Asset} or object index to use. Defaults to `{@link KENGINE_WRAPPED_OBJECT}`.
	 * @param {Struct} [var_struct] An initial struct of variables to set for the real instance.
	 * @return {Kengine.Instance} The `Instance`.
	 */
	static CreateLayer = function(x, y, layer=undefined, asset=undefined, var_struct=undefined) {
		return __KengineInstance.Create(x,y,layer,asset,var_struct);
	}

	/**
	 * @function CreateDepth
	 * @memberof Kengine.Utils.Instance
	 * @description Create a Kengine `Instance` and adds it to the [instances]{@link Kengine.instances} collection, creating a real instance in the room.
	 * @param {Real} x The X position of the instance.
	 * @param {Real} y The Y position of the instance.
	 * @param {Real} [depth=0] The depth to create the instance at.
     * @param {Kengine.Asset|Asset.GMObject|String|Real} [asset=undefined] The {@link Kengine.Asset} or object index to use. Defaults to `{@link KENGINE_WRAPPED_OBJECT}`.
	 * @param {Struct} [var_struct] An initial struct of variables to set for the real instance.
	 * @return {Kengine.Instance} The `Instance`.
	 */
	static CreateDepth = function(x, y, depth=0, asset=undefined, var_struct=undefined) {
		if is_struct(var_struct) {
			var_struct.depth = depth;
		} else {
			var_struct = {depth}
		}
		return __KengineInstance.Create(x,y,undefined,asset,var_struct);
	}

	/** 
	 * @function With
	 * @memberof Kengine.Utils.Instance
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
	static With = function(expr_or_cmp, func) {
		var _insts = Kengine.instances.GetAll();
		var _i, _j;
		var _to_call_insts;
		if is_instanceof(expr_or_cmp, __KengineInstance) {
			_to_call_insts = [expr_or_cmp];
		} else if is_instanceof(expr_or_cmp, Kengine.Asset) {
			var _a = Kengine.asset_types.object.assets.Filter(method({expr_or_cmp}, function(ass) {
				if __KengineStructUtils.Exists(ass, "parent") {
					return __KengineInstanceUtils.IsAncestor(ass, expr_or_cmp);
				}
				return ass == expr_or_cmp;
			}));
			_a = Kengine.instances.Filter(method({asset: _a[0]}, function(inst) {
				if __KengineStructUtils.Exists(inst.asset, "parent") {
					return __KengineInstanceUtils.IsAncestor(inst.asset, asset);
				}
				return inst.asset == asset;
			}));
			if array_length(_a) > 0 {
				_to_call_insts = _a;
			}
		} else if typeof(expr_or_cmp) == "method" {
			_to_call_insts = [];
			_j = 0;
			for (_i=0; _i<array_length(_insts); _i++) {
				if expr_or_cmp(_insts[_i]) {
					_to_call_insts[_j] = _insts[_i];
					_j++
				}
			}
		} else if typeof(expr_or_cmp) == "array" {
			_to_call_insts = expr_or_cmp;
		} else {
			if expr_or_cmp == noone {
				return;
			} else if expr_or_cmp == all {
				_to_call_insts = _insts;
			} else if expr_or_cmp == other {
				_to_call_insts = Kengine.instances.GetInd(other, __KengineCmpUtils.cmp_val1_id_val2_id);
				if _to_call_insts == -1 {
					return;
				}
				_to_call_insts = Kengine.instances.Get(_to_call_insts);
			} else if typeof(expr_or_cmp) == "ref" {
				if is_instanceof(expr_or_cmp, __KengineCollection) {
					_to_call_insts = expr_or_cmp._all;
				} else {
					_to_call_insts = Kengine.instances.GetInd(expr_or_cmp, __KengineCmpUtils.cmp_val1_id_val2_id);
					if _to_call_insts == -1 {
						return;
					}
					_to_call_insts = Kengine.instances.Get(_to_call_insts);
				}
			}
		}

		for (_i=0; _i<array_length(_to_call_insts); _i++) {
			var _self = self;
			func(_to_call_insts[_i]);
		}
	}

}
__KengineInstanceUtils();
