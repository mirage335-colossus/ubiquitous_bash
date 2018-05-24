
# lib/command-toolbar.coffee

fs          = require 'fs'
pathUtil    = require 'path'
ToolbarView = require './toolbar-view'

class CommandToolbar
  config:
    alwaysShowToolbarOnLoad:
      title: 'Always show command bar when Atom opens'
      type: 'boolean'
      default: true

    useRightPane:
      title: 'Open web pages in a right pane'
      type: 'boolean'
      default: false

  activate: ->
    @state = 
      statePath: pathUtil.dirname(atom.config.getUserConfigPath()) +
                  '/command-toolbar.json'
    try 
      @state = JSON.parse fs.readFileSync @state.statePath
    catch e
      @state.opened = yes
      
    if atom.config.get 'command-toolbar.alwaysShowToolbarOnLoad'
      @state.opened = yes
    if @state.opened then @toggle yes
    
    @sub = atom.commands.add 'atom-workspace', 'command-toolbar:toggle': => @toggle()
    
  toggle: (forceOn) ->
    if forceOn or not @state.opened
      @state.opened = yes
      @toolbarView ?= new ToolbarView @, @state
      @toolbarView.show()
      @toolbarView.saveState()
    else
      @state.opened = no
      @toolbarView.saveState()
      @toolbarView?.hide()
          
  destroyToolbar: -> @toolbarView?.destroy()
    
  deactivate: ->
    @sub.dispose()
    @destroyToolbar()
    
module.exports = new CommandToolbar
