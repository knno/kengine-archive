// Testing phase
phase = 0;

// Testing Verbosity
verbose = Kengine.verbosity > 0;
if string_lower(environment_get_variable("KENGINE_TESTS_VERBOSE")) == "true" {
	verbose = true;
}
