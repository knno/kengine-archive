/**
 * @typedef {Struct} PanelItemOptions
 * @memberof Kengine.Extensions.Panels
 * @see {@link KengineOptions}
 * 
 * @property {Real} width
 * @property {Real} height
 * @property {Real} font
 * @property {Any} value
 * @property {Real} alpha
 * @property {Kengine.Extensions.Panels.Panel} parent
 * @property {Real} [x]
 * @property {Real} [y]
 * @property {Real} [halign]
 * @property {Real} [valign]
 * @property {Real} [color]
 * @property {Bool} [visible]
 * @property {Array<Real>} [box_colors]
 * 
 * @description PanelItem options struct.
 * 
 */
function __KenginePanelsPanelItemOptions(options) : KengineOptions() constructor {
	__start(options)
    __add("x", 0)
    __add("y", 0)
    __add("width")
    __add("height")
    __add("font")
    __add("halign", fa_left)
    __add("valign", fa_top)
    __add("value")
    __add("visible", true)
    __add("color", c_white)
    __add("alpha")
	__add("parent")
    __add("box_colors", [
		$200,c_dkgrey,$200,c_dkgrey,
    ])
    __done()
}
/**
 * @function PanelItem
 * @abstract
 * @memberof Kengine.Extensions.Panels
 * @description A base panel item that represents things like {@link Kengine.Extensions.Panels.PanelItemInputBox} ...etc.
 * @param {Kengine.Extensions.Panels.PanelItemOptions} options an initial struct for setting options.
 * 
 */
function __KenginePanelsPanelItem(options=undefined) constructor {
    __default_width = 20;
    __default_height = 16;
	__default_color = c_white;
	__default_alpha = 1;

    if not is_instanceof(options, __KenginePanelsPanelItemOptions) {
		options = new __KenginePanelsPanelItemOptions(options);
	}
	parent = undefined
	height = undefined
    KengineOptions.__Apply(options, self);

	width = width ?? __default_width
	width = height ?? __default_height
	font = font ?? fnt_ken_panels
	color = color ?? (parent != undefined ? (__KengineStructUtils.Exists(parent, "color") ? parent.color : __default_color ) : __default_color)
	alpha = alpha ?? (parent != undefined ? (__KengineStructUtils.Exists(parent, "alpha") ? parent.alpha : __default_alpha ) : __default_alpha)

	/**
	 * @function __GetValue
	 * @private
	 * @description Return the value.
	 * @return {Any}
	 * 
	 */
	self.__GetValue = function() {
		return self.value;
	}

	/**
	 * @function GetValue
	 * @abstract
	 * @description An abstract function to return the value.
	 * @return {Any}
	 * 
	 */
	self.GetValue = function() {
		return self.__GetValue();
	}
	
	/**
	 * @function Step
	 * @abstract
	 * @description An abstract step function.
	 * 
	 */
	self.Step = undefined;

	/**
	 * @function Draw
	 * @abstract
	 * @description An abstract draw function.
	 * 
	 */
	self.Draw = undefined;
}
