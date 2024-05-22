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
     * @function Add
     * @memberof Kengine.Utils.Hashkeys
     * @description Adds a hash to _hashkeys.
     * @param {String} name The name.
     * @return {Struct} The key struct which contains name and hash attrs.
     *
     */
    static Add = function(name) {
        __all[$ name] = {name: name, hash: variable_get_hash(name)};
    }

    /**
     * @function Hash
     * @memberof Kengine.Utils.Hashkeys
     * @description Converts hashkey or string or hash to just hash.
     * @param {Struct|String|Real} name The name as a string, real or hash key.
     * @return {Any} The hash to use.
     *
     */
    static Hash = function(name) {
        var key;
        if is_struct(name) {
            key = name.hash; // hash key
        } else if is_real(name) {
            key = name; // hash
        } else if is_string(name) {
			if (name) == "toString" return undefined;
            if !__KengineStructUtils.Exists(__all, name) {
                Add(name);
            }
            key = __all[$ name].hash;

        }
        return key;
    }

    /**
     * @member __all
     * @type {Struct}
     * @private
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
        async_audio_playback: {name: "async_audio_playback", hash: variable_get_hash("async_audio_playback")},
        async_audio_playback_ended: {name: "async_audio_playback_ended", hash: variable_get_hash("async_audio_playback_ended")},
        async_audio_recording: {name: "async_audio_recording", hash: variable_get_hash("async_audio_recording")},
        async_dialog: {name: "async_dialog", hash: variable_get_hash("async_dialog")},
        async_push_notification: {name: "async_push_notification", hash: variable_get_hash("async_push_notification")},
        async_save_load: {name: "async_save_load", hash: variable_get_hash("async_save_load")},
        async_social: {name: "async_social", hash: variable_get_hash("async_social")},
        async_system_event: {name: "async_system_event", hash: variable_get_hash("async_system_event")},
        async_web: {name: "async_web", hash: variable_get_hash("async_web")},
        async_web_cloud: {name: "async_web_cloud", hash: variable_get_hash("async_web_cloud")},
        async_web_iap: {name: "async_web_iap", hash: variable_get_hash("async_web_iap")},
        async_web_image_load: {name: "async_web_image_load", hash: variable_get_hash("async_web_image_load")},
        async_web_networking: {name: "async_web_networking", hash: variable_get_hash("async_web_networking")},
        async_web_steam: {name: "async_web_steam", hash: variable_get_hash("async_web_steam")},
		// So on...
    }
}
//__KengineHashkeyUtils();
