/**
 * @namespace tests
 * @memberof Kengine
 * @description Kengine's Tests extension
 *
 */
Kengine.tests = {
    fixtures: [], // Default fixtures
    testing_tests: [], // Current active tests.
};

Kengine.utils.structs.set_default(Kengine.conf.exts, "tests", {});

/**
 * @function AssertionError
 * @constructor
 * @new_name Kengine.tests.AssertionError
 * @memberof Kengine.tests
 * @description An AssertionError is thrown by a test function.
 * @param {Struct} error The main causing error struct.
 * @param {String} [message] A message for the assertion. Defaults to that of `error` param.
 * @param {String} [longMessage] A long message for the assertion. Defaults to that of `error` param.
 * 
 * @example
 * var assertion_error = new Kengine.tests.AssertionError(
 *     Kengine.utils.errors.create(
 *         "myext__foo__does_not_exist",
 *         string("Foo \"{0}\" does not exist.", foo.name)
 * )));
 * 
 */
Kengine.tests.DefaultAssertionError = function(error, message=undefined, longMessage=undefined) constructor {

    /**
     * @name error
     * @type {Struct}
     * @memberof Kengine.tests.AssertionError
     * @description The main causing error struct.
     * 
     */
    self.error = error;

    /**
     * @name message
     * @type {String}
     * @memberof Kengine.tests.AssertionError
     * @description A message for the assertion. Defaults to that of `error`.
     * 
     */
    self.message = message ?? error.message;

    /**
     * @name longMessage
     * @type {String}
     * @memberof Kengine.tests.AssertionError
     * @description A long message for the assertion. Defaults to that of `error`.
     *
     */
    self.longMessage = longMessage ?? error.longMessage;

}

/**
 * @function Fixture
 * @constructor
 * @new_name Kengine.tests.Fixture
 * @memberof Kengine.tests
 * @description A fixture is a struct that contains `name`, and `func_setup` and `func_cleanup` functions.
 * @param {String} name The name of the fixture.
 * @param {Function} func_setup The function of the fixture that setups the test.
 * @param {Function} func_cleanup The function of the fixture that cleans up the test.
 *
 */
Kengine.tests.DefaultFixture = function(name, func_setup, func_cleanup) constructor {

    /**
     * @name name
     * @type {String}
     * @memberof Kengine.tests.Fixture
     * @description The name of the fixture.
     *
     */
    self.name = name;

    var _fixtures = Kengine.tests.fixtures;
    for (var i=0; i<array_length(_fixtures); i++) {
        if _fixtures[i].name == name {
            throw Kengine.utils.errors.create(Kengine.utils.errors.types.tests__fixture__exists, string("Fixture \"{0}\" already defined.", name));
        }
    }

    /**
     * @name _testing_tests
     * @type {Array<Kengine.tests.Test>}
     * @memberof Kengine.tests.Fixture
     * @description A list of tests that are running and dependent on this fixture.
     * 
     */
    self._testing_tests = [];

    /**
     * @function func_setup
     * @memberof Kengine.tests.Fixture
     * @description The function of the fixture that setups the test.
     *
     */
    self.func_setup = func_setup;

    /**
     * @function func_cleanup
     * @memberof Kengine.tests.Fixture
     * @description The function of the fixture that cleans up the test.
     *
     */
    self.func_cleanup = func_cleanup;

    /**
     * @name is_applied
     * @type {Bool}
     * @memberof Kengine.tests.Fixture
     * @description Whether fixture is applied (active) or not.
     *
     */
    self.is_applied = false;

    /**
     * @function setup
     * @memberof Kengine.tests.Fixture
     * @description A function that set ups the fixture data.
     * @param {Struct|Undefined} [args] A struct containing `{test}`.
     *
     */
    self.setup = function(args=undefined) {
        if not self.is_applied {
            method({test_manager: args.test_manager}, self.func_setup)();
            self.is_applied = true;
            array_push(self._testing_tests, args.test);
        }
    };

    /**
     * @function cleanup
     * @memberof Kengine.tests.Fixture
     * @description A function that cleans up the fixture data. This is done when there are no dependents tests running.
     * @param {Struct|Undefined} [args] A struct containing `{test}`.
     *
     */
    self.cleanup = function(args=undefined) {
        if self.is_applied {
            array_delete(self._testing_tests, array_get_index(self._testing_tests, args.test), 1);
            if array_length(self._testing_tests) == 0 {
	            method({test_manager: Kengine.tests.test_manager}, self.func_cleanup)();
                self.is_applied = false;
            }
        }
    };

    _fixtures = Kengine.tests.fixtures; _fixtures[array_length(_fixtures)] = self;
}

