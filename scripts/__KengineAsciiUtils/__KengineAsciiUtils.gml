/**
 * @namespace Ascii
 * @memberof Kengine.Utils
 * @description A struct containing Kengine ascii utilitiy functions
 *
 */
function __KengineAsciiUtils() : __KengineStruct() constructor {
    static __current_braille = ""
    static __current_braille_timer = 0
    static __current_spinner = "◴"
    static __current_spinner_timer = 0
    static __GetBrailleDot = function() {return __KengineAsciiUtils.__current_braille;}
    static __GetSpinner = function() {return __KengineAsciiUtils.__current_spinner;}

	static __Step = function() {
		if __KengineAsciiUtils.__current_braille_timer != -1 {
			__KengineAsciiUtils.__current_braille_timer++
		}
		if __KengineAsciiUtils.__current_braille_timer > 5 {
			__KengineAsciiUtils.__current_braille_timer = 0;
			switch (__KengineAsciiUtils.__current_braille) {
				case "⠁": __KengineAsciiUtils.__current_braille = "⠂"; break;
				case "⠂": __KengineAsciiUtils.__current_braille = "⠄"; break;
				case "⠄": __KengineAsciiUtils.__current_braille = "⡀"; break;
				case "⡀": __KengineAsciiUtils.__current_braille = "⢀"; break;
				case "⢀": __KengineAsciiUtils.__current_braille = "⠠"; break;
				case "⠠": __KengineAsciiUtils.__current_braille = "⠐"; break;
				case "⠐": __KengineAsciiUtils.__current_braille = "⠈"; break;
				default: __KengineAsciiUtils.__current_braille = "⠁"; break;
			}
		}

		if __KengineAsciiUtils.__current_spinner_timer != -1 {
			__KengineAsciiUtils.__current_spinner_timer++
		}
		if __KengineAsciiUtils.__current_spinner_timer > 5 {
			__KengineAsciiUtils.__current_spinner_timer = 0;
			switch (__KengineAsciiUtils.__current_spinner) {
				case "◴": __KengineAsciiUtils.__current_spinner = "◷"; break;
				case "◷": __KengineAsciiUtils.__current_spinner = "◶"; break;
				case "◶": __KengineAsciiUtils.__current_spinner = "◵"; break;
				default: __KengineAsciiUtils.__current_spinner = "◴"; break;
			}
		}
	}

}
__KengineAsciiUtils();
