/**
 * @function Fixture
 * @memberof Kengine.Extensions.Tests
 * @description A fixture is a struct that contains `name`, and `func_setup` and `func_cleanup` functions.
 * @param {String} name The name of the fixture.
 * @param {Function} _func_setup The function of the fixture that setups the test.
 * @param {Function} _func_cleanup The function of the fixture that cleans up the test.
 *
 */
function __KengineTestsFixture(name, _func_setup, _func_cleanup) constructor {

    /**
     * @name name
     * @type {String}
     * @memberof Kengine.Extensions.Tests.Fixture
     * @description The name of the fixture.
     *
     */
    self.name = name;

    var _fixtures = __KengineTests.fixtures;
    for (var i=0; i<array_length(_fixtures); i++) {
        if _fixtures[i].name == name {
            throw __KengineErrorUtils.Create(__KengineErrorUtils.Types.tests__fixture__exists, string("Fixture \"{0}\" already defined.", name));
        }
    }

    /**
     * @name _testing_tests
     * @type {Array<Kengine.Extensions.Tests.Test>}
     * @memberof Kengine.Extensions.Tests.Fixture
     * @description A list of tests that are running and dependent on this fixture.
     * 
     */
    self._testing_tests = [];

    /**
     * @function func_setup
     * @memberof Kengine.Extensions.Tests.Fixture
     * @description The function of the fixture that setups the test.
     *
     */
    self.func_setup = _func_setup;

    /**
     * @function func_cleanup
     * @memberof Kengine.Extensions.Tests.Fixture
     * @description The function of the fixture that cleans up the test.
     *
     */
    self.func_cleanup = _func_cleanup;

    /**
     * @name is_applied
     * @type {Bool}
     * @memberof Kengine.Extensions.Tests.Fixture
     * @description Whether fixture is applied (active) or not.
     *
     */
    self.is_applied = false;

    /**
     * @function setup
     * @memberof Kengine.Extensions.Tests.Fixture
     * @description A function that sets up the fixture data.
     * @param {Struct|Undefined} [args] A struct containing `{test}`.
     *
     */
    self.Setup = function(args=undefined) {
        if not self.is_applied {
            method({test_manager: Kengine.Extensions.Tests.test_manager}, self.func_setup)();
            self.is_applied = true;
            array_push(self._testing_tests, args.test);
        }
    };

    /**
     * @function cleanup
     * @memberof Kengine.Extensions.Tests.Fixture
     * @description A function that cleans up the fixture data. This is done when there are no dependents tests running.
     * @param {Struct|Undefined} [args] A struct containing `{test}`.
     *
     */
    self.Cleanup = function(args=undefined) {
        if self.is_applied {
            array_delete(self._testing_tests, array_get_index(self._testing_tests, args.test), 1);
            if array_length(self._testing_tests) == 0 {
	            method({test_manager: Kengine.Extensions.Tests.test_manager}, self.func_cleanup)();
                self.is_applied = false;
            }
        }
    };

    _fixtures = __KengineTests.fixtures; _fixtures[array_length(_fixtures)] = self;
}
