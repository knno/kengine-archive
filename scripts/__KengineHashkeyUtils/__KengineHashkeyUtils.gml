/**
 * @namespace Hashkeys
 * @memberof Kengine.Utils
 * @description A struct containing Kengine hashkeys utilitiy functions
 *
 */
function __KengineHashkeyUtils() : __KengineStruct() constructor  {

	static __opts = {
		private: true
	}

    /**
     * @function add
     * @memberof Kengine.Utils.Hashkeys
     * @description Add a hash to _hashkeys.
     * @param {String} name The name.
     * @return {Struct} The key struct which contains name and hash attrs.
     *
     */
    static add = function(name) {
        __all[$ name] = {name: name, hash: variable_get_hash(name)};
    }

    /**
     * @function hash
     * @memberof Kengine.Utils.Hashkeys
     * @description Convert hashkey or string or hash to just hash.
     * @param {Struct|String|Real} name The name as a string, real or hash key.
     * @return {Any} The hash to use.
     *
     */
    static hash = function(name) {
        var key;
        if is_struct(name) {
            key = name.hash; // hash key
        } else if is_real(name) {
            key = name; // hash
        } else if is_string(name) {
			if (name) == "toString" return undefined;
            if !__KengineStructUtils.Exists(__all, name) {
                add(name);
            }
            key = __all[$ name].hash;

        }
        return key;
    }

    /**
     * @member __all
     * @type {Struct}
     * @memberof Kengine.Utils.Hashkeys
     * @description A struct that contains name and hash structs for structs.
     * 
     */
    static __all = {
        create: {name: "create", hash: variable_get_hash("create")},
        clean_up: {name: "clean_up", hash: variable_get_hash("clean_up")},
        collision: {name: "collision", hash: variable_get_hash("collision")},
        destroy: {name: "destroy", hash: variable_get_hash("destroy")},
        draw: {name: "draw", hash: variable_get_hash("draw")},
        draw_begin: {name: "draw_begin", hash: variable_get_hash("draw_begin")},
        draw_end: {name: "draw_end", hash: variable_get_hash("draw_end")},
        pre_draw: {name: "pre_draw", hash: variable_get_hash("pre_draw")},
        post_draw: {name: "post_draw", hash: variable_get_hash("post_draw")},
        draw_gui: {name: "draw_gui", hash: variable_get_hash("draw_gui")},
        draw_gui_begin: {name: "draw_gui_begin", hash: variable_get_hash("draw_gui_begin")},
        draw_gui_end: {name: "draw_gui_end", hash: variable_get_hash("draw_gui_end")},
        other_: {name: "other", hash: variable_get_hash("other")},
        user: {name: "user", hash: variable_get_hash("user")},
        step: {name: "step", hash: variable_get_hash("step")},
        step_begin: {name: "step_begin", hash: variable_get_hash("step_begin")},
        step_end: {name: "step_end", hash: variable_get_hash("step_end")},
        path_end: {name: "path_end", hash: variable_get_hash("path_end")},
        outside: {name: "outside", hash: variable_get_hash("outside")},
        game_end: {name: "game_end", hash: variable_get_hash("game_end")},
        room_start: {name: "room_start", hash: variable_get_hash("room_start")},
        room_end: {name: "room_end", hash: variable_get_hash("room_end")},
		rm: {name: "rm", hash: variable_get_hash("rm")},
        // So on...
    }
}
__KengineHashkeyUtils();
