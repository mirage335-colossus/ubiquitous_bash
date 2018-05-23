{CompositeDisposable} = require 'atom'
{repositoryForPath} = require './helpers'

module.exports =
class MinimapGitDiffBinding

  active: false

  constructor: (@minimap) ->
    @decorations = {}
    @markers = null
    @subscriptions = new CompositeDisposable

    unless @minimap?
      return console.warn 'minimap-git-diff binding created without a minimap'

    @editor = @minimap.getTextEditor()

    @subscriptions.add @minimap.onDidDestroy @destroy

    if repository = @getRepo()
      @subscriptions.add @editor.getBuffer().onDidStopChanging @updateDiffs
      @subscriptions.add repository.onDidChangeStatuses =>
        @scheduleUpdate()
      @subscriptions.add repository.onDidChangeStatus (changedPath) =>
        @scheduleUpdate() if changedPath is @editor.getPath()
      @subscriptions.add repository.onDidDestroy =>
        @destroy()
      @subscriptions.add atom.config.observe 'minimap-git-diff.useGutterDecoration', (@useGutterDecoration) =>
        @scheduleUpdate()

    @scheduleUpdate()

  cancelUpdate: ->
    clearImmediate(@immediateId)

  scheduleUpdate: ->
    @cancelUpdate()
    @immediateId = setImmediate(@updateDiffs)

  updateDiffs: =>
    @removeDecorations()
    if @getPath() and @diffs = @getDiffs()
      @addDecorations(@diffs)

  addDecorations: (diffs) ->
    for {oldStart, newStart, oldLines, newLines} in diffs
      startRow = newStart - 1
      endRow = newStart + newLines - 2
      if oldLines is 0 and newLines > 0
        @markRange(startRow, endRow, '.git-line-added')
      else if newLines is 0 and oldLines > 0
        @markRange(startRow, startRow, '.git-line-removed')
      else
        @markRange(startRow, endRow, '.git-line-modified')

  removeDecorations: ->
    return unless @markers?
    marker.destroy() for marker in @markers
    @markers = null

  markRange: (startRow, endRow, scope) ->
    return if @editor.isDestroyed()
    marker = @editor.markBufferRange([[startRow, 0], [endRow, Infinity]], invalidate: 'never')
    type = if @useGutterDecoration then 'gutter' else 'line'
    @minimap.decorateMarker(marker, {type, scope: ".minimap .#{type} #{scope}", plugin: 'git-diff'})
    @markers ?= []
    @markers.push(marker)

  destroy: =>
    @removeDecorations()
    @subscriptions.dispose()
    @diffs = null
    @minimap = null

  getPath: -> @editor.getBuffer()?.getPath()

  getRepositories: -> atom.project.getRepositories().filter (repo) -> repo?

  getRepo: -> @repository ?= repositoryForPath(@editor.getPath())

  getDiffs: ->
    try
      return @getRepo()?.getLineDiffs(@getPath(), @editor.getBuffer().getText())
    catch e
      return null
