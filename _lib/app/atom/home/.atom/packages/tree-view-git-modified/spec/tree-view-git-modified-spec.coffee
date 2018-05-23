TreeViewGitModified = require '../lib/tree-view-git-modified'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "TreeViewGitModified", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('tree-view-git-modified')

  describe "when the tree-view-git-modified:show event is triggered", ->
    it "shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.tree-view-git-modified')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'tree-view-git-modified:show'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.tree-view-git-modified')).toExist()

  # TODO: Include additional tests for all methods