/**
 * @function Test
 * @constructor
 * @new_name Kengine.tests.Test
 * @memberof Kengine.tests
 * @param {String} name The name of the test. Defaults to found function's name.
 * @param {Array<String>|Array<Kengine.tests.Fixture>|Array<Struct>} fixtures An array of fixtures or fixture names or structs containing `{name, func_setup, func_cleanup}`. They will be resolved upon testing.
 * @param {Function} func The main function of the test. Defaults to the found function.
 * @param {Function} step_func A function to use for each step during the test. If it equals `"func"`, it is set to the same `func`. Defaults to `undefined`.
 * @description A test is a simple function wrapper that requires fixtures to be applied before calling, and cleaned after its done.
 *
 */
Kengine.tests.DefaultTest = function(name, fixtures, func, step_func=undefined) constructor {
    var this = self;

    /**
     * @name name
     * @type {String}
     * @memberof Kengine.tests.Test
     * @description The name of the test.
     *
     */
    self.name = name;

    /**
     * @name fixtures
     * @type {Array<Kengine.tests.Fixture>}
     * @memberof Kengine.tests.Test
     * @description An array of fixtures or fixture names or structs containing `{name, func_setup, func_cleanup}`. They will be resolved upon testing.
     *
     */
    self.fixtures = fixtures ?? [];

    /**
     * @name is_testing
     * @type {Bool}
     * @memberof Kengine.tests.Test
     * @description Whether the test is being tested right now.
     *
     */
    self.is_testing = false;

    /**
     * @name resolve_fixtures
     * @type {Function}
     * @memberof Kengine.tests.Test
     * @description Resolve the `fixtures` of the test. It is called inside the {@link Kengine.tests.Test.test} function.
     * @return {Array<Kengine.tests.Fixture>}
     * @throws {Kengine.tests.AssertionError}
     *
     */

    Kengine.utils.events.fire("tests__test__init__before", {test: this});

    self.resolve_fixtures = method({this}, function() {
        var resolved_fixtures = [];
        array_foreach(this.fixtures, method({this, resolved_fixtures}, function(_element, _index) {
            if !is_instanceof(_element, Kengine.tests.Fixture) {
                var _ind = array_find_index(Kengine.tests.fixtures, method({_element}, function(_element2, _index2) {
                    if is_string(_element) {
                        return _element2.name == _element;
                    } else if is_struct(_element) {
                        return _element2.name == _element.name;
                    }
                }));
                if _ind > -1 {
                    resolved_fixtures[array_length(resolved_fixtures)] = Kengine.tests.fixtures[_ind];
                } else {
                    var fixname = _element;
                    var broken = true;
                    var new_fixture;
                    if is_struct(_element) {
                        try {
                            fixname = _element.name;
                            new_fixture = new Kengine.tests.Fixture(fixname, _element.func_setup, _element.func_cleanup);
                            broken = false;
                        } catch (e) {
                            //
                        }
                    }
                    if broken {
                        throw new Kengine.tests.AssertionError(
                            Kengine.utils.errors.create(
                                Kengine.utils.errors.types.tests__fixture__does_not_exist,
                                string("Test \"{0}\" fixture \"{1}\" does not exist.", this.name, fixname)
                        ));
                    } else {
                        resolved_fixtures[array_length(resolved_fixtures)] = new_fixture;
                    }
                }
            } else {
                resolved_fixtures[array_length(resolved_fixtures)] = _element;
            }
        }));
        this.fixtures = resolved_fixtures;
        return this.fixtures;
    });

    /**
     * @function test
     * @memberof Kengine.tests.Test
     * @description The entry test function. Set the `results` struct on the test object.
     * Basically Run `func` and if there's any errors it calls `fail` otherwise it calls `success`.
     *
     */
    self.test = method({this}, function() {
        this.result = {
            // test: this,
            assertions: 0,
            success: undefined,
            error: undefined,
            output: undefined,
        };

		try {this.fixtures = this.resolve_fixtures();}
        catch (error) {
            this.fail(error);
            return; // Nothing done.
        }

        for (var i=0; i<array_length(this.fixtures); i++) {
            this.fixtures[i].setup({
                test: this,
				test_manager: Kengine.tests.test_manager,
            });
        }
        try {
            this.is_testing = true;
            array_push(Kengine.tests.test_manager.testing_tests, this);

            method({test_manager: Kengine.tests.test_manager, test: this}, this.func)();
            return true;

        } catch (error) {
            this.fail(error);
        }
    });

    self.proceed = method({this}, function() { // Async
        if this.step_func != undefined {
			method({test_manager: Kengine.tests.test_manager, test: this}, this.step_func)();
        }
        if this.result.error != undefined {
            this.result.success = false;
        }

        if this.result.success != undefined {
            this.finish();
            return 2;
        }
	});

    self.finish = method({this}, function() {
        for (var i=0; i<array_length(this.fixtures); i++) {
            this.fixtures[i].cleanup({
                test: this,
            });
        }
        array_delete(Kengine.tests.test_manager.testing_tests, array_get_index(Kengine.tests.test_manager.testing_tests, this), 1);
        this.is_testing = false;
        return true;
    });

    /**
     * @function fail
     * @memberof Kengine.tests.Test
     * @param {Any} error
     * @description Fail test. Change the test result.
    *
     */
    self.fail = method({this}, function(error) {
        this.result.success = false;
        this.result.error = error;
    });
    
    /**
     * @function done
     * @memberof Kengine.tests.Test
     * @param {Any} output
     * @description A function to be called at the end of the test script.
     *
     */
    self.done = method({this}, function(output) {
        this.result.success = true;
        this.result.output = output;
    });

    /**
     * @function assertEqual
     * @memberof Kengine.tests.Test
     * @description asserts in the test that two values are equal.
     * @param {Any} val1 Value 1
     * @param {Any} val2 Value 2
     * @throws {Kengine.tests.AssertionError}
     *
     */
    self.assertEqual = method({this}, function(val1, val2) {
        if val1 == val2 {
            this.result.assertions++;
        } else {
            throw new Kengine.tests.AssertionError(
                Kengine.utils.errors.create(
                    Kengine.utils.errors.types.tests__assertion__is_not,
                    string("Test \"{0}\" AssertionError: {1} is not {2}", this.name, val1, val2)
            ));
        }
    });

    /**
     * @name func
     * @type {Function}
     * @memberof Kengine.tests.Test
     * @description The main provided function of the test. Defaults to the found function. If it's a function that begins with {@link Kengine.constants.TEST_FUNCTION_PREFIX},
     * then it is called when initiating the test and again when the test actually takes place. You can differentiate that within the test function by the reference variable `test` which is the current test.
     * 
     * @example
     * function ken_test_foo() {
     *     if test.is_testing {
     *         return {fixtures: ...}
     *     } else {
     *         test.assertEqual(1, 1);
     *         test.done();
     *     };
     * }
     *
     */
    
    var r = false;

	self.func = func;
	if self.func != undefined {
        self.func = method({test: this}, self.func);
		var n = script_get_name(self.func);
	    if string_starts_with(n, Kengine.constants.TEST_FUNCTION_PREFIX)
            or string_starts_with(n, "gml_Script_" + Kengine.constants.TEST_FUNCTION_PREFIX) {
                r = true;
		}
    }
    
    /**
     * @function step_func
     * @memberof Kengine.tests.Test
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
            self.name = Kengine.utils.structs.exists(r, "name") ? Kengine.utils.structs.get(r, "name") : self.name;
            self.fixtures = Kengine.utils.structs.exists(r, "fixtures") ? Kengine.utils.structs.get(r, "fixtures") : self.fixtures;
            self.func = Kengine.utils.structs.exists(r, "func") ? method({test: this}, Kengine.utils.structs.get(r, "func")) : self.func;
            self.step_func = Kengine.utils.structs.exists(r, "step_func") ? method({test: this}, Kengine.utils.structs.get(r, "step_func")) : self.step_func;
        } else {
            throw Kengine.utils.errors.create(Kengine.utils.errors.types.tests__test__func_invalid_return, string("Test \"{0}\" function did not return a struct.", self.name));
        }
    }

    Kengine.utils.events.fire("tests__test__init__after", {test: this});
}

/**
 * @function TestManager
 * @memberof Kengine.tests
 * @constructor
 * @description A test manager is a singleton that is created if `Kengine.tests.is_testing` is `true`.
 * It finds tests and does them one by one.
 * 
 */
Kengine.tests.DefaultTestManager = function() constructor {
	var this = self;

    self._console_tag = "Kengine: Tests: ";
    self.testing_tests = [];
    // self.available_tests = tests;

    self.reports = undefined;
    self.step_enabled = true;

    self.find_tests = function() {
        var fs = {};
        var founds = Kengine.asset_types.script.assets.filter(function (val) {
            return string_starts_with(val.name, Kengine.constants.TEST_FUNCTION_PREFIX)
                or string_starts_with(val.name, "gml_Script_" + Kengine.constants.TEST_FUNCTION_PREFIX);
        });
        var scr;
        for (var i=0; i<array_length(founds); i++) {
            fs[$ founds[i].name] = new Kengine.tests.Test(
                founds[i].name, undefined, founds[i].id,
            );
        }
        self.available_tests = fs;
        return fs;
    }

    self.test = method({this}, function() {
        var test, test_name, _at = struct_get_names(this.available_tests);
		array_sort(_at, true);
        this.reports = {};
        for (var i=0; i<array_length(_at); i++) {
            test_name = _at[i];
            test = this.available_tests[$ test_name];
            test.__console_msg_data = undefined;
            if Kengine.conf.console_enabled {
                test.__console_msg_data = {
                    msg: Kengine.console.echo_ext(this._console_tag + test_name, c_dkgray),
                    fmt: this._console_tag + test_name + ": " + "%status%" + " " + "%dots%  %error%",
                };
            }
            Kengine.utils.structs.set(this.reports, test.name, {
                _status: "SETUP",
            });
            test.test();
        }
    })

    self.step = method({this}, function() {
        var test, status, report;
        if array_length(this.testing_tests) == 0 {
            if this.reports != undefined { // Done test() at least once.
                this.save_reports();
                this.step_enabled = false;
            }
        }
        for (var i=0; i<array_length(this.testing_tests); i++) {
            test = this.testing_tests[i];
            report = Kengine.utils.structs.get(this.reports, test.name);
            status = method({this: test}, test.proceed)();
            if status == 2 { // removes it already from array if 2
                if Kengine.utils.structs.exists(test.result, "assertions") {report.assertions = test.result.assertions;};
                if Kengine.utils.structs.exists(test.result, "success") {report.success = test.result.success;};
                if Kengine.utils.structs.exists(test.result, "error") {report.error = test.result.error;};
                if Kengine.utils.structs.exists(test.result, "output") {report.output = test.result.output;};

                if report.success {
                    report._status = "SUCCESS";
                } else {
                    report._status = "FAIL";
                }

            } else {
                report._status = "PROGRESS";
            }

            // Update console.
            if Kengine.conf.console_enabled {
                var _st = undefined; var __st = undefined; var _c = c_dkgray;
                __st = (report._status == "SUCCESS") ? "S" : ((report._status == "FAIL") ? "F" : "P");
                if __st == "P" {
                    _st = Kengine.utils.ascii.get_braille_dot();
                    _c = c_yellow;
                } else if __st == "S" {
                    _st = __st; //"✔"
                    _c = c_lime;
                } else if __st == "F" {
                    _st = "X"; // __st // "✘"
                    _c = c_red;
                } else {
                    _st = __st;
                }

                test.__console_msg_data.ind = array_find_index(Kengine.console.texts, method({test, this}, function(_element, _index){
					return string_starts_with(_element, this._console_tag + test.name);
				}));
				if test.__console_msg_data.ind != -1 {
	                test.__console_msg_data.msg = test.__console_msg_data.fmt;
	                test.__console_msg_data.msg = string_replace_all(test.__console_msg_data.msg, "%status%", _st);
	                test.__console_msg_data.msg = string_replace_all(test.__console_msg_data.msg, "%dots%", string_repeat(".", (Kengine.utils.structs.get(test.result, "assertions") ?? (Kengine.utils.structs.get(report, "assertions") ?? 0))));
					test.__console_msg_data.msg = string_replace_all(test.__console_msg_data.msg, "%error%", (Kengine.utils.structs.get(test.result, "error") != undefined ? (is_string(test.result.error) ? test.result.error : (Kengine.utils.structs.get(test.result.error, "longMessage") ?? "")) : ""));
	                Kengine.console.texts[test.__console_msg_data.ind] = test.__console_msg_data.msg;
	                Kengine.console.texts_color[test.__console_msg_data.ind] = _c;
				}
            }
        }
    });

    self.save_reports = function() {
        var _rnames = struct_get_names(self.reports);
        var s = $"{array_length(_rnames)} tests passed ✔";
        var c = c_lime;
        var fails = 0;
        for (var i=0; i<array_length(_rnames); i++) {
            if not self.reports[$ _rnames[i]].success {
                c = c_red;
                fails++;
            }
        }
        if c == c_red {
            s = $"{fails}/{array_length(_rnames)} tests failed ✘";
        }

        Kengine.console.echo_ext("Kengine: Tests: " + s, c, true, true);
    }
}

function ken_test_foo1_foo() {
    if not test.is_testing {
        var fixtures = [
			new Kengine.tests.Fixture("fixture01", function(){ show_debug_message("Fixture01 setup!")}, function(){ show_debug_message("Fixture01 cleanup!")}, ),
        ];
        return {fixtures};
    }

    test.assertEqual("hi", "hi");
    test.done();
}

function ken_test_foo1_bar() {
    if not test.is_testing {
        var fixtures = [
            new Kengine.tests.Fixture("fixture02", function(){ show_debug_message("Fixture02 setup!")}, function(){ show_debug_message("Fixture02 cleanup!")}, ),
        ];
        return {fixtures};
    }

    test.assertEqual("hi", "hi");
    test.assertEqual("hi", "hi");
    test.done();
    // test.done();
}

function ken_test_foo1_baz() {
    if not test.is_testing {
        test.foo1baz = 0;
        test.step_func = test.func;
        return {};
    }

    if test.foo1baz > 100 {
        test.done();
    } else {
        // test.assertEqual(3, test.foo1baz); fails the test.
        test.foo1baz ++;
        if test.foo1baz mod 10 == 1{
            test.assertEqual(true, true);
        }
    }
}


function ken_init_ext_tests() {

	/**
	 * @member {String} tests__test__func_invalid_return
	 * @memberof Kengine.utils.errors.types
	 * @description Test function did not return a struct.
	 */
	Kengine.utils.errors.types.tests__test__func_invalid_return = "Test function did not return a struct.";

	/**
	 * @member {String} tests__fixture__does_not_exist
	 * @memberof Kengine.utils.errors.types
	 * @description Test fixture does not exist.
	 */
	Kengine.utils.errors.types.tests__fixture__does_not_exist = "Test fixture does not exist.";

	/**
	 * @member {String} tests__assertion__is_not
	 * @memberof Kengine.utils.errors.types
	 * @description Assertion failure.
	 */
	Kengine.utils.errors.types.tests__assertion__is_not = "Assertion failure.";

	/**
	 * @event tests__test__init__before
	 * @type {Array<Function>}
	 * @description An event that fires before initializing a Kengine Test.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {test}`.
	 *
	 * `event`: The event.
	 *
	 * `test`: The {@link Kengine.tests.Test} being constructed.
	 *
	 */
    Kengine.utils.events.define("tests__test__init__before");

    /**
	 * @event tests__test__init__after
	 * @type {Array<Function>}
	 * @description An event that fires after initializing a Kengine Test.
	 * If you have replaced the class, you need to reimplement this event.
	 *
	 * Functions accept two arguments, the second is a struct: `event, {test}`.
	 *
	 * `event`: The event.
	 *
	 * `test`: The {@link Kengine.tests.Test} being constructed.
	 *
	 */
    Kengine.utils.events.define("tests__test__init__after");

	Kengine.tests.Test = Kengine.utils.structs.set_default(Kengine.conf.exts.tests, "test_class", Kengine.tests.DefaultTest);
	Kengine.tests.Fixture = Kengine.utils.structs.set_default(Kengine.conf.exts.tests, "fixture_class", Kengine.tests.DefaultFixture);
	Kengine.tests.AssertionError = Kengine.utils.structs.set_default(Kengine.conf.exts.tests, "assertion_error_class", Kengine.tests.DefaultAssertionError);
	Kengine.tests.TestManager = Kengine.utils.structs.set_default(Kengine.conf.exts.tests, "test_manager_class", Kengine.tests.DefaultTestManager);

    Kengine.tests.test_manager = undefined;
    if Kengine.conf.testing {
        Kengine.tests.test_manager = new Kengine.tests.TestManager({

        });
        Kengine.tests.test_manager.find_tests();
        Kengine.tests.test_manager.test();

    } else {
        Kengine.tests = undefined;
    }
}
