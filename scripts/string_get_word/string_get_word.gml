/**
 * @function string_get_word
 * @description	Return word from text by index. First word index is 1, If zero is provided, return word count instead.
 * @param {String} text The string to get a word or count of words from.
 * @param {Real} index The index of the word in the string. Use 0 to return word count.
 * @memberof Kengine.fn.strings
 * @return {String|Real}
 *
 */
function string_get_word(text, index, delim=" ") {
	var result, word, i;
	result = string(text);
	i = 0;
	do {
		if string_count(delim,result) then{
			word = string_copy(result,1,string_pos(delim,result)-1);
			result = string_delete(result,1,string_pos(delim,result));
		} else {
			word = result;
			result = "";
		}
		i+=1;
		if index!=0 then if index==i then return word;
	} until (result=="");

	if index==0 then return i else return word;
}
