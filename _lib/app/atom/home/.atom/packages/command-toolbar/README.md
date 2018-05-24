command-toolbar
===============

Atom editor toolbar with easily customized buttons for any command.

![Image inserted by Atom editor package auto-host-markdown-image](http://i.imgur.com/WKiq18y.gif?delhash=yjNlcuDbSIQTrEX)

## Installation

Run `apm install command-toolbar` or use the settings screen.

## Usage

* **Open/close** the toolbar using the command `command-toolbar:toggle`.  By default it is bound to the key `ctrl-6`.
* **Execute** a command by simply clicking on its button.
* **Create** a button by clicking on the first icon (three bars). A selection box identical to the command palette will pop up.  Choose a command and a new button for that command will appear in the toolbar.  Ctrl-click will add the location of the selected tab.  See below.
* **Edit** a button label by clicking on the button with the ctrl key held down.
  * Note: There is currently a problem with ctrl-click on some setups.  If you have trouble you may use alt-click instead.
* **Rearrange** buttons by clicking and dragging them.
* **Delete** buttons by clicking on the button and dragging the cursor away from the bar.  The btn will not move before deletion.
* **Move** the toolbar to any of the four sides of the window by clicking on the first icon (three bars) and dragging the cursor to the middle of a different side.
* **View** the complete command assigned to a button by hovering over it for one second.
* **Close** the toolbar by clicking on the globe on the far left.

## Files and Web pages

If you `ctrl-click` the first icon (three bars) it will add a button as usual.  But instead of opening the command palette to choose a command it will create a button immediately with the file path of the currently selected tab.  Clicking on this button will open the file just as if you clicked in the file tree.  Files can be opened no matter what project is open. The button always opens that file.

If you have the `web-browser` package installed and the currently selected teb is a web page, then `ctrl-click` will create a button for that web URL.  Clicking on that button will open the web page at any time, even when the web browser toolbar isn't open.  This means this button toolbar can be the "favorites" toolbar for the web browser.

This means this command-toolbar package can have buttons for commands, files, and web pages all at once.


## Configuration

There is one setting `Always Show Toolbar On Load`. If it is checked then the toolbar will always be loaded when Atom is loaded.  If not checked then the toolbar will be visible on load only if it was visible when Atom was closed.

## License

command-toolbar is copyright Mark Hahn with the MIT license.

