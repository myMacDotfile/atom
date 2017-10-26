# Copyright (c) 2015 by rapidhere, RANTTU. INC. All Rights Reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the Lesser GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# the header generator for a file
{getCompiler} = require('./compiler')

# Class: Generator
module.exports =
class Generator
  constructor: (@editor)->

  # restore cursor's position and call the cb
  # after the cb, move the cursor back to it's previous position
  restoreCursor:(cb) ->
    # get the marker
    marker = @editor.markBufferPosition(@editor.getCursorBufferPosition(), persistent: false)

    # do the job
    cb()

    # restore the position
    @editor.setCursorBufferPosition(marker.getHeadBufferPosition())
    marker.destroy()

  # get the text to insert
  # this will get the raw template from config 'auto-header.template'
  # and call the compiler to compile the template
  getContent: ->
    text = "#{atom.config.get('auto-header.template')}"

    getCompiler().compile(text)

  # sync the header content
  # after the sync, call the cb
  sync: (cb)->
    job = =>
      # get the buffer and cursor
      textBuffer = @editor.getBuffer()
      cursor = @editor.getLastCursor()

      # remove header comment
      # TODO: to ensure that the header comment is generated by this generator
      while true
        cursor.setBufferPosition([0, 0], autoscroll: false)
        row = cursor.getBufferRow()

        unless @editor.isBufferRowCommented(row)
          break

        textBuffer.deleteRow(0)

      # insert and toggle into comment
      cursor.setBufferPosition([0, 0], autoscroll: false)
      @editor.insertText(@getContent(), select: true)
      @editor.toggleLineCommentsInSelection()

      # go to the end of text
      rn = @editor.getSelectedBufferRange()
      @editor.setCursorBufferPosition(rn.end)
      @editor.insertText('\n')

    # do sync job
    @restoreCursor =>
      @editor.transact(job)
