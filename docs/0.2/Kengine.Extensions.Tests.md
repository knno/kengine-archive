<!-- a name="Kengine.Extensions.Tests"></a -->

# Tests  :id=kengine-extensions-tests

[Kengine.Extensions.Tests](Kengine.Extensions.Tests) <code>object</code>
Kengine's Tests extension</p>
<p>Note - Disabling copy on write behavior for arrays is required.


<!-- a name="Kengine.Extensions.Tests.AssertionError"></a -->

## AssertionError  :id=kengine-extensions-tests-assertionerror

`Kengine.Extensions.Tests.AssertionError(error, [message], [longMessage])`
<!-- tabs:start -->


##### **Description**

An AssertionError is thrown by a test function.



| Param | Type | Description |
| --- | --- | --- |
| error | <code>Struct</code> | <p>The main causing error struct.</p> |
| [message] | <code>String</code> | <p>A message for the assertion. Defaults to that of <code>error</code> param.</p> |
| [longMessage] | <code>String</code> | <p>A long message for the assertion. Defaults to that of <code>error</code> param.</p> |


##### **Example**

```gml
var assertion_error = new Kengine.Extensions.Tests.AssertionError(    Kengine.Utils.Errors.Create(        "myext__foo__does_not_exist",        string("Foo \"{0}\" does not exist.", foo.name))));
```
<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.AssertionError.error"></a -->

### error  :id=kengine-extensions-tests-assertionerror-error

[Kengine.Extensions.Tests.AssertionError.error](Kengine.Extensions.Tests?id=kengine.extensions.tests.assertionerror.error) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

The main causing error struct.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.AssertionError.message"></a -->

### message  :id=kengine-extensions-tests-assertionerror-message

[Kengine.Extensions.Tests.AssertionError.message](Kengine.Extensions.Tests?id=kengine.extensions.tests.assertionerror.message) <code>String</code>
<!-- tabs:start -->


##### **Description**

A message for the assertion. Defaults to that of <code>error</code>.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.AssertionError.longMessage"></a -->

### longMessage  :id=kengine-extensions-tests-assertionerror-longmessage

[Kengine.Extensions.Tests.AssertionError.longMessage](Kengine.Extensions.Tests?id=kengine.extensions.tests.assertionerror.longmessage) <code>String</code>
<!-- tabs:start -->


##### **Description**

A long message for the assertion. Defaults to that of <code>error</code>.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Fixture"></a -->

## Fixture  :id=kengine-extensions-tests-fixture

`Kengine.Extensions.Tests.Fixture(name, _func_setup, _func_cleanup)`
<!-- tabs:start -->


##### **Description**

A fixture is a struct that contains <code>name</code>, and <code>func_setup</code> and <code>func_cleanup</code> functions.



| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | <p>The name of the fixture.</p> |
| _func_setup | <code>function</code> | <p>The function of the fixture that setups the test.</p> |
| _func_cleanup | <code>function</code> | <p>The function of the fixture that cleans up the test.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Fixture.name"></a -->

### name  :id=kengine-extensions-tests-fixture-name

[Kengine.Extensions.Tests.Fixture.name](Kengine.Extensions.Tests?id=kengine.extensions.tests.fixture.name) <code>String</code>
<!-- tabs:start -->


##### **Description**

The name of the fixture.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Fixture._testing_tests"></a -->

### _testing_tests  :id=kengine-extensions-tests-fixture-_testing_tests

[Kengine.Extensions.Tests.Fixture._testing_tests](Kengine.Extensions.Tests?id=kengine.extensions.tests.fixture._testing_tests) [<code>Array.&lt;Test&gt;</code>](Kengine.Extensions.Tests?id=kengine.extensions.tests.test)
<!-- tabs:start -->


##### **Description**

A list of tests that are running and dependent on this fixture.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Fixture.is_applied"></a -->

### is_applied  :id=kengine-extensions-tests-fixture-is_applied

[Kengine.Extensions.Tests.Fixture.is_applied](Kengine.Extensions.Tests?id=kengine.extensions.tests.fixture.is_applied) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether fixture is applied (active) or not.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Fixture.func_setup"></a -->

### func_setup  :id=kengine-extensions-tests-fixture-func_setup

`Kengine.Extensions.Tests.Fixture.func_setup()`
<!-- tabs:start -->


##### **Description**

The function of the fixture that setups the test.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Fixture.func_cleanup"></a -->

### func_cleanup  :id=kengine-extensions-tests-fixture-func_cleanup

`Kengine.Extensions.Tests.Fixture.func_cleanup()`
<!-- tabs:start -->


##### **Description**

The function of the fixture that cleans up the test.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Fixture.setup"></a -->

### setup  :id=kengine-extensions-tests-fixture-setup

`Kengine.Extensions.Tests.Fixture.setup([args])`
<!-- tabs:start -->


##### **Description**

A function that sets up the fixture data.



| Param | Type | Description |
| --- | --- | --- |
| [args] | <code>Struct</code> \| <code>Undefined</code> | <p>A struct containing <code>{test}</code>.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Fixture.cleanup"></a -->

### cleanup  :id=kengine-extensions-tests-fixture-cleanup

`Kengine.Extensions.Tests.Fixture.cleanup([args])`
<!-- tabs:start -->


##### **Description**

A function that cleans up the fixture data. This is done when there are no dependents tests running.



| Param | Type | Description |
| --- | --- | --- |
| [args] | <code>Struct</code> \| <code>Undefined</code> | <p>A struct containing <code>{test}</code>.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test"></a -->

## Test  :id=kengine-extensions-tests-test

`Kengine.Extensions.Tests.Test(name, fixtures, func, step_func)`
<!-- tabs:start -->


##### **Description**

