{CompositeDisposable} = require 'atom'

module.exports =
class MinimapBookmarksBinding
  constructor: (@minimap, @bookmarks) ->
    @subscriptions = new CompositeDisposable
    @editor = @minimap.getTextEditor()
    @decorationsByMarkerId = {}
    @decorationSubscriptionsByMarkerId = {}

    # We need to wait until the bookmarks package had created its marker
    # layer before retrieving its id from the state.
    requestAnimationFrame =>
      # Also, targeting private properties on atom.packages is very brittle.
      # DO NOT DO THAT!
      #
      # If we really have to get the marker layer id from the
      # state (which can already break easily) it's better to get it from the
      # package `serialize` method since it's an API that is public and is
      # unlikely to change in a near future.
      id = @bookmarks.serialize()[@editor.id]?.markerLayerId
      markerLayer = @editor.getMarkerLayer(id)

      if markerLayer?
        @subscriptions.add markerLayer.onDidCreateMarker (marker) =>
          @handleMarker(marker)

        markerLayer.findMarkers().forEach (marker) => @handleMarker(marker)

  handleMarker: (marker) ->
    {id} = marker
    decoration = @minimap.decorateMarker(marker, type: 'line', class: 'bookmark', plugin: 'bookmarks')
    @decorationsByMarkerId[id] = decoration
    @decorationSubscriptionsByMarkerId[id] = decoration.onDidDestroy =>
      @decorationSubscriptionsByMarkerId[id].dispose()

      delete @decorationsByMarkerId[id]
      delete @decorationSubscriptionsByMarkerId[id]

  destroy: ->
    for id,decoration of @decorationsByMarkerId
      @decorationSubscriptionsByMarkerId[id].dispose()
      decoration.destroy()

      delete @decorationsByMarkerId[id]
      delete @decorationSubscriptionsByMarkerId[id]

    @subscriptions.dispose()
