'use babel';

import fs from 'fs';
import path from 'path';

import Toggler from '../lib/toggler';
import defaults from '../lib/defaults.json';

const configPath = path.join(atom.getConfigDirPath(), 'toggler.json');
const configExist = fs.existsSync(configPath);

if (configExist === false) {
  fs.writeFileSync(configPath, JSON.stringify(defaults, null, '  '));
}

describe('Toggler', () => {
  let workspaceElement, activationPromise, editor;

  beforeEach(() => {
    workspaceElement = atom.views.getView(atom.workspace);

    waitsForPromise(() => {
      activationPromise = atom.packages.activatePackage('toggler');
      atom.commands.dispatch(atom.views.getView(atom.workspace), 'toggler:toggle');
      return activationPromise;
    });

    waitsForPromise(() => {
      return atom.workspace.open('test.js');
    });

    runs(() => {
      editor = atom.workspace.getActiveTextEditor();
    });
  });

  describe('when the toggler:toggle event is triggered', () => {
    it('should replace a known word', () => {
      runs(() => {
        editor.setText('true');

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('false');
      });
    });

    it('should not replace an unknown word', () => {
      runs(() => {
        const word = 'sdjflksdjfsjd'

        editor.setText(word);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe(word);
      });
    });

    it('should replace and respect lowercase', () => {
      runs(() => {
        editor.setText('true');

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('false');
      });
    });

    it('should replace and respect uppercase', () => {
      runs(() => {
        editor.setText('TRUE');

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('FALSE');
      });
    });

    it('should replace and respect capitalization', () => {
      runs(() => {
        editor.setText('True');

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('False');
      });
    });

    it('should replace no matter the cursor position', () => {
      runs(() => {
        editor.setText('true');
        editor.setCursorBufferPosition([0, 1]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('false');

        editor.setCursorBufferPosition([0, 2]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('true');

        editor.setCursorBufferPosition([0, 3]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('false');

        editor.setCursorBufferPosition([0, 4]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('true');
      });
    });

    it('should replace with selected text', () => {
      runs(() => {
        editor.setText('true');
        editor.selectAll();

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('false');
      });
    });

    it('should always replace the selected text over a guess based on the cursor position', () => {
      runs(() => {
        editor.setText('true');
        editor.setSelectedBufferRange([[0, 0], [0, 2]]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('tdue');
      });
    });

    it('should properly guess the word to replace based on the cursor position', () => {
      runs(() => {
        editor.setText('test');
        editor.setCursorBufferPosition([0, 2]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('test.only');

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('test');
      });
    });

    it('should properly guess the word to replace when the cursor is around the word', () => {
      runs(() => {
        editor.setText('test');
        editor.setCursorBufferPosition([0, 0]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('test.only');

        editor.setCursorBufferPosition([0, 9]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('test');
      });
    });

    it('should not guess a word to replace in a range not including the cursor position', () => {
      runs(() => {
        editor.setText('test something');
        editor.setCursorBufferPosition([0, 5]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('test something');
      });
    });

    it('should replace symbols', () => {
      runs(() => {
        editor.setText('\'');

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('"');
      });
    });

    it('should replace with multiple toggles', () => {
      runs(() => {
        editor.setText('\'');

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('"');

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('`');
      });
    });

    it('should replace with multiple selections', () => {
      runs(() => {
        editor.setText('true something false true');
        editor.setSelectedBufferRanges([[[0, 0], [0, 4]], [[0, 15], [0, 20]]]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('false something true true');
      });
    });

    it('should replace with multiple cursors', () => {
      runs(() => {
        editor.setText('true something false true');
        editor.setCursorBufferPosition([0, 0]);
        editor.addCursorAtBufferPosition([0, 15]);

        atom.commands.dispatch(workspaceElement, 'toggler:toggle');

        expect(editor.getText()).toBe('false something true true');
      });
    });
  });
});
