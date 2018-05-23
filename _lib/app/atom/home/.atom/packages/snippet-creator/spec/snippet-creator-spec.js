'use babel';

import SnippetCreator from '../lib/snippet-creator';

// Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
//
// To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
// or `fdescribe`). Remove the `f` to unfocus the block.

describe('SnippetCreator', () => {
  let workspaceElement, activationPromise;

  beforeEach(() => {
    workspaceElement = atom.views.getView(atom.workspace);
    activationPromise = atom.packages.activatePackage('snippet-creator');
  });

  describe('when the snippet-creator:create event is triggered', () => {
    it('shows the modal panel', () => {
      // Before the activation event the view is not on the DOM, and no panel
      // has been created
      expect(workspaceElement.querySelector('.snippet-creator')).not.toExist();

      // This is an activation event, triggering it will cause the package to be
      // activated.
      atom.commands.dispatch(workspaceElement, 'snippet-creator:create');

      waitsForPromise(() => {
        return activationPromise;
      });

      runs(() => {
        expect(workspaceElement.querySelector('.snippet-creator')).toExist();

        let snippetCreatorElement = workspaceElement.querySelector('.snippet-creator');
        expect(snippetCreatorElement).toExist();

        let snippetCreatorPanel = atom.workspace.panelForItem(snippetCreatorElement);
        expect(snippetCreatorPanel.isVisible()).toBe(true);

      });
    });
  });
});