A test is a simple function wrapper that requires fixtures to be applied before calling, and cleaned after its done.



| Param | Type | Description |
| --- | --- | --- |
| name | <code>String</code> | <p>The name of the test. Defaults to found function's name.</p> |
| fixtures | <code>Array.&lt;String&gt;</code> \| [<code>Array.&lt;Fixture&gt;</code>](Kengine.Extensions.Tests?id=kengine.extensions.tests.fixture) \| <code>Array.&lt;Struct&gt;</code> | <p>An array of fixtures or fixture names or structs containing <code>{name, func_setup, func_cleanup}</code>. They will be resolved upon testing.</p> |
| func | <code>function</code> | <p>The main function of the test. Defaults to the found function.</p> |
| step_func | <code>function</code> | <p>A function to use for each step during the test. If it equals <code>&quot;func&quot;</code>, it is set to the same <code>func</code>. Defaults to <code>undefined</code>.</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.name"></a -->

### name  :id=kengine-extensions-tests-test-name

[Kengine.Extensions.Tests.Test.name](Kengine.Extensions.Tests?id=kengine.extensions.tests.test.name) <code>String</code>
<!-- tabs:start -->


##### **Description**

The name of the test.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.fixtures"></a -->

### fixtures  :id=kengine-extensions-tests-test-fixtures

[Kengine.Extensions.Tests.Test.fixtures](Kengine.Extensions.Tests?id=kengine.extensions.tests.test.fixtures) [<code>Array.&lt;Fixture&gt;</code>](Kengine.Extensions.Tests?id=kengine.extensions.tests.fixture)
<!-- tabs:start -->


##### **Description**

An array of fixtures that are resolved upon testing.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.is_testing"></a -->

### is_testing  :id=kengine-extensions-tests-test-is_testing

[Kengine.Extensions.Tests.Test.is_testing](Kengine.Extensions.Tests?id=kengine.extensions.tests.test.is_testing) <code>Bool</code>
<!-- tabs:start -->


##### **Description**

Whether the test is being tested right now.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.ResolveFixtures"></a -->

### ResolveFixtures  :id=kengine-extensions-tests-test-resolvefixtures

`Kengine.Extensions.Tests.Test.ResolveFixtures` ⇒ [<code>Array.&lt;Fixture&gt;</code>](Kengine.Extensions.Tests?id=kengine.extensions.tests.fixture)
<!-- tabs:start -->


##### **Description**

Resolve the <code>fixtures</code> of the test. It is called inside the [Kengine.Extensions.Tests.Test.test](Kengine.Extensions.Tests?id=kengine.extensions.tests.test.test) function.


**Throws**:

- [<code>AssertionError</code>](Kengine.Extensions.Tests?id=kengine.extensions.tests.assertionerror) 

<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.func"></a -->

### func  :id=kengine-extensions-tests-test-func

[Kengine.Extensions.Tests.Test.func](Kengine.Extensions.Tests?id=kengine.extensions.tests.test.func) <code>function</code>
<!-- tabs:start -->


##### **Description**

The main provided function of the test. Defaults to the found function. If it's a function that begins with [KENGINE_TEST_FUNCTION_PREFIX](KENGINE_TEST_FUNCTION_PREFIX),
then it is called when initiating the test and again when the test actually takes place. You can differentiate that within the test function by the reference variable <code>test</code> which is the current test.



##### **Example**

```gml
function ken_test_foo() {    if test.is_testing {        return {fixtures: ...}    } else {        test.AssertEqual(1, 1);        test.Done();    };}
```
<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.Test"></a -->

### Test  :id=kengine-extensions-tests-test-test

`Kengine.Extensions.Tests.Test.Test()`
<!-- tabs:start -->


##### **Description**

The entry test function. Set the <code>results</code> struct on the test object.
Basically Run <code>func</code> and if there's any errors it calls <code>fail</code> otherwise it calls <code>success</code>.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.Fail"></a -->

### Fail  :id=kengine-extensions-tests-test-fail

`Kengine.Extensions.Tests.Test.Fail(error)`
<!-- tabs:start -->


##### **Description**

Fail test. Change the test result.



| Param | Type |
| --- | --- |
| error | <code>Any</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.Done"></a -->

### Done  :id=kengine-extensions-tests-test-done

`Kengine.Extensions.Tests.Test.Done(output)`
<!-- tabs:start -->


##### **Description**

A function to be called at the end of the test script.



| Param | Type |
| --- | --- |
| output | <code>Any</code> | 

<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.AssertEqual"></a -->

### AssertEqual  :id=kengine-extensions-tests-test-assertequal

`Kengine.Extensions.Tests.Test.AssertEqual(val1, val2)`
<!-- tabs:start -->


##### **Description**

asserts in the test that two values are equal.


**Throws**:

- [<code>AssertionError</code>](Kengine.Extensions.Tests?id=kengine.extensions.tests.assertionerror) 


| Param | Type | Description |
| --- | --- | --- |
| val1 | <code>Any</code> | <p>Value 1</p> |
| val2 | <code>Any</code> | <p>Value 2</p> |

<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.Test.step_func"></a -->

### step_func  :id=kengine-extensions-tests-test-step_func

`Kengine.Extensions.Tests.Test.step_func()`
<!-- tabs:start -->


##### **Description**

A function to use for each step during the test.


<!-- tabs:end -->

<!-- a name="Kengine.Extensions.Tests.TestManager"></a -->

## TestManager  :id=kengine-extensions-tests-testmanager

`Kengine.Extensions.Tests.TestManager()`
<!-- tabs:start -->


##### **Description**

A test manager is a singleton that is created if <code>Kengine.Extensions.Tests.is_testing</code> is <code>true</code>.
It finds tests and does them one by one.


<!-- tabs:end -->

