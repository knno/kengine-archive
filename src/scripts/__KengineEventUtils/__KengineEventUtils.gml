/**
 * @namespace Events
 * @memberof Kengine.Utils
 * @description A struct containing Kengine events utilitiy functions
 *
 */
function __KengineEventUtils() : __KengineStruct() constructor {

    /**
     * @function Define
     * @memberof Kengine.Utils.Events
     * @description Defines an event.
     * @param {String} event The event name.
     * @param {Array<Function>} [listeners] The event listener functions
     *
     */
    static Define = function(event, listeners=[]) {
		__KengineEventUtils.__all[$ event] ??= listeners;
    }
    AddEvent = Define;

    /**
     * @function AddListener
     * @memberof Kengine.Utils.Events
     * @description Adds an event listener (function) or more to the events.
     * @param {String} event The event name.
     * @param {Function|Array<Function>} listener The event listener function(s)
     * @return {Bool} Whether added successfuly (if the event is defined) or not.
     *
     */
    static AddListener = function(event, listener) {
        var _all_events = __KengineEventUtils.__all;
        if __KengineStructUtils.Exists(_all_events, event) {
            var event_arr = __KengineStructUtils.Get(_all_events, event);
            if is_array(listener) {
                for (var i=0; i<array_length(listener); i++) {
                    array_push(event_arr, listener[i]);
                }
            } else {
                array_push(event_arr, listener);
            }
            return true;
        } else {
            return false
        }
    }

    /**
     * @function RemoveListener
     * @memberof Kengine.Utils.Events
     * @description Removes an event listener (function) or more from the events.
     * @param {String} event The event name.
     * @param {Function|Array<Function>} listener The event listener function(s)
     * @param {Bool} [_all=true] Whether to remove all occurences of the function. Defaults to `true`.
     * @return {Bool} Whether removed successfuly (if the event is defined) or not.
     *
     */
    static RemoveListener = function (event, listener, _all=false) {
        var _all_events = __KengineEventUtils.__all;
        if __KengineStructUtils.Exists(_all_events, event) {
            var event_arr = __KengineStructUtils.Get(_all_events, event);
            if is_array(listener) {
                for (var i=0; i<array_length(listener); i++) {
                    __KengineArrayUtils.DeleteValue(event_arr, listener[i], _all);
                }
            } else {
                __KengineArrayUtils.DeleteValue(event_arr, listener, _all);
            }
            return true;
        } else {
            return false
        }
    }

    /**
     * @function Fire
     * @memberof Kengine.Utils.Events
     * @description Fires an event with arguments.
     * @param {String} event The event name.
     * @param {Any} args The event arguments
     * @return {Bool|Undefined} Whether the event is registered.
     *
     */
    static Fire = function(event, args=undefined) {
        if (not (KENGINE_EVENTS_ENABLED)) {return}
        var _all_events = __KengineEventUtils.__all;
        var event_arr = __KengineStructUtils.Get(_all_events, event);
        if event_arr == undefined return false;

        for (var i=0; i<array_length(event_arr); i++) {
            if event_arr[i] != undefined {
                event_arr[i](event, args);
            }
        }
        if (KENGINE_BENCHMARK and event != "start__before") {
            var timer = get_timer(); var diff = timer - __KengineBenchmarkUtils.__slot5Timer; __KengineBenchmarkUtils.__slot5Timer = timer;
            Kengine.console.verbose("Kengine: Benchmark: Event: " + event + ": " + string(diff/1000) + "ms", 2);
        }
        return true;
    }

    /**
     * @member __all
     * @type {Struct}
     * @private
     * @memberof Kengine.Utils.Events
     * @description A struct that contains Kengine events as keys and an array of functions (listeners) to call on event fire.
     * 
     */
    static __all = function() : __KengineStruct() constructor {

        /**
         * @event start__before
         * @type {Array<Function>}
         * @description An event that fires before Kengine starts.
         * 
         */
        static start__before = []

        /**
         * @event start__after
         * @type {Array<Function>}
         * @description An event that fires after Kengine starts.
         *
         * Functions accept one argument: `event`.
         *
         * `event`: The event name as string.
         *
         */
        static start__after = []

        /**
         * @event extensions__before
         * @type {Array<Function>}
         * @description An event that fires after Kengine finds extensions.
         * 
         * Functions accept two arguments, the second is a struct: `event, {extension_assets}`.
         * 
         * `event`: The event name as string.
         *
         * `extension_assets`: The script assets struct that are found, keyed by their extension name.
         *
         */
        static extensions__before = []

        /**
         * @event extension__start__before
         * @type {Array<Function>}
         * @description An event that fires before Kengine starts an extension.
         * 
         * Functions accept two arguments, the second is a struct: `event, {extension}`.
         * 
         * `event`: The event.
         *
         * `extension_name`: The name of the extension.
         *
         * `extension_asset`: The Kengine script asset of the extension.
         *
         */
        static extension__start__before = []

        /**
         * @event extension__start__after
         * @type {Array<Function>}
         * @description An event that fires after Kengine starts an extension.
         * 
         * Functions accept two arguments, the second is a struct: `event, {extension}`.
         * 
         * `event`: The event.
         *
         * `extension_name`: The name of the extension.
         *
         * `extension_asset`: The Kengine script asset of the extension.
         *
         */
        static extension__start__after = []

        /**
         * @event extensions__after
         * @type {Array<Function>}
         * @description An event that fires after Kengine starts all extensions.
         * 
         * Functions accept two arguments, the second is a struct: `event, {extensions}`.
         * 
         * `event`: The event.
         *
         * `extension_assets`: The same struct in {@link event:extensions__before}
         *
         */
        static extensions__after = []

        /**
         * @event asset_type__init__before
         * @type {Array<Function>}
         * @description An event that fires before initializing Kengine's AssetType.
         * If you have totally substituted the class, you need to reimplement this event.
         * 
         * Functions accept two arguments, the second is a struct: `event, {asset_type}`.
         * 
         * `event`: The event.
         *
         * `asset_type`: The {@link Kengine.AssetType} being constructed.
         *
         */
        static asset_type__init__before = []

        /**
         * @event asset_type__init__after
         * @type {Array<Function>}
         * @description An event that fires after initializing Kengine's AssetType.
         * If you have totally substituted the class, you need to reimplement this event.
         * 
         * Functions accept two arguments, the second is a struct: `event, {asset_type}`.
         * 
         * `event`: The event.
         *
         * `asset_type`: The {@link Kengine.AssetType} being constructed.
         *
         */
        static asset_type__init__after = []

        /**
         * @event asset_type__index_assets__before
         * @type {Array<Function>}
         * @description An event that fires at the beginning of Kengine's AssetType index_assets function.
         * If you have replaced the class's method, you need to reimplement this event.
         *
         * Functions accept two arguments, the second is a struct: `event, {asset_type}`.
         *
         * `event`: The event.
         *
         * `asset_type`: The {@link Kengine.AssetType} that is indexing its assets.
         *
         */
        static asset_type__index_assets__before = []

        /**
         * @event asset_type__index_assets__after
         * @type {Array<Function>}
         * @description An event that fires at the end of Kengine's AssetType index_assets function.
         * If you have replaced the class's method, you need to reimplement this event.
         *
         * Functions accept two arguments, the second is a struct: `event, {asset_type}`.
         *
         * `event`: The event.
         *
         * `asset_type`: The {@link Kengine.AssetType} that is indexing its assets.
         *
         */
        static asset_type__index_assets__after = []

        /**
         * @event asset__init__before
         * @type {Array<Function>}
         * @description An event that fires before initializing a Kengine's Asset.
         *
         * Functions accept two arguments, the second is a struct: `event, {asset}`.
         *
         * `event`: The event.
         *
         * `asset`: The {@link Kengine.Asset} being constructed.
         *
         */
        static asset__init__before = []

        /**
         * @event asset__init__after
         * @type {Array<Function>}
         * @description An event that fires after initializing a Kengine's Asset.
         *
         * Functions accept two arguments, the second is a struct: `event, {asset}`.
         *
         * `event`: The event.
         *
         * `asset`: The {@link Kengine.Asset} being constructed.
         *
         */
        static asset__init__after = []

        /**
         * @event asset__index__before
         * @type {Array<Function>}
         * @description An event that fires at the beginning of {@link Kengine.AssetType.index_asset} of an Asset's AssetType.
         * If you have replaced the method, you need to reimplement this event.
         *
         * Functions accept two arguments, the second is a struct: `event, {asset, result}`.
         *
         * `event`: The event.
         *
         * `asset`: The {@link Kengine.Asset} being indexed.
         *
         * `result`: The result array. First is whether it is successful, the second is its index in the assets Collection.
         *
         */
        static asset__index__before = []

        /**
         * @event asset__index__after
         * @type {Array<Function>}
         * @description An event that fires at the end of {@link Kengine.AssetType.index_asset} of an Asset's AssetType.
         * Only if the asset is indexed into assets Collection.
         * If you have replaced the method, you need to reimplement this event.
         *
         * Functions accept two arguments, the second is a struct: `event, {asset, result}`.
         *
         * `event`: The event.
         *
         * `asset`: The {@link Kengine.Asset} indexed.
         *
         * `result`: The result array. First is whether it is successful, the second is its index in the assets Collection.
         *
         */
        static asset__index__after = []

    }
	__all = new __all();
}
