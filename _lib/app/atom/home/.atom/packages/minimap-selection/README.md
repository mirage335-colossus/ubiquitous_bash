# minimap-selection package [![Build Status](https://travis-ci.org/atom-minimap/minimap-selection.svg?branch=v4.1.0)](https://travis-ci.org/atom-minimap/minimap-selection)

Display the buffer's selections on the minimap

![Screenshot](https://github.com/atom-minimap/minimap-selection/blob/master/screenshot.gif?raw=true)

## Settings

### Highlight Cursors Lines

When enabled, lines that holds a cursors will be highlighted in the minimap.

### Customization

The selection color can be customized using the following CSS rule in your user stylesheet:

```css
.minimap-selection .region {
  background: green;
}
```

When the `Highlight Cursors Lines` setting is enabled the line's highlight color can be customized using the following CSS rule in your user stylesheet:

```css
.minimap-selection .cursor-line {
  background: blue;
}
```

When the `Outline Selection` setting is enabled, the outline color can be customized using the following CSS rule:

```css
.minimap-selection .region-outline {
  background: green;
}
```
