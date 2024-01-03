/**
 * @function string_find_pos
 * @description	Find position of the next string that is after sep from pos.
 * @param {String} text The main text.
 * @param {String} sep The separation of text words.
 * @param {Real} [dir=1] The direction to look.
 * @param {Real} [pos=0] The position to start.
 * @memberof Kengine.fn.strings
 * @return {Real} The position of the first occurence of a word.
 *
 */
function string_find_pos(text, sep, dir=1, pos=0) {
	var i, j;
	j = string_length(text);
	if (dir == 1) { 
		for (i = min(j, pos); i>= 1; i--)
			{
			if (string_char_at(text, i) == sep)
				{
				if (i==1)
					{
					return i;
					}
				else
					{
					if (string_char_at(text, i-1) != sep)
						{
						return i;
						}
					}
				}
			}
		return 0;
	} else {
		for (i = pos; i<=j; i++) {
			if (string_char_at(text, i) == sep)
				{
				if (i == j)
					{
					return i;
					}
				else
					{
					if (string_char_at(text, i+1) != sep)
						{
						return i-1;
						}
					}
				}
			}
		return j;
	}
}
