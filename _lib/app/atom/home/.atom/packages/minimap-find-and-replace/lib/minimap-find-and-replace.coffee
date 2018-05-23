{CompositeDisposable} = require 'atom'
MinimapFindAndReplaceBinding = null

module.exports =
  active: false
  bindingsById: {}
  subscriptionsById: {}

  isActive: -> @active

  activate: (state) ->
    @subscriptions = new CompositeDisposable

  consumeMinimapServiceV1: (@minimap) ->
    @minimap.registerPlugin 'find-and-replace', this

  deactivate: ->
    @minimap.unregisterPlugin 'find-and-replace'
    @minimap = null

  activatePlugin: ->
    return if @active

    @active = true

    fnrVersion = atom.packages.getLoadedPackage('find-and-replace').metadata.version
    fnrHasServiceAPI = parseFloat(fnrVersion) >= 0.194

    if fnrHasServiceAPI
      @initializeServiceAPI()
    else
      @initializeLegacyAPI()

    @subscriptions.add atom.commands.add 'atom-workspace',
      'find-and-replace:show': => @discoverMarkers()
      'find-and-replace:toggle': => @discoverMarkers()
      'find-and-replace:show-replace': => @discoverMarkers()
      'core:cancel': => @clearBindings()
      'core:close': => @clearBindings()

  initializeServiceAPI: ->
    atom.packages.serviceHub.consume 'find-and-replace', '0.0.1', (fnr) =>
      @subscriptions.add @minimap.observeMinimaps (minimap) =>
        MinimapFindAndReplaceBinding ?= require './minimap-find-and-replace-binding'

        id = minimap.id
        binding = new MinimapFindAndReplaceBinding(minimap, fnr)
        @bindingsById[id] = binding

        @subscriptionsById[id] = minimap.onDidDestroy =>
          @subscriptionsById[id]?.dispose()
          @bindingsById[id]?.destroy()

          delete @bindingsById[id]
          delete @subscriptionsById[id]

  initializeLegacyAPI: ->
    @subscriptions.add @minimap.observeMinimaps (minimap) =>
      MinimapFindAndReplaceBinding ?= require './minimap-find-and-replace-binding'

      id = minimap.id
      binding = new MinimapFindAndReplaceBinding(minimap)
      @bindingsById[id] = binding

      @subscriptionsById[id] = minimap.onDidDestroy =>
        @subscriptionsById[id]?.dispose()
        @bindingsById[id]?.destroy()

        delete @bindingsById[id]
        delete @subscriptionsById[id]

  deactivatePlugin: ->
    return unless @active

    @active = false
    @subscriptions.dispose()

    sub.dispose() for id,sub of @subscriptionsById
    binding.destroy() for id,binding of @bindingsById

    @bindingsById = {}
    @subscriptionsById = {}

  discoverMarkers: ->
    binding.discoverMarkers() for id,binding of @bindingsById

  clearBindings: ->
    binding.clear() for id,binding of @bindingsById
