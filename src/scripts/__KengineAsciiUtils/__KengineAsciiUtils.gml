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
    static __GetBrailleDot = function() {return Kengine.Utils.Ascii.__current_braille;}
    static __GetSpinner = function() {return Kengine.Utils.Ascii.__current_spinner;}

	static __Step = function() {
		var ascii = self;
		if ascii.__current_braille_timer != -1 {
			ascii.__current_braille_timer++
		}
		if ascii.__current_braille_timer > 5 {
			ascii.__current_braille_timer = 0;
			switch (ascii.__current_braille) {
				case "⠁": ascii.__current_braille = "⠂"; break;
				case "⠂": ascii.__current_braille = "⠄"; break;
				case "⠄": ascii.__current_braille = "⡀"; break;
				case "⡀": ascii.__current_braille = "⢀"; break;
				case "⢀": ascii.__current_braille = "⠠"; break;
				case "⠠": ascii.__current_braille = "⠐"; break;
				case "⠐": ascii.__current_braille = "⠈"; break;
				default: ascii.__current_braille = "⠁"; break;
			}
		}

		if ascii.__current_spinner_timer != -1 {
			ascii.__current_spinner_timer++
		}
		if ascii.__current_spinner_timer > 5 {
			ascii.__current_spinner_timer = 0;
			switch (ascii.__current_spinner) {
				case "◴": ascii.__current_spinner = "◷"; break;
				case "◷": ascii.__current_spinner = "◶"; break;
				case "◶": ascii.__current_spinner = "◵"; break;
				default: ascii.__current_spinner = "◴"; break;
			}
		}
	}

}
//__KengineAsciiUtils();
