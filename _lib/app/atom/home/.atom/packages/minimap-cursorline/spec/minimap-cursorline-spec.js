'use babel'

import MinimapCursorLine from '../lib/minimap-cursorline'

// Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
//
// To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
// or `fdescribe`). Remove the `f` to unfocus the block.

describe('MinimapCursorLine', () => {
  let [workspaceElement, editor, minimap] = []

  beforeEach(() => {
    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    waitsForPromise(() => {
      return atom.workspace.open('sample.js').then((e) => {
        editor = e
      })
    })

    waitsForPromise(() => {
      return atom.packages.activatePackage('minimap').then((pkg) => {
        minimap = pkg.mainModule.minimapForEditor(editor)
      })
    })

    waitsForPromise(() => {
      return atom.packages.activatePackage('minimap-cursorline')
    })
  })

  describe('with an open editor that have a minimap', () => {
    let cursor, marker
    describe('when cursor markers are added to the editor', () => {
      beforeEach(() => {
        cursor = editor.addCursorAtScreenPosition({ row: 2, column: 3 })
        marker = cursor.getMarker()
      })

      it('creates decoration for the cursor markers', () => {
        expect(Object.keys(minimap.decorationsByMarkerId).length).toEqual(1)
      })
    })
  })
})
