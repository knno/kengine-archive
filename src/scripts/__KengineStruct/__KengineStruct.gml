/**
 * @name Struct
 * @memberof Kengine
 *
 */
function __KengineStruct(_struct=undefined, _opts=undefined) constructor {

	if _struct != undefined {
		var s = struct_get_names(_struct);
		for (var i=0; i<array_length(s); i++) {
			self[$ s[i]] = _struct[$ s[i]]
		}
	}

	var _default_opts = {
		private: true,
		public: false,
		str: "<Kengine.Struct>",
	}

	if _struct == undefined and _opts == undefined return;

	if _opts != undefined {	
		__opts = __KengineStructUtils.Merge(_default_opts, _opts);
	} else {
		__opts = _default_opts;
	}

}
