// This is for CI/CD

if (Kengine.is_testing) {
	
	switch (phase) {
		case 0:
			Kengine.Utils.Events.AddListener("extensions__after", function(ev, ext_assets) {
				obj_control.phase = 1;
			});
			break;
			
		case 1:
			var extensions_status = Kengine.GetStatuses(KENGINE_STATUS_TYPE.EXTENSIONS);
			var i = array_find_index(extensions_status, function(ele) { return ele[0] == "Tests"; });
			if i > -1 {
				var tests_extension_status = extensions_status[i][1];
				if tests_extension_status == "READY" {
					Kengine.Utils.Events.AddListener("tests__tests_complete", function(ev, results) {
						var report, names;

						if (results.status == "SUCCESS") {
							__kengine_log("Testing was successful!");
							names = struct_get_names(results.reports);
							if verbose {
								for (var j=0; j<array_length(names); j++) {
									report = results.reports[$ names[j]];
									var stdout = __KengineStructUtils.Get(report, "output") ?? undefined;
									var stderr = __KengineStructUtils.Get(report, "error") ?? undefined;
									__kengine_log($"{names[j]}: " + string(__KengineStructUtils.Get(report, "success") ? "SUCCESS" : "FAILURE"));
									__kengine_log($"{names[j]}: " + string(__KengineStructUtils.Get(report, "assertions") ?? 0) + " assertions");
									if ! is_undefined(stdout) {
										__kengine_log($"{names[j]}: Output: " + string(stdout));
									}
									if ! is_undefined(stderr) {
										__kengine_log($"{names[j]}: Error: " + string(stderr));
									}
								}
							}
							__kengine_log($"{results.total} tests passed ✔");

						} else {
							__kengine_log("Testing has failed!");
							names = struct_get_names(results.reports);
							for (var j=0; j<array_length(names); j++) {
								report = results.reports[$ names[j]];
								var stdout = __KengineStructUtils.Get(report, "output") ?? undefined;
								var stderr = __KengineStructUtils.Get(report, "error") ?? undefined;
								__kengine_log($"{names[j]}: " + string(__KengineStructUtils.Get(report, "success") ? "SUCCESS" : "FAILURE"));
								__kengine_log($"{names[j]}: " + string(__KengineStructUtils.Get(report, "assertions") ?? 0) + " assertions");
								if ! is_undefined(stdout) {
									__kengine_log($"{names[j]}: Output: " + string(stdout));
								}
								if ! is_undefined(stderr) {
									__kengine_log($"{names[j]}: Error: " + string(stderr));
								}
							}
							__kengine_log($"{results.fails}/{results.total} tests failed ✘");
						}
						game_end(results.status == "SUCCESS" ? 0 : 1); // GAME RETURN CODE
					});
					obj_control.phase = 2;
				}
			}
			break;
	}	
}
