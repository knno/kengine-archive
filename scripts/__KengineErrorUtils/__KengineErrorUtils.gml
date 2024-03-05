/**
 * @namespace Errors
 * @memberof Kengine.Utils
 * @description A struct containing Kengine errors utilitiy functions
 *
 */
function __KengineErrorUtils() : __KengineStruct() constructor {

    /**
     * @function Create
     * @memberof Kengine.Utils.Errors
     * @description Create an error struct that is thrown.
     * @param {String} [error_type="unknown"] Error type as a string, or as a reference to an attribute of `Kengine.Utils.Errors.Types`.
     * @param {String} [longMessage=""]
     * @param {Bool} [useLong=false]
     * @return {Struct}
     * 
     */
    static Create = function(error_type="unknown", longMessage="", useLong=false) {
        var _types = static_get(__KengineErrorUtils.Types);
        if not __KengineStructUtils.Exists(_types, error_type) {
            var names = struct_get_names(_types);
            for (var i = 0; i < array_length(names); i++) {
                var name = names[i];
                var value = struct_get(_types, name);
                if (value == error_type) {
                    error_type = name;
                    break;
                }
            }
            if error_type == "unknown" {
                error_type = _types.error__does_not_exist;
            }
        }
        return {
            error_source: "kengine",
            error_type: error_type,
            stacktrace: debug_get_callstack(),
            message: useLong ? longMessage : __KengineStructUtils.Get(_types, error_type),
            longMessage: longMessage,
        }
    }

	static AddType = function(key, _message) {
		__KengineErrorUtils.Types[$ key] = _message
	}

    /**
     * @member {Struct} Types
     * @memberof Kengine.Utils.Errors
     * @description Preset error types. These errors are extendable through Kengine extensions.
     * 
     */
    static Types = function() : __KengineStruct() constructor {

        /**
         * @member {String} unknown
         * @memberof Kengine.Utils.Errors.Types
         * @description Unknown error occured.
         */
        static unknown = "Unknown error occured."

        /**
         * @member {String} array__access_with_name
         * @memberof Kengine.Utils.Errors.Types
         * @description Cannot access array by name.
         */
        static array__access_with_name = "Cannot access array by name."
        
        /**
         * @member {String} array__cannot_be_private
         * @memberof Kengine.Utils.Errors.Types
         * @description Arrays cannot become private.
         */
        static array__cannot_be_private = "Arrays cannot become private."
        
        /**
         * @member {String} array__cannot_be_readonly
         * @memberof Kengine.Utils.Errors.Types
         * @description Arrays cannot become readonly.
         */
        static array__cannot_be_readonly = "Arrays cannot become readonly."

        /**
         * @member {String} error__does_not_exist
         * @memberof Kengine.Utils.Errors.Types
         * @description Error is not defined.
         * 
         */
        static error__does_not_exist = "Error is not defined."

        /**
         * @member {String} asset__asset_type__does_not_exist 
         * @memberof Kengine.Utils.Errors.Types
         * @description Cannot create asset (non-existent AssetType). 
         * 
         */
        static asset__asset_type__does_not_exist = "Cannot create asset (non-existent AssetType)."

        /**
         * @member {String } asset__asset_type__cannot_replace
         * @memberof Kengine.Utils.Errors.Types
         * @description Cannot replace Asset (AssetType is not replaceable).
         *
         */
        static asset__asset_type__cannot_replace = "Cannot replace Asset (AssetType is not replaceable)."
        
        /**
         * @member {String } asset__cannot_replace
         * @memberof Kengine.Utils.Errors.Types
         * @description Cannot replace Asset.
         *
         */
        static asset__cannot_replace = "Cannot replace Asset."

        /**
         * @member {String } asset__asset_type__cannot_add
         * @memberof Kengine.Utils.Errors.Types
         * @description Cannot add Asset (AssetType is not addable).
         *
         */
        static asset__asset_type__cannot_add = "Cannot add Asset (AssetType is not addable)."

        /** 
         * @member {String} asset_type__asset_type__exists
         * @memberof Kengine.Utils.Errors.Types
         * @description AssetType already defined.
         * 
        */
        static asset_type__asset_type__exists = "AssetType already defined."

        /** 
         * @member {String} asset_type__does_not_exist
         * @memberof Kengine.Utils.Errors.Types
         * @description AssetType does not exist.
         * 
        */
        static asset_type__does_not_exist = "AssetType does not exist."

        /** 
         * @member {String} instance__asset__does_not_exist
         * @memberof Kengine.Utils.Errors.Types
         * @description Cannot create instance from asset (non-existent Asset).
         * 
         */
        static instance__asset__does_not_exist = "Cannot create instance from asset (non-existent Asset)."

        /**
         * @member {String} script_exec__script__does_not_exist
         * @memberof Kengine.Utils.Errors.Types
         * @description Cannot execute script (non-existent script). 
         * 
         */
        static script_exec__script__does_not_exist = "Cannot execute script (non-existent script)."
    }
}
__KengineErrorUtils();
