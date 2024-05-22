/**
 * @namespace Benchmark
 * @memberof Kengine.Utils
 * @description A struct containing Kengine benchmark utilitiy functions
 *
 */
function __KengineBenchmarkUtils() : __KengineStruct() constructor {

	static __gameInitTimer = get_timer() // Game init
	static __kengineInitTimer = get_timer() // Kengine init

    static __slot0Timer = get_timer();
    static __slot1Timer = get_timer(); // Asset Indexing (all)
    static __slot2Timer = get_timer(); // Asset Indexing (per AssetType)
    static __slot3Timer = get_timer(); // Extensions.
    static __slot4Timer = get_timer(); // Per-extension.
    static __slot5Timer = get_timer();

    static Init = function() {
        __kengineInitTimer = get_timer();
    }

	static CalcTimerDiff = function(timer) {
		var _diff = -1;
        var _timer = get_timer();
        switch (timer) {
            case "Kengine": _diff = _timer - __kengineInitTimer; __kengineInitTimer = _timer; break;
            case "game": _diff = _timer - __gameInitTimer; __gameInitTimer = _timer; break;
            case "slot0": case 0: _diff = _timer - __slot0Timer; __slot0Timer = _timer; break;
            case "slot1": case 1: _diff = _timer - __slot1Timer; __slot1Timer = _timer; break;
            case "slot2": case 2: _diff = _timer - __slot2Timer; __slot2Timer = _timer; break;
            case "slot3": case 3: _diff = _timer - __slot3Timer; __slot3Timer = _timer; break;
            case "slot4": case 4: _diff = _timer - __slot4Timer; __slot4Timer = _timer; break;
            case "slot5": case 5: _diff = _timer - __slot5Timer; __slot5Timer = _timer; break;
        }
		return _diff;
	}

    static Mark = function(message=undefined, timer=undefined, show_diff=true) {
        if not (KENGINE_BENCHMARK) return;

		var _diff = CalcTimerDiff(timer);

        var _time_message = "";
        if show_diff {
            if _diff >= 0 {
                _time_message = " - " + string(_diff/1000) + "ms";
            }
        }
		// __kengine_log("[Benchmark] "+string(message) + _time_message);
        Kengine.console.verbose("Kengine: Benchmark: " + string(message) + _time_message, 1);
    }
}
