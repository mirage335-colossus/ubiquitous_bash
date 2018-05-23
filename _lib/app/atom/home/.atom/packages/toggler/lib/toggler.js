'use babel';

import { CompositeDisposable, Range } from 'atom';
import fs from 'fs';
import path from 'path';

import defaults from './defaults.json';

/**
 * RegExp special characters.
 * @type {RegExp}
 */
const RegExpCharacters = /[|\\{}()[\]^$+*?.]/g;

/**
 * Toggler class.
 */
class Toggler {

  /**
   * Activates the plugin and registers for various subscriptions.
   */
  activate(state) {
    this.subscriptions = new CompositeDisposable();

    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'toggler:toggle': () => this.toggle()
    }));

    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'toggler:config': () => this.configure()
    }));

    if (Toggler.isConfigured()) {
      this.loadConfiguration();
    } else {
      this.configure();
    }
  }

  /**
   * Deactivates the plugin and removes all subscriptions.
   */
  deactivate() {
    this.subscriptions.dispose();
  }

  /**
   * Toggles words.
   */
  toggle() {
    const editor = atom.workspace.getActiveTextEditor();

    if (editor === undefined || this.configuration === undefined) {
      return;
    }

    const selections = editor.getSelections();

    selections.forEach((selection) => {
      const toggle = this.getToggle(editor, selection);

      if (toggle.next !== null) {
        if (toggle.selected === true) {
          selection.insertText(toggle.next, { select: true });
        } else {
          editor.setTextInBufferRange(toggle.range, toggle.next);
        }
      } else {
        if (toggle.selected === true) {
          atom.notifications.addWarning(`Toggler: Could not find toggles for '${selection.getText()}'. Please use the \`toggler:config\` command to add one.`);
        } else {
          atom.notifications.addWarning(`Toggler: Could not find any toggles. Please use the \`toggler:config\` command to add one.`);
        }
      }
    });
  }

  /**
   * Returns the result of a toggle operation.
   * @param  {TextEditor} editor - The TextEditor instance.
   * @param  {Selection} selection - The selection in the editor to find a toggle for.
   * @return {Toggle} The result of the toggle operation.
   */
  getToggle(editor, selection) {
    let lineText;

    let word = selection.getText();
    let selected = word.length > 0;
    const cursorPosition = selection.cursor.getBufferPosition();

    const result = {
      next: null,
      selected,
    };

    if (selected === false) {
      lineText = editor.lineTextForBufferRow(cursorPosition.row);
    }

    for (let i = 0; i < this.configuration.length; i++) {
      const group = this.configuration[i];

      for (let j = 0; j < group.length; j++) {
        const currentWord = group[j];
        const nextWordIndex = (j + 1) % group.length;

        if (selected === false) {
          const regexp = new RegExp(Toggler.escapeStringRegExp(currentWord), 'ig');

          let match;

          while ((match = regexp.exec(lineText)) !== null) {
            const matchRange = new Range([cursorPosition.row, match.index], [cursorPosition.row, regexp.lastIndex]);

            if (matchRange.containsPoint(cursorPosition) === true) {
              word = match[0];

              result.range = matchRange;

              break;
            }
          }
        }

        if (word.toLowerCase() === currentWord.toLowerCase()) {
          if (word === currentWord.toLowerCase()) {
            result.next = group[nextWordIndex].toLowerCase();
          } else if (word === currentWord.toUpperCase()) {
            result.next = group[nextWordIndex].toUpperCase();
          } else if (word === Toggler.capitalize(currentWord)) {
            result.next = Toggler.capitalize(group[nextWordIndex]);
          } else {
            result.next = group[nextWordIndex];
          }

          return result;
        }
      }
    }

    return result;
  }

  /**
   * Open the configuration file.
   */
  configure() {
    const configPath = Toggler.getConfigPath();
    const isConfigured = Toggler.isConfigured();

    atom.workspace.open(configPath, { searchAllPanes: true })
      .then((editor) => {
        const disposable = editor.onDidSave(() => { this.loadConfiguration(true); });
        editor.onDidDestroy(() => { disposable.dispose(); });

        if (isConfigured === false) {
          editor.setText(Toggler.readFile(path.join(__dirname, 'defaults.json')));
          editor.save();
        }
      });
  }

  /**
   * Load the configuration file if not already loaded.
   * @param  {boolean} force - When `true`, reload the configuration even if it's already loaded.
   */
  loadConfiguration(force = false) {
    if (this.configuration !== undefined && force === false) {
      return;
    }

    try {
      this.configuration = JSON.parse(Toggler.readFile(Toggler.getConfigPath()));
    } catch (e) {
      atom.notifications.addError(
        'Toggler: Could not read configuration file. Please use the `toggler:config` command.',
        { detail: e.message }
      );
    }
  }

  /**
   * Returns the configuration file path.
   * @return {string} The configuration file path.
   */
  static getConfigPath() {
    return path.join(atom.getConfigDirPath(), 'toggler.json');
  }

  /**
   * Reads a file synchronously.
   * @param  {string} path - The file path.
   * @return {string} The content of the file.
   */
  static readFile(path) {
    return fs.readFileSync(path, 'utf8');
  }

  /**
   * Returns `true` if the Toggler plugin is already configured.
   * This is done by checking if the configuration file exists or not.
   * @return {boolean} `true` when configured.
   */
  static isConfigured() {
    return fs.existsSync(Toggler.getConfigPath());
  }

  /**
   * Capitalizes a string.
   * @param  {string} string - The string to capitalize.
   * @return {string} The capitalized string.
   */
  static capitalize(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  }

  /**
   * Escapes RegExp special characters in a string.
   * @param  {string} string - The string to escape.
   * @return {string} The escaped string.
   * @see https://github.com/sindresorhus/escape-string-regexp
   */
  static escapeStringRegExp(string) {
    return string.replace(RegExpCharacters, '\\$&');
  }

}

export default new Toggler();

/**
 * @typedef Toggle
 * @type {Object}
 * @property {boolean} selected - Defines if the toggle is based on a user selection or guessed on a cursor position.
 * @property {?Range} range - Range of the toggled words when the toggle is based on a cursor position.
 * @property {?string} next - The next toggle.
 */
