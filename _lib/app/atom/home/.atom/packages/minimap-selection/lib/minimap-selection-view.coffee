{CompositeDisposable} = require 'event-kit'

module.exports =
class MinimapSelectionView
  decorations: []

  constructor: (@minimap) ->
    editor = @minimap.getTextEditor()

    @subscriptions = new CompositeDisposable

    @subscriptions.add editor.onDidAddCursor @handleSelection
    @subscriptions.add editor.onDidChangeCursorPosition @handleSelection
    @subscriptions.add editor.onDidRemoveCursor @handleSelection
    @subscriptions.add atom.config.observe 'minimap-selection.outlineSelection', @handleSelection

    @handleSelection()

  destroy: ->
    @removeDecorations()
    @subscriptions.dispose()
    @minimap = null

  handleSelection: =>
    @removeDecorations()

    textEditor = @minimap.getTextEditor()
    return if !textEditor.selections? or textEditor.selections.length is 0

    for selection in textEditor.getSelections()
      if not selection.isEmpty()
        decoration = @minimap.decorateMarker(selection.marker, type: 'highlight-under', scope: '.minimap .minimap-selection .region', plugin: 'selection')
        @decorations.push decoration if decoration?

        if atom.config.get('minimap-selection.outlineSelection')
          decoration = @minimap.decorateMarker(selection.marker, type: 'highlight-outline', scope: '.minimap .minimap-selection .region-outline', plugin: 'selection')
          @decorations.push decoration if decoration?

      else if atom.config.get('minimap-selection.highlightCursorsLines')
        decoration = @minimap.decorateMarker(selection.marker, type: 'line', scope: '.minimap .minimap-selection .cursor-line', plugin: 'selection')
        @decorations.push decoration if decoration?


  removeDecorations: ->
    return if @decorations.length is 0
    decoration?.destroy() for decoration in @decorations
    @decorations = []
