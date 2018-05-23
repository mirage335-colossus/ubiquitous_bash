{View} = require 'atom-space-pen-views'
{Range, Point} = require 'atom'
_ = require 'underscore-plus'
DiffDetailsDataManager = require './data-manager'
Housekeeping = require './housekeeping'

module.exports = class AtomGitDiffDetailsView extends View
  Housekeeping.includeInto(this)

  @content: ->
    @div class: "git-diff-details-outer", =>
      @div class: "git-diff-details-main-panel", outlet: "mainPanel", =>
        @div class: "editor git-diff-editor", outlet: "contents"

  initialize: (@editor) ->
    @editorView = atom.views.getView(@editor)

    @diffDetailsDataManager = new DiffDetailsDataManager()

    @initializeHousekeeping()
    @preventFocusOut()

    @diffEditor = atom.workspace.buildTextEditor(lineNumberGutterVisible: false, scrollPastEnd: false)
    @contents.html(atom.views.getView(@diffEditor))

    @markers = []

    @showDiffDetails = false
    @lineDiffDetails = null

    @updateCurrentRow()

  preventFocusOut: ->
    @mainPanel.on 'mousedown', () ->
      false

  getActiveTextEditor: ->
    atom.workspace.getActiveTextEditor()

  updateCurrentRow: ->
    newCurrentRow = @getActiveTextEditor()?.getCursorBufferPosition()?.row + 1
    if newCurrentRow != @currentRow
      @currentRow = newCurrentRow
      return true
    return false

  notifyContentsModified: =>
    return if @editor.isDestroyed()
    @diffDetailsDataManager.invalidate(@repositoryForPath(@editor.getPath()),
                                       @editor.getPath(),
                                       @editor.getText())
    if @showDiffDetails
      @updateDiffDetailsDisplay()

  updateDiffDetails: ->
    @diffDetailsDataManager.invalidatePreviousSelectedHunk()
    @updateCurrentRow()
    @updateDiffDetailsDisplay()

  toggleShowDiffDetails: ->
    @showDiffDetails = !@showDiffDetails
    @updateDiffDetails()

  closeDiffDetails: ->
    @showDiffDetails = false
    @updateDiffDetails()

  notifyChangeCursorPosition: ->
    if @showDiffDetails
      currentRowChanged = @updateCurrentRow()
      @updateDiffDetailsDisplay() if currentRowChanged

  copy: ->
    {selectedHunk} = @diffDetailsDataManager.getSelectedHunk(@currentRow)
    if selectedHunk?
      atom.clipboard.write(selectedHunk.oldString)
      @closeDiffDetails() if atom.config.get('git-diff-details.closeAfterCopy')

  undo: ->
    {selectedHunk} = @diffDetailsDataManager.getSelectedHunk(@currentRow)

    if selectedHunk? and buffer = @editor.getBuffer()
      if selectedHunk.kind is "m"
        buffer.setTextInRange([[selectedHunk.start - 1, 0], [selectedHunk.end, 0]], selectedHunk.oldString)
      else
        buffer.insert([selectedHunk.start, 0], selectedHunk.oldString)
      @closeDiffDetails() unless atom.config.get('git-diff-details.keepViewToggled')

  destroyDecoration: ->
    for marker in @markers
      marker.destroy()
    @markers = []

  decorateLines: (editor, start, end, type) ->
    range = new Range(new Point(start, 0), new Point(end, 0))
    marker = editor.markBufferRange(range)
    editor.decorateMarker(marker, type: 'line', class: "git-diff-details-#{type}")
    @markers.push(marker)

  decorateWords: (editor, start, words, type) ->
    return unless words
    for word in words when word.changed
      row = start + word.offsetRow
      range = new Range(new Point(row, word.startCol), new Point(row, word.endCol))
      marker = editor.markBufferRange(range)
      editor.decorateMarker(marker, type: 'highlight', class: "git-diff-details-#{type}")
      @markers.push(marker)

  display: (selectedHunk) ->
    @destroyDecoration()

    classPostfix =
      if atom.config.get('git-diff-details.enableSyntaxHighlighting')
        "highlighted"
      else "flat"

    if selectedHunk.kind is "m"
      @decorateLines(@editor, selectedHunk.start - 1, selectedHunk.end, "new-#{classPostfix}")
      if atom.config.get('git-diff-details.showWordDiffs')
        @decorateWords(@editor, selectedHunk.start - 1, selectedHunk.newWords, "new-#{classPostfix}")

    range = new Range(new Point(selectedHunk.end - 1, 0), new Point(selectedHunk.end - 1, 0))
    marker = @editor.markBufferRange(range)
    @editor.decorateMarker(marker, type: 'block', position: 'after', item: this)
    @markers.push(marker)

    @diffEditor.setGrammar(@getActiveTextEditor()?.getGrammar())
    @diffEditor.setText(selectedHunk.oldString.replace(/[\r\n]+$/g, ""))
    @decorateLines(@diffEditor, 0, selectedHunk.oldLines.length, "old-#{classPostfix}")
    if atom.config.get('git-diff-details.showWordDiffs')
      @decorateWords(@diffEditor, 0, selectedHunk.oldWords, "old-#{classPostfix}")

  updateDiffDetailsDisplay: ->
    if @showDiffDetails
      {selectedHunk, isDifferent} = @diffDetailsDataManager.getSelectedHunk(@currentRow)

      if selectedHunk?
        return unless isDifferent
        @display(selectedHunk)
        return
      else
        @closeDiffDetails() unless atom.config.get('git-diff-details.keepViewToggled')

      @previousSelectedHunk = selectedHunk

    @destroyDecoration()
    return
