MinimapBookmarks = require '../lib/minimap-bookmarks'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe 'MinimapBookmarks', ->
  [workspaceElement, editor, editorElement, bookmarks, minimap] = []

  bookmarkedRangesForEditor = (editor) ->
    obj = editor.decorationsStateForScreenRowRange(0, editor.getLastScreenRow())
    Object.keys(obj)
      .map (k) -> obj[k]
      .filter (decoration) -> decoration.properties.class is 'bookmarked'
      .map (decoration) -> decoration.screenRange

  beforeEach ->
    spyOn(window, 'setImmediate').andCallFake (fn) -> fn()
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.workspace.open('sample.coffee').then (e) ->
        editor = e

    waitsForPromise ->
      atom.packages.activatePackage('bookmarks').then (pkg) ->
        bookmarks = pkg.mainModule

    waitsForPromise ->
      atom.packages.activatePackage('minimap').then (pkg) ->
        minimap = pkg.mainModule.minimapForEditor(editor)

    waitsForPromise ->
      atom.packages.activatePackage('minimap-bookmarks')

    runs ->
      jasmine.attachToDOM(workspaceElement)
      editorElement = atom.views.getView(editor)
      atom.packages.packageStates.bookmarks = bookmarks.serialize()
      spyOn(atom, 'beep')

  describe 'with an open editor that have a minimap', ->
    describe 'when toggle switch bookmarks markers to the editor', ->
      beforeEach ->
        editor.setCursorScreenPosition([2, 0])
        atom.commands.dispatch editorElement, 'bookmarks:toggle-bookmark'

        editor.setCursorScreenPosition([3, 0])
        atom.commands.dispatch editorElement, 'bookmarks:toggle-bookmark'

        editor.setCursorScreenPosition([1, 0])
        atom.commands.dispatch editorElement, 'bookmarks:toggle-bookmark'
        atom.commands.dispatch editorElement, 'bookmarks:toggle-bookmark'

      it 'creates tow markers', ->
        expect(bookmarkedRangesForEditor(editor).length).toBe 2

      it 'creates state of bookmarks', ->
        expect(Object.keys(atom.packages.packageStates.bookmarks).length).toBe 1

      it 'gets markerLayerId from state of bookmarks by editorId', ->
        markerLayerId = atom.packages.packageStates.bookmarks[editor.id].markerLayerId
        expect(markerLayerId).not.toEqual undefined

      it 'finds marks by markerLayerId', ->
        markerLayerId = atom.packages.packageStates.bookmarks[editor.id].markerLayerId
        markerLayer = editor.getMarkerLayer(markerLayerId)
        expect(markerLayer.findMarkers().length).toBe 2
