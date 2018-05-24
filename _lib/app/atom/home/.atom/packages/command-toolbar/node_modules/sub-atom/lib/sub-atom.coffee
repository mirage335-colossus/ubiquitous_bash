###
  lib/sub-atom.coffee
###

{CompositeDisposable, Disposable} = require 'atom'
$ = require 'jquery'

module.exports = 
class SubAtom
  
  constructor: -> 
    @disposables = new CompositeDisposable

  addDisposable: (disposable, disposeEventObj, disposeEventType) ->
    if disposeEventObj
      try
        autoDisposables = new CompositeDisposable
        autoDisposables.add disposable
        autoDisposables.add disposeEventObj[disposeEventType] =>
          autoDisposables.dispose()
          @disposables.remove autoDisposables
        @disposables.add autoDisposables
        autoDisposables
      catch e
        console.log 'SubAtom::add, invalid dispose event', disposeEventObj, disposeEventType, e
    else
      @disposables.add disposable
      disposable
        
  addElementListener: (ele, events, selector, disposeEventObj, disposeEventType, handler) ->
    if selector
      subscription = $(ele).on events, selector, handler
    else
      subscription = $(ele).on events, handler
    disposable = new Disposable -> subscription.off events, handler
    @addDisposable disposable, disposeEventObj, disposeEventType
  
  add: (args...) ->
    signature = ''
    for arg in args 
      switch typeof arg
        when 'string'   then signature += 's'
        when 'object'   then signature += 'o'
        when 'function' then signature += 'f'
    switch signature
      when 'o', 'oos' then @addDisposable args...
      when 'ssf', 'osf'      
        [ele, events, handler] = args
        @addElementListener ele, events, selector, disposeEventObj, disposeEventType, handler
      when 'ossf', 'sssf'     
        [ele, events, selector, handler] = args
        @addElementListener ele, events, selector, disposeEventObj, disposeEventType, handler
      when 'ososf', 'ssosf'
        [ele, events, disposeEventObj, disposeEventType, handler] = args
        @addElementListener ele, events, selector, disposeEventObj, disposeEventType, handler
      when 'ossosf', 'sssosf'
        [ele, events, selector, disposeEventObj, disposeEventType, handler] = args
        @addElementListener ele, events, selector, disposeEventObj, disposeEventType, handler
      else 
        console.log 'SubAtom::add, invalid call signature', args
        return

  remove: (args...) -> 
    @disposables.remove args...
    
  clear: -> 
    @disposables.clear()

  dispose: -> 
    @disposables.dispose()
