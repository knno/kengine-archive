# Panels  :id=kengine-extensions-panels

[Kengine.Extensions.Panels](Kengine.Extensions.Panels) <code>object</code>
<!-- tabs:start -->


##### **Description**

Kengine's Panels extension


<!-- tabs:end -->

## Console  :id=kengine-extensions-panels-console

`Kengine.Extensions.Panels.Console(options)`
<!-- tabs:start -->


##### **Description**

A console is an extended [Panel](Kengine.Extensions.Panels?id=kengine.extensions.panels.panel) with many features for debugging.



| Param | Type | Description |
| --- | --- | --- |
| options | [<code>ConsoleOptions</code>](Kengine.Extensions.Panels?id=kengine.extensions.panels.consoleoptions) | <p>an initial struct for setting options.</p> |

<!-- tabs:end -->

## Panel  :id=kengine-extensions-panels-panel

`Kengine.Extensions.Panels.Panel(options)`
<!-- tabs:start -->


##### **Description**

A base panel that represents a window.



| Param | Type | Description |
| --- | --- | --- |
| options | [<code>PanelOptions</code>](Kengine.Extensions.Panels?id=kengine.extensions.panels.paneloptions) | <p>an initial <code>Kengine.Extensions.Panels.PanelOptions</code> for setting options of this panel.</p> |

<!-- tabs:end -->

## PanelItem  :id=kengine-extensions-panels-panelitem

*`Kengine.Extensions.Panels.PanelItem(options)`*
<!-- tabs:start -->


##### **Description**

A base panel item that represents things like [PanelItemInputBox](Kengine.Extensions.Panels?id=kengine.extensions.panels.paneliteminputbox) ...etc.



| Param | Type | Description |
| --- | --- | --- |
| options | [<code>PanelItemOptions</code>](Kengine.Extensions.Panels?id=kengine.extensions.panels.panelitemoptions) | <p>an initial struct for setting options.</p> |

<!-- tabs:end -->

## PanelItemInputBox  :id=kengine-extensions-panels-paneliteminputbox

`Kengine.Extensions.Panels.PanelItemInputBox(options)`
<!-- tabs:start -->


##### **Description**

A <code>PanelItemInputBox</code> is a text box that can be readonly or writable on self or parent focus.



| Param | Type | Description |
| --- | --- | --- |
| options | <code>Struct</code> | <p>an initial struct for setting options.</p> |

<!-- tabs:end -->

## ConsoleOptions  :id=kengine-extensions-panels-consoleoptions

[Kengine.Extensions.Panels.ConsoleOptions](Kengine.Extensions.Panels?id=kengine.extensions.panels.consoleoptions) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Console options struct.


**See**: [KengineOptions](KengineOptions)  
**Properties**

| Name | Type | Description |
| --- | --- | --- |
| color_echo | <code>Real</code> |  |
| color_error | <code>Real</code> |  |
| color_debug | <code>Real</code> |  |
| verbosity | <code>Real</code> |  |
| log_file | <code>String</code> |  |
| log_enabled | <code>Bool</code> |  |
| interpreter | <code>function</code> |  |
| [toggle_key] | <code>Real</code> |  |
| [notify_enabled] | <code>Bool</code> |  |
| [notify_show_time] | <code>Real</code> | <p>Defaults to 5 seconds.</p> |
| [enabled] | <code>Real</code> |  |
| [font] | <code>Asset.GMFont</code> |  |
| [lines_max] | <code>Real</code> |  |
| [lines_count] | <code>Real</code> |  |
| [lines_notify] | <code>Real</code> |  |

<!-- tabs:end -->

## PanelOptions  :id=kengine-extensions-panels-paneloptions

[Kengine.Extensions.Panels.PanelOptions](Kengine.Extensions.Panels?id=kengine.extensions.panels.paneloptions) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

Panel options struct.


<!-- tabs:end -->

## PanelItemOptions  :id=kengine-extensions-panels-panelitemoptions

[Kengine.Extensions.Panels.PanelItemOptions](Kengine.Extensions.Panels?id=kengine.extensions.panels.panelitemoptions) <code>Struct</code>
<!-- tabs:start -->


##### **Description**

PanelItem options struct.


**See**: [KengineOptions](KengineOptions)  
**Properties**

| Name | Type |
| --- | --- |
| width | <code>Real</code> | 
| height | <code>Real</code> | 
| font | <code>Real</code> | 
| value | <code>Any</code> | 
| alpha | <code>Real</code> | 
| parent | [<code>Panel</code>](Kengine.Extensions.Panels?id=kengine.extensions.panels.panel) | 
| [x] | <code>Real</code> | 
| [y] | <code>Real</code> | 
| [halign] | <code>Real</code> | 
| [valign] | <code>Real</code> | 
| [color] | <code>Real</code> | 
| [visible] | <code>Bool</code> | 
| [box_colors] | <code>Array.&lt;Real&gt;</code> | 

<!-- tabs:end -->

## PanelItemInputBoxOptions  :id=kengine-extensions-panels-paneliteminputboxoptions

[Kengine.Extensions.Panels.PanelItemInputBoxOptions](Kengine.Extensions.Panels?id=kengine.extensions.panels.paneliteminputboxoptions) [<code>PanelItemOptions</code>](Kengine.Extensions.Panels?id=kengine.extensions.panels.panelitemoptions)
<!-- tabs:start -->


##### **Description**

PanelItemInputBox options struct.


**See**: [KengineOptions](KengineOptions)  
**Properties**

| Name | Type |
| --- | --- |
| [readonly] | <code>Bool</code> | 
| [identifier] | <code>String</code> | 
| [box_enabled] | <code>Bool</code> | 
| [autoc_enabled] | <code>Bool</code> | 
| [history_enabled] | <code>Bool</code> | 
| [active] | <code>Bool</code> | 
| [background] | <code>Real</code> | 
| [text] | <code>String</code> | 

<!-- tabs:end -->

