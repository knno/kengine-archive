/**
 * @function AssertionError
 * @new_name Kengine.Extensions.Tests.AssertionError
 * @memberof Kengine.Extensions.Tests
 * @param {Struct} error The main causing error struct.
 * @param {String} [message] A message for the assertion. Defaults to that of `error` param.
 * @param {String} [longMessage] A long message for the assertion. Defaults to that of `error` param.
 * @description An AssertionError is thrown by a test function.
 * 
 * @example
 * var assertion_error = new Kengine.Extensions.Tests.AssertionError(
 *     Kengine.Utils.Errors.Create(
 *         "myext__foo__does_not_exist",
 *         string("Foo \"{0}\" does not exist.", foo.name)
 * )));
 * 
 */
function __KengineTestsAssertionError(error, message=undefined, longMessage=undefined) constructor {

    /**
     * @name error
     * @type {Struct}
     * @memberof Kengine.Extensions.Tests.AssertionError
     * @description The main causing error struct.
     * 
     */
    self.error = error;

    /**
     * @name message
     * @type {String}
     * @memberof Kengine.Extensions.Tests.AssertionError
     * @description A message for the assertion. Defaults to that of `error`.
     * 
     */
    self.message = message ?? error.message;

    /**
     * @name longMessage
     * @type {String}
     * @memberof Kengine.Extensions.Tests.AssertionError
     * @description A long message for the assertion. Defaults to that of `error`.
     *
     */
    self.longMessage = longMessage ?? error.longMessage;

}
