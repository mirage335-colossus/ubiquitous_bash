[![Build Status](https://travis-ci.org/UziTech/terminal-commands.svg?branch=master)](https://travis-ci.org/UziTech/terminal-commands)
[![Build status](https://ci.appveyor.com/api/projects/status/o0h54ouxl2jtvvfm?svg=true)](https://ci.appveyor.com/project/UziTech/terminal-commands)
[![Dependency Status](https://david-dm.org/UziTech/terminal-commands.svg)](https://david-dm.org/UziTech/terminal-commands)

# terminal-commands package

Setup commands to run in the terminal from the command palette, context menu, or key binding.

**Note**  Depends on [platformio-ide-terminal](https://github.com/platformio/platformio-atom-ide-terminal) to run!

![screenshot](https://user-images.githubusercontent.com/97994/36390238-fd6c8a2c-1567-11e8-8517-d4986ac2fde2.gif)

## Example

```js
// in ~/.atom/terminal-commands.json
{
  "echo:file": "echo ${file}",
  "echo:files": ["echo test", "echo ${files}"],
  "echo:dir": {
    "commands": "echo ${dir}",
    "key": "alt-d",
    "priority": 0
  },
  "echo:project": {
    "commands": "echo ${project}",
    "key": "alt-p",
    "priority": 100,
    "selector": ".tree-view"
  }
}
```

---

![image](https://user-images.githubusercontent.com/97994/38253603-ae24915e-371c-11e8-9470-8db7d2f81fa3.png)

---

![image](https://user-images.githubusercontent.com/97994/34899525-1704ef86-f7bf-11e7-9088-d12d63ea2732.png)

## Options

The commands in `terminal-commands.json` should be formatted as one of the following:

-   Single string command:

```js
{
  "namespace:action": "command"
}
```

-   Multiple string commands:

```js
{
  "namespace:action": ["command 1", "command 2"],
}
```

-   Commands object with the following keys:

```js
{
  "namespace:action": {
    "commands": "commands", // (required) Can be a string or an array of strings
    "key": "alt-k", // (optional) A default key binding
    "priority": 100, // (optional) Key binding priority. Default = 0
    "selector": ".css-selector" // (optional) Selector to limit the key binding and context menu. Default = "atom-workspace"
  }
}
```

## Placeholders

Placeholders can be used so commands can use current command target in the commands.
The command target will be the active editor if from the command palette, or selected files if from the tree-view context menu.

-   `${file}` - Replaced with the first target file path
-   `${files}` - Replaced with the targets file paths separated by space
-   `${dir}` - Replaced with the first target directory path
-   `${project}` - Replaced with the first target file's project path
