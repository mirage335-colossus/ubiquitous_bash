# Changelog

## 0.3.1

* Change default Linux shortcut to <kbd>Alt</kbd>+<kbd>r</kbd>.
* Add more default toggles ([#4](https://github.com/HiDeoo/toggler/pull/4)).

## 0.3.0

* Change behavior without explicit selection(s):
  * In the previous version, when no obvious selection was specified when triggering the plugin, we used the Atom API to create a fake selection encompassing the current word under the cursor. This lead to issues with some toggles like `test.only` being replaced to `test.test.only` when the cursor was somewhere in the `test` part of the word to replace. Having the cursor in the `only` part of the word failed to even trigger the toggle operation.
  * Starting from this version, when no selection is found, we're parsing all the text around the cursor to find the best possible word to replace based on the configuration.
  * When a selection is explicitly given, we only try to replace the current selection.
  * **Please note that this change required modifications in the default configuration file. You should update your existing configuration file based on [the new one](https://github.com/HiDeoo/toggler/blob/master/lib/defaults.json).**

## 0.2.0 - The EveryJuan release

* Change the default Windows shortcut to Alt + r instead of Ctrl + r.

## 0.1.0

* First release.
