# atom-resizable-panel

Creates an Atom [Panel](https://atom.io/docs/api/v0.176.0/Panel) and adds a scroll area and resize handle to it, so you can show arbitrary large HTML elements within a Panel.

This package provides a single class:
```coffee
{ResizablePanel} = require 'atom-tree-view'
```

### ResizablePanel
```coffee
constructor: (config)->
```
* `config`
  * `.item`: A DOM node or jQuery wrapper used as the panel content.
  * `.position`: Must be either `'left'`, `'right'`, `'top'` or `'bottom'`.
  * `.visible`: The initial visibility of the panel (default: true).
  * `.priority`: Determines stacking order. Lower priority items are forced closer to the edges of the window. (default: 100)

The Panel does not resize automatically when the content changes, so you need
to call `height()` or `width()` manually.

```
.minWidth = 50
.minHeight = 50
```

The resize handler can not be used to make the panel smaller than the value defined by `minWidth` or `minHeight`, depending on orientation.
