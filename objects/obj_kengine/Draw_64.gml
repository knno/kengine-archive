#region Kengine.extensions
var _m;
var _exts = struct_get_names(Kengine.Extensions);
var _ext;
for (var _i=0; _i<array_length(_exts); _i++) {
	if _exts[_i] == "toString" continue
	_ext = __KengineStructUtils.Get(Kengine.Extensions, _exts[_i]);
	_m = __KengineStructUtils.Get(_ext, "DrawGui")
	if not is_method(_m) _m = __KengineStructUtils.Get(_ext, "_DrawGui")
	if not is_method(_m) _m = __KengineStructUtils.Get(_ext, "__DrawGui")
	if is_method(_m) {
		_m(_ext);
	}
}
#endregion Kengine.extensions
