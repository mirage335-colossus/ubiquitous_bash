# permanent-delete package

Permanently delete, i.e. bypass the recycle bin, files from the tree view.

## Config

| setting | type | default | description |
|---------|------|---------|-------------|
| `confirm` | boolean | `true` | Show a confirm dialog before deleting the files. |

## Commands

| command | scope-selector: keybinding | description |
|---------|----------------------------|-------------|
| `permanent-delete:delete` | `.tree-view`: <kbd>Shift-Delete</kbd> | Delete the selected entries, either files or directories, from the tree view |

## Issues/suggestions

Please file issues or suggestions on the [issues page on github](https://github.com/olmokramer/atom-permanent-delete/issues/new), or even better, [submit a pull request](https://github.com/olmokramer/atom-permanent-delete/pulls)

## License

`permanent-delete` is released under the [MIT License](LICENSE.md)<br>
&copy; 2015 Olmo Kramer