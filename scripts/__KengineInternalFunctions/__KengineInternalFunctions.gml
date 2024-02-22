/**
 * @function __kengine_log
 * @memberof Kengine
 * @description Basic Kengine log function.
 * @private
 * @param {Any} _message
 */
function __kengine_log(_message) {
	show_debug_message($"[Kengine] {_message}.");
}

/**
 * @function __kengine_do_ev
 * @memberof Kengine
 * @private
 * @param {Struct} ev 
 * @param {Real} ev_arg
 * @description takes {wrapper} as method struct.
 * 
 */
function __kengine_do_ev(ev, ev_arg) {
	var scr = "";
	if not variable_instance_exists(self, "wrapper") exit;
	Kengine.utils.structs.set_default(wrapper.asset, "event_scripts", {});
	scr = Kengine.utils.structs.get(wrapper.asset.event_scripts, ev);
	if scr != undefined {
		if is_instanceof(scr, Kengine.Asset) {
			return Kengine.utils.parser.interpret_asset(scr, wrapper, {wrapper, event: ev.name, event_arg: ev_arg, script_object: wrapper,});
		} else if is_method(scr) {
			return method({wrapper, event: ev.name, event_arg: ev_arg, script_object: wrapper}, scr)();
		} else if is_string(scr) {
			switch scr {
				case "@draw_self": draw_self(); return;
			}
		}
	}
}

/**
 * @function __kengine_load_room_file
 * @memberof Kengine
 * @private
 * @description Load a room file into a struct that looks like room_get_info. With additional `_ken_` data.
 * @param {String} path Path to the file containing the data.
 * @param {String} [kind="json"] The format to parse. "json", "tmx", "yy".
 * @return {Any}
 * 
 */
function __kengine_load_room_file(path, kind="json") {

	var data = undefined;

	switch (kind) {
		case "json":
			var txt = __kengine_load_txt_file(path);
			data = json_parse(txt);
			break;

		case "tmx":
			// TODO: Load TMX files.
			data = undefined;
			break;

		case "yy":
			// TODO: Load YY files.
			data = undefined;
			break;
	};

	return data;
}


/**
 * @function __kengine_load_txt_file
 * @memberof Kengine
 * @private
 * @param {String} path
 * @description Load file contents as text.
 * @return {String|Undefined} The content.
 */
function __kengine_load_txt_file(path) {
	if !file_exists(path) {
		return undefined;
	}
	var f = file_text_open_read(path);
	var t = ""
	while !(file_text_eof(f)) {
		t = t + file_text_read_string(f) + "\n";
		file_text_readln(f);
	}
	file_text_close(f);
	return t;
}

/**
 * @function __kengine_load_sound
 * @memberof Kengine
 * @private
 * @param {String} path
 * @param {String} [name="undefined"]
 * @param {Bool} [is3D=false]
 * @description Load sound file to audio.
 * @return {Real} The audio ID.
 */
function __kengine_load_sound(path, name="undefined", is3D=false) {
	if !file_exists(path) {
		throw {
			message: "Asset file not found.",
			longMessage: "The asset file for \"" + name + "\" was not loaded. Path \"" + path + "\" does not exist.",
			stacktrace: debug_get_callstack(),
			error_source: "kengine",
			error_id: 6,
		};
	}
	var _buff = buffer_load(path);
	var _size = buffer_get_size(_buff);
	var buffer = buffer_create(_size, buffer_fixed, 1);
	buffer_copy(_buff, buffer_tell(_buff), _size, buffer, 0);
	var _id = __kengine_sound_wavbuffer_to_audio(buffer, name, is3D);
	//buffer_delete(buffer);
	return _id;
}

/**
 * @function __kengine_sound_wavbuffer_to_audio
 * @memberof Kengine
 * @private
 * @param {Id.Buffer} _buff The buffer to create sound from.
 * @param {String} [name="undefined"] The name of the sound asset (for debugging).
 * @param {Bool} [_is3D=false] Whether sound is 3D or not.
 * @description Load WAV buffer to audio for an asset with a name.
 *
 */
function __kengine_sound_wavbuffer_to_audio(_buff, name = "undefined", _is3D = false) {
	var _header = 42;
	
	buffer_seek(_buff, buffer_seek_start, 0);

	// Check RIFF header
	var _chunkID = buffer_peek(_buff, 0, buffer_u32)
	if (_chunkID != 0x46464952) {
		throw {
			message: "Sound asset is not WAV.",
			longMessage: "The sound asset file \"" + name + "\" was not loaded. Chunk ID is not RIFF.",
			stacktrace: debug_get_callstack(),
			error_source: "kengine",
			error_id: 8,
		};
	}
	
	var _signature = buffer_peek(_buff,8,buffer_u32);	
	
	if (_signature == 0x45564157) { // WAVE 

		if ((buffer_peek(_buff, 12, buffer_u8) == 0x66) && (buffer_peek(_buff, 13, buffer_u8) == 0x6D) && (buffer_peek(_buff, 14, buffer_u8) == 0x74)  && (buffer_peek(_buff, 15, buffer_u8) == 0x20)) { // fmt
			var _channel;
			if (_is3D == false) {
				switch(buffer_peek(_buff,22,buffer_u16)) {
						case 1: _channel = audio_mono; break;    
						case 2: _channel = audio_stereo; break;
						default: _channel = -1; break;
					}
			} else {
				_channel = audio_3D;
			}
				
			 var _rate = buffer_peek(_buff,24,buffer_u32);
			 var _bits_per_sample = buffer_peek(_buff,34,buffer_u16);
			 
			 // We're going to skip ahead and find data. As some wav files contain a LIST-INFO chunk.
			 var _i = 0;
			 while(buffer_peek(_buff, 36+_i, buffer_u32) != 0x61746164) {
					++_i; 
			 }
			 var _subchunksize = buffer_peek(_buff,40+_i,buffer_u32);
			
			switch(_bits_per_sample) {
				case 8: _bits_per_sample = buffer_u8; break;
				case 16: _bits_per_sample = buffer_s16; break;
				default: _bits_per_sample = undefined; break;
			}
			
			/// feather ignore GM1044
			if (_bits_per_sample == undefined) {
				throw {
					message: "Sound asset has invalid bits per sample. It can only support signed 8 or 16 bit.",
					longMessage: "The sound asset file \"" + name + "\" was not loaded. Invalid bits per sample. It can only support signed 8 or 16 bit.",
					stacktrace: debug_get_callstack(),
					error_source: "kengine",
					error_id: 9,
				};
				return -1;
			}
			var _soundID = audio_create_buffer_sound(_buff,_bits_per_sample,_rate,_header+_i+10, _subchunksize-10, _channel);
			return _soundID;
		} else {
			throw {
				message: "Sound asset has invalid fmt.",
				longMessage: "The sound asset file \"" + name + "\" was not loaded. Invalid fmt.",
				stacktrace: debug_get_callstack(),
				error_source: "kengine",
				error_id: 10,
			};
		}
	} else {
	    // Output error, and we return -1.
		throw {
			message: "Sound asset has invalid signature.",
			longMessage: "The sound asset file \"" + name + "\" was not loaded. Invalid signature.",
			stacktrace: debug_get_callstack(),
			error_source: "kengine",
			error_id: 11,
		};
	    return -1;
	}
}