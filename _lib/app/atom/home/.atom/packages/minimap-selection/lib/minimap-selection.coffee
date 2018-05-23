MinimapSelectionView = require './minimap-selection-view'

module.exports =

  active: false
  views: {}

  config:
    highlightCursorsLines:
      type: 'boolean'
      default: false
      description: 'When true, the lines with cursors are highlighted in the minimap.'
    outlineSelection:
      type: 'boolean'
      default: false
      description: 'When true, the selections will also be rendered with outline decorations.'

  activate: ->

  consumeMinimapServiceV1: (@minimap) ->
    @minimap.registerPlugin 'selection', this

  deactivate: ->
    @minimap.unregisterPlugin 'selection'
    @minimap = null

  isActive: -> @active

  activatePlugin: ->
    return if @active
    @active = true

    @subscription = @minimap.observeMinimaps (o) =>
      minimap = o.view ? o
      selectionView = new MinimapSelectionView(minimap)

      @views[minimap.id] = selectionView

      disposable = minimap.onDidDestroy =>
        selectionView.destroy()
        delete @views[minimap.id]
        disposable.dispose()

  deactivatePlugin: ->
    return unless @active
    view.destroy() for id,view of @views
    @active = false
    @views = {}

    @subscription.dispose()
