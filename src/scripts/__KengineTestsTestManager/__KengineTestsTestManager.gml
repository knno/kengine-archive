/**
 * @function TestManager
 * @memberof Kengine.Extensions.Tests
 * @description A test manager is a singleton that is created if `Kengine.Extensions.Tests.is_testing` is `true`.
 * It finds tests and does them one by one.
 * 
 */
function __KengineTestsTestManager() constructor {
	var this = self;

    self._console_tag = "Kengine: Tests: ";
    self.testing_tests = [];
    // self.available_tests = tests;

    static reports = undefined;
    self.step_enabled = true;

    static FindTests = function() {
        var fs = {};
        var founds = Kengine.asset_types.script.assets.Filter(function (val) {
            return string_starts_with(val.name, KENGINE_TEST_FUNCTION_PREFIX)
                or string_starts_with(val.name, "gml_Script_" + KENGINE_TEST_FUNCTION_PREFIX);
        });
        var scr;
        for (var i=0; i<array_length(founds); i++) {
            fs[$ founds[i].name] = new __KengineTestsTest(
                founds[i].name, undefined, founds[i].id,
            );
        }
        self.available_tests = fs;
        return fs;
    }

    static Test = function() {
		var _tests = [];

        reports = {};

        var _test;
        var _test_name;
        var  _at = struct_get_names(self.available_tests);
        array_sort(_at, true);

        for (var i=0; i<array_length(_at); i++) {
            _test_name = _at[i];
            _test = self.available_tests[$ _test_name];
            _test.__console_msg_data = undefined;
            if KENGINE_CONSOLE_ENABLED {
                _test.__console_msg_data = {
                    msg: Kengine.console.echo_ext(self._console_tag + _test_name, c_dkgray),
                    fmt: self._console_tag + _test_name + ": " + "%status%" + " " + "%dots%  %error%",
                };
            }
            __KengineStructUtils.Set(reports, _test.name, {
                _status: "SETUP",
				success: undefined,
            });
            array_push(_tests, _test.test);
        }

        self.tests_coroutine = new __KengineCoroutine("all-tests", _tests);
        self.tests_coroutine.__owner = self;
        self.tests_coroutine.Start();
		return self.tests_coroutine;
    }

    Step = method({this}, function() {
        var test, status, report;

		if array_length(this.testing_tests) == 0 {
            if this.reports != undefined { // Done test() at least once.
				var _f = 0;
				var _rs = struct_get_names(this.reports);
				for (var i=0; i<array_length(_rs); i++) {
					if (this.reports[$ _rs[i]]._status == "PROGRESS") continue;
					if (this.reports[$ _rs[i]]._status == "SUCCESS") _f ++;
					if (this.reports[$ _rs[i]]._status == "FAILURE") _f ++;
										
					if _f == array_length(_rs) {
						_f = true;
					}
				}
				if _f == true {
	                this.SaveReports(this);
	                this.step_enabled = false;
				}
            }
        }
        for (var i=0; i<array_length(this.testing_tests); i++) {
            test = this.testing_tests[i];
            report = __KengineStructUtils.Get(this.reports, test.name);
            status = method({this: test}, test.Proceed)();
            if status == 2 { // removes it already from array if 2
                if __KengineStructUtils.Exists(test.result, "assertions") {report.assertions = test.result.assertions;} else {report.assertions = undefined;};
                if __KengineStructUtils.Exists(test.result, "success") {report.success = test.result.success;} else {report.success = undefined;};
                if __KengineStructUtils.Exists(test.result, "error") {report.error = test.result.error;} else {report.error = undefined;};
                if __KengineStructUtils.Exists(test.result, "output") {report.output = test.result.output;} else {report.output = undefined;};

                if report.success {
                    report._status = "SUCCESS";
                } else {
                    report._status = "FAILURE";
                }

            } else {
                report._status = "PROGRESS";
            }

            // Update console.
            if KENGINE_CONSOLE_ENABLED {
                var _st = undefined; var __st = undefined; var _c = c_dkgray;
                __st = (report._status == "SUCCESS") ? "S" : ((report._status == "FAILURE") ? "F" : "P");
                if __st == "P" {
                    _st = Kengine.Utils.Ascii.__GetBrailleDot();
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
	                test.__console_msg_data.msg = string_replace_all(test.__console_msg_data.msg, "%dots%", string_repeat(".", (__KengineStructUtils.Get(test.result, "assertions") ?? (__KengineStructUtils.Get(report, "assertions") ?? 0))));
					test.__console_msg_data.msg = string_replace_all(test.__console_msg_data.msg, "%error%", (__KengineStructUtils.Get(test.result, "error") != undefined ? (is_string(test.result.error) ? test.result.error : (__KengineStructUtils.Get(test.result.error, "longMessage") ?? "")) : ""));
	                Kengine.console.texts[test.__console_msg_data.ind] = test.__console_msg_data.msg;
	                Kengine.console.texts_color[test.__console_msg_data.ind] = _c;
				}
            }
        }
    });

    static SaveReports = function(this) {
        var _rnames = struct_get_names(self.reports);
		var total = array_length(_rnames);
        var s = $"{total} tests passed ✔";
        var c = c_lime;
        var fails = 0;
		var status = "SUCCESS";
        for (var i=0; i<total; i++) {
            if not self.reports[$ _rnames[i]].success {
                c = c_red;
                fails++;
            }
        }
        if c == c_red {
			status = "FAILURE";
            s = $"{fails}/{total} tests failed ✘";
        }

        Kengine.console.echo_ext("Kengine: Tests: " + s, c, true, true);
		Kengine.Utils.Events.Fire("tests__tests_complete", {
			reports: self.reports,
			status,
			fails,
			total,
		})
    }
}
