{$, View} = require 'space-pen'

module.exports =
class ResizablePanel extends View

  @content: (param)->
    @div =>
      @div outlet: 'scroller', =>
        @subview 'content', param.item
      @div outlet: 'handle'

  initialize: (param)->
    @position = param.position or 'bottom'
    @vertical = @position is 'left' or @position is 'right'

    @minWidth = 50 if @vertical
    @minHeight = 50 if not @vertical

    @handle.on 'mousedown', (e) => @resizeStarted(e)

    @css
      position: 'relative'
      overflow: 'hidden'
      width: if @vertical then param.item.width else '100%'
      height: if not @vertical then param.item.height else '100%'
      'z-index': 2

    @scroller.css
      position: 'absolute'
      width: '100%'
      height: '100%'
      overflow: 'auto'

    @handle.css
      width: if @vertical then '10px' else '100%'
      height: if not @vertical then '10px' else '100%'
      left: 0 if not @vertical or @position is 'right'
      right: 0 if @position is 'left'
      top: 0 if @vertical or @position is 'bottom'
      bottom: 0 if @position is 'top'
      cursor: if @vertical then 'col-resize' else 'row-resize'
      position: 'absolute'
      'z-index': 3

    param.item = this
    @panel = switch @position
      when 'bottom' then atom.workspace.addBottomPanel param
      when 'top'then atom.workspace.addTopPanel param
      when 'left'then atom.workspace.addLeftPanel param
      when 'right'then atom.workspace.addRightPanel param

    # workaround for https://discuss.atom.io/t/ugly-scrollbars-bug/1027
    @css display: 'inline-block'
    setTimeout => @css display: 'block'

  destroy: ->
    @panel.destroy()

  resizeStarted: =>
    @focusElement = document.activeElement
    $(document).on('mousemove', @resizeTo)
    $(document).on('mouseup', @resizeStopped)

  resizeStopped: =>
    $(document).off('mousemove', @resizeTo)
    $(document).off('mouseup', @resizeStopped)
    @focusElement?.focus()
    @focusElement = null

  resizeTo: ({pageX, pageY}) =>
    switch @position
      when 'left' then @width Math.max @minWidth, pageX
      when 'right'then @width Math.max @minWidth, $(document.body).width() - pageX
      when 'top'   then @height Math.max @minHeight, pageY
      when 'bottom'then @height Math.max @minHeight, $(document.body).height() - pageY
