/**
 * @namespace Tests
 * @memberof Kengine.Extensions
 * @description Kengine's Tests extension
 *
 */
function __KengineTests() : __KengineStruct() constructor {

	static name= "Tests"
	static fixtures = [] // Default fixtures
	static __started = false;
	static __testing_tests = [] // Current active tests.

	static Step = function(extension) {
		var _ext = extension; // static_get(extension);
		if (not _ext.__started) {
			_ext.__started = true;
			_ext.status = "READY";
		    _ext.test_manager.FindTests();
			_ext.test_manager.Test();
		}
		if (_ext.test_manager != undefined) {
			if (_ext.test_manager.step_enabled) {
					_ext.test_manager.Step();
			}
		}
	}

	static test_manager = new __KengineTestsTestManager()

    static Test = __KengineTestsTest
    static Fixture = __KengineTestsFixture
    static AssertionError = __KengineTestsAssertionError
    static TestManager = __KengineTestsTestManager
}


function ken_init_ext_tests() {
	
	if not Kengine.is_testing return;

    #region Error types
    /**
     * @member {String} tests__test__func_invalid_return
     * @memberof Kengine.Utils.Errors.Types
     * @description Test function did not return a struct.
     */
	Kengine.Utils.Errors.Define("tests__test__func_invalid_return", "Test function did not return a struct.");

    /**
     * @member {String} tests__fixture__does_not_exist
     * @memberof Kengine.Utils.Errors.Types
     * @description Test fixture does not exist.
     */
    Kengine.Utils.Errors.Define("tests__fixture__does_not_exist", "Test fixture does not exist.");

    /**
     * @member {String} tests__assertion__is_not
     * @memberof Kengine.Utils.Errors.Types
     * @description Assertion failure.
     */
    Kengine.Utils.Errors.Define("tests__assertion__is_not", "Assertion failure.");
    #endregion

    #region Events
	/**
	 * @event tests__test__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine Test.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {test}`.
	 *
	 * `event`: The event.
	 *
	 * `test`: The {@link Kengine.Extensions.Tests.Test} being constructed.
	 *
	 */
    Kengine.Utils.Events.Define("tests__test__init__before");

    /**
	 * @event tests__test__init__after
	 * @type {Array<Function>}
	 * @description An event that fires after initializing a Kengine Test.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {test}`.
	 *
	 * `event`: The event.
	 *
	 * `test`: The {@link Kengine.Extensions.Tests.Test} being constructed.
	 *
	 */
    Kengine.Utils.Events.Define("tests__test__init__after");

    /**
	 * @event tests__tests_complete
	 * @type {Array<Function>}
	 * @description An event that fires after all Kengine tests are compelete.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {status, fails, total, reports}`.
	 *
	 * `event`: The event.
	 *
	 * `status`: Either "SUCCESS" or "FAILURE"
	 *
	 * `reports`: A struct (by test name) of the reports of the tests. {success, assertions, error, output}. each can be undefined.
	 *
	 * `fails`: Number of failed tests.
	 *
	 * `total`: Total number of tests.
	 *
	 */
    Kengine.Utils.Events.Define("tests__tests_complete");
    #endregion

	var _tests = new __KengineTests();
	Kengine.Extensions.Add(_tests);
}
