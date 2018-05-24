# sub-atom npm module for Atom packages

A replacement (wrapper) for Atom's CompositeDisposable for easy subscribing to DOM events.

This NPM module is intended only for use in add-on packages for GitHub's Atom editor.  The sub-atom repo is at https://github.com/mark-hahn/sub-atom.  Feel free to ask questions at the Atom discussion group: https://discuss.atom.io/.

Sub-atom is a wrapper of of Atom's `CompositeDisposable` which is an Atom class that collects `Disposable` objects that enable disposing of event handlers.  `CompositeDisposable` has no provision for handling events on DOM elements.  The Atom docs say to do this for each DOM event subscription ...

```coffeescript
$(window).on 'focus', focusCallback
disposables.add new Disposable ->
  $(window).off 'focus', focusCallback
```

This is very boated code for what it does.  Sub-atom provides the class `SubAtom` which is 100% compatible with the Atom class `CompositeDisposable` but can also replace the code above with a single line.

Sub-atom also has a convenience feature that ties a disposable to an event.  When the event fires the disposable is automatically disposed.

## Usage
  
To install sub-atom simply use `npm install sub-atom`.  Then load and initialize the sub-atom module with ...

```coffeescript
SubAtom = require('sub-atom')
subs = new SubAtom
```

### Add A Disposable

The `subs` object has a function `add` that can be used exactly as `CompositeDisposable::add` is used.  An example ...

```coffeescript
subs.add editor.onDidChange ->
```

### Create And Add A DOM Subscription

The same function `add` can create a DOM subscription and add a disposable for that subscription with this signature. This uses `jQuery::on` internally.

```coffeescript
subs.add target, events, [selector], handler
```

**target:** A DOM element, jQuery object, or a selector.  This is wrapped by jQuery before attaching the subscription.   

**events:** One or more space-separated event types and optional namespaces, such as "click" or "keydown.myPlugin". 

**selector:** A selector string to filter the descendants of the selected elements that trigger the event. If the selector is null or omitted, then only the target element can trigger the event.

**handler:** A function to execute when the event is triggered. The value false is also allowed as a shorthand for a function that simply does return false.

**Note:** `SubAtom::add` returns a jQuery object. You can get the native event with `event.originalEvent`.


### Auto-Dispose On Event

When you attach a subscription to an element, you need to dispose the subscription when the element is destroyed instead of waiting until the end when everything is disposed.  This is complex and often not handled properly.  Atom-sub makes this easy.

This is an example of the normal method to attach a click subscription to a paneView and dispose the subscription when the pane is destroyed ...

```coffeescript
paneSubs = new SubAtom
paneSubs.add paneView, 'click', => @click pane
paneSubs.add pane.onDidDestroy ->
  paneSubs.dispose()
  @subs.remove paneSubs
@subs.add paneSubs
```

This is the sub-atom version.  Notice that it replaces the six lines with one line and is more readable.

```coffeescript
@subs paneView, 'click', pane, 'onDidDestroy', => @click pane
```

This feature is enabled by adding the tigger event to the add function as two arguments, the object and the name of the method on that object. The new signatures are ...

```coffeescript
subs.add disposable, eventObject, eventName
subs.add target, events, [selector], eventObject, eventName, handler
```

### Clear, Remove, and Dispose functions

The atom-sub instance also supports the other functions that CompositeDisposable provides.  These calls are passed through directly to the internal wrapped CompositeDisposable.

For example, there is the function `dispose` that disposes all added events.  This is identical to the method `CompositeDisposable::dispose`. Use ...

```coffeescript
subs.dispose()
```


## License

Sub-atom is copyright Mark Hahn with the MIT license.