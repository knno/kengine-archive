
/**
 * @function Collection
 * @memberof Kengine
 * @param {Array<Any>|Undefined} [array=undefined] The initial array to use.
 * @param {Function|Undefined} [defaultcmp=undefined] A default cmp to be used in functions such as get_ind.
 * @description A collection is a just an array with add, remove, get, and set functions.
 * When removing a value from the collection, the index of the value would be reused.
 *
 */
function __KengineCollection(array=undefined, defaultcmp=undefined) constructor {

	__all = array ?? [];
	__cmp = defaultcmp ?? __KengineCmpUtils.cmp_val1_val2;

	/**
	 * @function GetAll
	 * @memberof Kengine.Collection
	 * @description Return all values inside the collection.
	 * @return {Array<Any>|Any|Undefined}
	 */
	GetAll = function() { return __all;}

	/**
	 * @function Get
	 * @memberof Kengine.Collection
	 * @description Return value searched by collection index.
	 * @param {Real} ind The index of the value in the collection.
	 * @return {Any} The value held in the collection index.
	 */
	Get = function(ind) {
		return __all[ind];
	}

	/**
	 * @function GetInd
	 * @memberof Kengine.Collection
	 * @description Return index of the value in the collection.
	 * @param {Any} val The value in the collection to be searched for its collection index.
	 * @param {Function} [cmp] A `Function` that takes `val`, `val2`, where `val2` is from the collection to compare `val` with. Return `true` to match. Defaults to initial `defaulcmp`.
	 * @return {Real} The index of the value in the collection.
	 */
	GetInd = function(val, cmp=undefined) {
		cmp = cmp ?? __cmp;
		for (var i=0; i<array_length(__all); i++) {
			if __all[i] == undefined continue;
			if cmp(val, __all[i]) == true return i;
			if __all[i] == val return i;
		}
		return -1;
	}

	/**
	 * @function Exists
	 * @memberof Kengine.Collection
	 * @description Return whether value is already in the collection.
	 * @param {Any} val The value in the collection to be searched for.
	 * @param {Function} [cmp] A `Function` that takes `val`, `val2`, where `val2` is from the collection to compare `val` with. Return `true` to match. Defaults to initial `defaultcmp`.
	 * @return {Bool} Whether the value exists or not.
	 */
	Exists = function(val, cmp=undefined) {
		if GetInd(val, cmp) == -1 {
			return false;
		}
		return true;
	}

	/**
	 * @function Add
	 * @memberof Kengine.Collection
	 * @description Add the value to the collection.
	 * @param {Any} val The value to be added to the collection.
	 * @return {Real} The collection index of the added value.
	 */
	Add = function(val) {
		for (var i=0; i<array_length(__all); i++) {
			if __all[i] == undefined {__all[i] = val; return i;}
		}
		__all[array_length(__all)] = val;
		return array_length(__all) - 1;
	}

	/**
	 * @function AddOnce
	 * @memberof Kengine.Collection
	 * @description Add the value to the collection, only if it does not exist already.
	 * @param {Any} val The value to be added to the collection only if it does not exist already.
	 * @param {Function} [cmp] A `Function` that takes `val`, `val2`, where `val2` is from the collection to compare `val` with. Return `true` to match. Defaults to initial `defaultcmp`.
	 * @return {Real} The collection index of the value whether added or found.
	 */
	AddOnce = function(val, cmp=undefined) {
		var _ind = GetInd(val, cmp);
		if _ind == -1 return Add(val);
		return _ind;
	}

	/**
	 * @function Remove
	 * @memberof Kengine.Collection
	 * @description Remove the value from the collection.
	 * @param {Any} val The value to be removed from the collection.
	 * @param {Function} [cmp] A `Function` that takes `val`, `val2`, where `val2` is from the collection to compare `val` with. Return `true` to match. Defaults to initial `defaultcmp`.
	 * @return {Any} The removed value or undefined.
	 */
	Remove = function(val, cmp=undefined) {
		var ind = GetInd(val, cmp);
		if ind != -1 {
			return RemoveInd(ind);
		} else {
			return undefined;
		}
	}

	/**
	 * @function RemoveInd
	 * @memberof Kengine.Collection
	 * @description Remove a looked-up value by the provided index from the collection.
	 * @param {Real} ind The index which value is to be removed.
	 */
	RemoveInd = function(ind) {
		var _a = __all[ind];
		array_delete(__all, ind, 1);
		return _a;
	}

	/**
	 * @function Length
	 * @memberof Kengine.Collection
	 * @description Return length of the values in the collection.
	 * @return {Real} The length of the values in the collection.
	 *
	 */
	Length = function() {
		return array_length(__all);
	}
	 
	/**
	 * @function Filter
	 * @memberof Kengine.Collection
	 * @description Return a filtered array from the collection values.
	 * @param {Function} func A `Function` that takes `value`. Return `true` to take.
	 * @return {Array<Any>}
	 *
	 */
	Filter = function(func) {
		var _a = [];
		for (var i=0; i<array_length(__all); i++) {
			if func(__all[i]) == true {
				_a[array_length(_a)] = __all[i];
			};
		}
		return _a;
	}
	  
	 /**
	  * @function FilterSelf
	  * @memberof Kengine.Collection
	  * @description Return a filtered copy of self from the collection values.
	  * @param {Function} func A `Function` that takes `value`. Return `true` to take.
	  * @param {Bool} [return_array=false]
	  * @return {Kengine.Collection}
	  *
	  */
	FilterSelf = function(func) {
		return new __KengineCollection(Filter(func));
	}
}
