MinimapSelection = require '../lib/minimap-selection'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MinimapSelection", ->
  [workspaceElement, editor, minimap, minimapModule] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise -> atom.workspace.open('sample.coffee')
    waitsForPromise -> atom.packages.activatePackage('minimap').then (pkg) ->
      minimapModule = pkg.mainModule

    waitsForPromise -> atom.packages.activatePackage('minimap-selection')

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      minimap = minimapModule.minimapForEditor(editor)

      spyOn(minimap, 'decorateMarker').andCallThrough()
      spyOn(minimap, 'removeDecoration').andCallThrough()

  describe 'when a selection is made in the text editor', ->
    beforeEach ->
      editor.setSelectedBufferRange([[1,0], [2,10]])

    it 'adds a decoration for the selection in the minimap', ->
      expect(minimap.decorateMarker).toHaveBeenCalled()

    describe 'and then removed', ->
      beforeEach ->
        editor.setSelectedBufferRange([[0,0], [0,0]])

      it 'removes the previously added decoration', ->
        expect(minimap.removeDecoration).toHaveBeenCalled()
