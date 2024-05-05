/**
 * @function Test
 * @new_name Kengine.Extensions.Tests.Test
 * @memberof Kengine.Extensions.Tests
 * @param {String} name The name of the test. Defaults to found function's name.
 * @param {Array<String>|Array<Kengine.Extensions.Tests.Fixture>|Array<Struct>} fixtures An array of fixtures or fixture names or structs containing `{name, func_setup, func_cleanup}`. They will be resolved upon testing.
 * @param {Function} func The main function of the test. Defaults to the found function.
 * @param {Function} step_func A function to use for each step during the test. If it equals `"func"`, it is set to the same `func`. Defaults to `undefined`.
 * @description A test is a simple function wrapper that requires fixtures to be applied before calling, and cleaned after its done.
 *
 */
function __KengineTestsTest(name, fixtures, func, step_func=undefined) constructor {
    var this = self;

    /**
     * @name name
     * @type {String}
     * @memberof Kengine.Extensions.Tests.Test
     * @description The name of the test.
     *
     */
    self.name = name;

    /**
     * @name fixtures
     * @type {Array<Kengine.Extensions.Tests.Fixture>}
     * @memberof Kengine.Extensions.Tests.Test
     * @description An array of fixtures that are resolved upon testing.
     *
     */
    self.fixtures = fixtures ?? [];

    /**
     * @name is_testing
     * @type {Bool}
     * @memberof Kengine.Extensions.Tests.Test
     * @description Whether the test is being tested right now.
     *
     */
    self.is_testing = false;

	__KengineEventUtils.Fire("tests__test__init__before", {test: this});

    /**
     * @name ResolveFixtures
     * @type {Function}
     * @memberof Kengine.Extensions.Tests.Test
     * @description Resolve the `fixtures` of the test. It is called inside the {@link Kengine.Extensions.Tests.Test.test} function.
     * @return {Array<Kengine.Extensions.Tests.Fixture>}
     * @throws {Kengine.Extensions.Tests.AssertionError}
     *
     */
    ResolveFixtures = method({this}, function() {
        var _resolved_fixtures = [];
        array_foreach(this.fixtures, method({this, _resolved_fixtures}, function(_element, _index) {
            if !is_instanceof(_element, __KengineTestsFixture) {
                var _ind = array_find_index(Kengine.Extensions.Tests.fixtures, method({_element}, function(_element2, _index2) {
                    if is_string(_element) {
                        return _element2.name == _element;
                    } else if is_struct(_element) {
                        return _element2.name == _element.name;
                    }
                }));
                if _ind > -1 {
                    _resolved_fixtures[array_length(_resolved_fixtures)] = Kengine.Extensions.Tests.fixtures[_ind];
                } else {
                    var fixname = _element;
                    var broken = true;
                    var new_fixture;
                    if is_struct(_element) {
                        try {
                            fixname = _element.name;
                            new_fixture = new __KengineTestsFixture(fixname, _element.func_setup, _element.func_cleanup);
                            broken = false;
                        } catch (e) {
                            //
                        }
                    }
                    if broken {
                        throw new __KengineTestsAssertionError(
                            __KengineErrorUtils.Create(
                                Kengine.Utils.Errors.Types.tests__fixture__does_not_exist,
                                string("Test \"{0}\" fixture \"{1}\" does not exist.", this.name, fixname)
                        ));
                    } else {
                        _resolved_fixtures[array_length(_resolved_fixtures)] = new_fixture;
                    }
                }
            } else {
                _resolved_fixtures[array_length(_resolved_fixtures)] = _element;
            }
        }));
        this.fixtures = _resolved_fixtures;
        return this.fixtures;
    });

    /**
     * @function Test
     * @memberof Kengine.Extensions.Tests.Test
     * @description The entry test function. Set the `results` struct on the test object.
     * Basically Run `func` and if there's any errors it calls `fail` otherwise it calls `success`.
     *
     */
    self.test = function() {
        var this = self;

        self.result = {
            // test: this,
            assertions: 0,
            success: undefined,
            error: undefined,
            output: undefined,
        };

		try {self.fixtures = self.ResolveFixtures();}
        catch (error) {
            self.Fail(error);
            return; // Nothing done.
        }

        for (var i=0; i<array_length(self.fixtures); i++) {
            self.fixtures[i].Setup({
                test: this,
				test_manager: __KengineTests.test_manager,
            });
        }
        try {
            self.is_testing = true;
            array_push(__KengineTests.test_manager.testing_tests, this);

            method({test_manager: __KengineTests.test_manager, test: this}, this.func)();
            return true;

        } catch (error) {
            self.Fail(error);
        }
	}

    self.Proceed = method({this}, function() {

        if this.step_func != undefined {
			method({test_manager: __KengineTests.test_manager, test: this}, this.step_func)();
        }
        if this.result.error != undefined {
            this.result.success = false;
        }

        if this.result.success != undefined {
            this.Finish();
            return 2;
        }
	});

    self.Finish = method({this}, function() {
        for (var i=0; i<array_length(this.fixtures); i++) {
            this.fixtures[i].Cleanup({
                test: this,
            });
        }

        array_delete(__KengineTests.test_manager.testing_tests, array_get_index(__KengineTests.test_manager.testing_tests, this), 1);
        this.is_testing = false;
        return true;
    });

    /**
     * @function Fail
     * @memberof Kengine.Extensions.Tests.Test
     * @param {Any} error
     * @description Fail test. Change the test result.
    *
     */
    self.Fail = method({this}, function(error) {
        this.result.success = false;
        this.result.error = error;
    });
    
    /**
     * @function Done
     * @memberof Kengine.Extensions.Tests.Test
     * @param {Any} output
     * @description A function to be called at the end of the test script.
     *
     */
    self.Done = method({this}, function(output) {
        this.result.success = true;
        this.result.output = output;
    });

    /**
     * @function AssertEqual
     * @memberof Kengine.Extensions.Tests.Test
     * @description asserts in the test that two values are equal.
     * @param {Any} val1 Value 1
     * @param {Any} val2 Value 2
     * @throws {Kengine.Extensions.Tests.AssertionError}
     *
     */
    self.AssertEqual = method({this}, function(val1, val2) {
        if val1 == val2 {
            this.result.assertions++;
        } else {
            throw new __KengineTestsAssertionError(
                __KengineErrorUtils.Create(
                    Kengine.Utils.Errors.Types.tests__assertion__is_not,
                    string("Test \"{0}\" AssertionError: {1} is not {2}", this.name, val1, val2)
            ));
        }
    });

    /**
     * @name func
     * @type {Function}
     * @memberof Kengine.Extensions.Tests.Test
     * @description The main provided function of the test. Defaults to the found function. If it's a function that begins with {@link KENGINE_TEST_FUNCTION_PREFIX},
     * then it is called when initiating the test and again when the test actually takes place. You can differentiate that within the test function by the reference variable `test` which is the current test.
     * 
     * @example
     * function ken_test_foo() {
     *     if test.is_testing {
     *         return {fixtures: ...}
     *     } else {
     *         test.AssertEqual(1, 1);
     *         test.Done();
     *     };
     * }
     *
     */
    
    var r = false;

	self.func = func;
	if self.func != undefined {
        self.func = method({test: this}, self.func);
		var n = script_get_name(self.func);
	    if string_starts_with(n, KENGINE_TEST_FUNCTION_PREFIX)
            or string_starts_with(n, "gml_Script_" + KENGINE_TEST_FUNCTION_PREFIX) {
                r = true;
		}
    }
    
    /**
     * @function step_func
     * @memberof Kengine.Extensions.Tests.Test
     * @description A function to use for each step during the test.
     *
     */
    self.step_func = step_func;
    if self.step_func != undefined {
        if self.step_func == "func" {
            self.step_func = self.func;
        }
        self.step_func = method({test: this}, self.step_func);
    }


    if r {
        // Run once initiated to get the fixture set.
        self.is_testing = false;
        r = method({test: this}, self.func)();
        if is_struct(r) {
            self.name = __KengineStructUtils.Exists(r, "name") ? __KengineStructUtils.Get(r, "name") : self.name;
            self.fixtures = __KengineStructUtils.Exists(r, "fixtures") ? __KengineStructUtils.Get(r, "fixtures") : self.fixtures;
            self.func = __KengineStructUtils.Exists(r, "func") ? method({test: this}, __KengineStructUtils.Get(r, "func")) : self.func;
            self.step_func = __KengineStructUtils.Exists(r, "step_func") ? method({test: this}, __KengineStructUtils.Get(r, "step_func")) : self.step_func;
        } else {
            throw __KengineErrorUtils.Create(Kengine.Utils.Errors.Types.tests__test__func_invalid_return, string("Test \"{0}\" function did not return a struct.", self.name));
        }
    }

    __KengineEventUtils.Fire("tests__test__init__after", {test: this});
}
