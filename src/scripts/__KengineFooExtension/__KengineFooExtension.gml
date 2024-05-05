// Extension Constructor
function __KengineFooExtension() constructor {
	/**
	 * Name of the extension
	 * Required
	 */
	static name = "FooExtension";

	/**
	 * Classes provided by the extension
	 */
	//static Class = __KengineFooExtensionClass;

	// static Step = function() {
	// 	  ...
	// }

	// static DrawGui = function() {
	// 	  ...
	// }

	/**
	 * Extension methods and variables go here.
	 */

	// ...
}

// Extension Initiater: remove the "dummy__" prefix to automatically activate.
function dummy__ken_init_ext_foo_extension() {
	// Define Error types here.
	//Kengine.Utils.Errors.AddType("foo_extension__class1__func1__invalid_return", "Class1 function1 returned invalid.");
	
	// Define (and implement) your events here.
	//Kengine.Utils.Events.Define("foo_extension__class1__init__before");
	//Kengine.Utils.Events.Define("foo_extension__class1__init__after");

	// Construct your extension
	var _foo_extension = (new __KengineFooExtension());
	Kengine.Extensions.Add(_foo_extension);
}
