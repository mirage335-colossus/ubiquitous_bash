{CompositeDisposable} = require 'atom'
FindAndReplace = null

module.exports =
class MinimapFindAndReplaceBinding
  constructor: (@minimap, @fnrAPI) ->
    @editor = @minimap.getTextEditor()
    @subscriptions = new CompositeDisposable
    @decorationsByMarkerId = {}
    @subscriptionsByMarkerId = {}

    if @fnrAPI?
      @layer = @fnrAPI.resultsMarkerLayerForTextEditor(@editor)

      @subscriptions.add @layer.onDidCreateMarker (marker) =>
        @handleCreatedMarker(marker)
    else
      @subscriptions.add @editor.displayBuffer.onDidCreateMarker (marker) =>
        @handleCreatedMarker(marker)

    @discoverMarkers()

  destroy: ->
    sub.dispose() for id,sub of @subscriptionsByMarkerId
    decoration.destroy() for id,decoration of @decorationsByMarkerId

    @subscriptions.dispose()
    @minimap = null
    @editor = null
    @decorationsByMarkerId = {}
    @subscriptionsByMarkerId = {}

  clear: ->
    for id,sub of @subscriptionsByMarkerId
      sub.dispose()
      delete @subscriptionsByMarkerId[id]

    for id,decoration of @decorationsByMarkerId
      decoration.destroy()
      delete @decorationsByMarkerId[id]

  findAndReplace: -> FindAndReplace ?= atom.packages.getLoadedPackage('find-and-replace').mainModule

  discoverMarkers: ->
    if @fnrAPI?
      @layer.getMarkers().forEach (marker) => @createDecoration(marker)
    else
      @editor.findMarkers(class: 'find-result').forEach (marker) =>
        @createDecoration(marker)

  handleCreatedMarker: (marker) ->
    if @fnrAPI? or marker.getProperties()?.class is 'find-result'
      @createDecoration(marker)

  createDecoration: (marker) ->
    return unless @findViewIsVisible()
    return if @decorationsByMarkerId[marker.id]?

    decoration = @minimap.decorateMarker(marker, {
      type: 'highlight'
      scope: ".minimap .search-result"
      plugin: 'find-and-replace'
    })
    return unless decoration?

    id = marker.id
    @decorationsByMarkerId[id] = decoration
    @subscriptionsByMarkerId[id] = decoration.onDidDestroy =>
      @subscriptionsByMarkerId[id].dispose()
      delete @decorationsByMarkerId[id]
      delete @subscriptionsByMarkerId[id]

  findViewIsVisible: ->
    document.querySelector('.find-and-replace')?
