'use babel'

import { CompositeDisposable } from 'atom'

var MinimapCursorLineBinding = null

export default {

  active: false,

  isActive () { return this.active },

  bindings: {},

  activate (state) {},

  consumeMinimapServiceV1 (minimap) {
    this.minimap = minimap
    this.minimap.registerPlugin('cursorline', this)
  },

  deactivate () {
    if (!this.minimap) { return }
    this.minimap.unregisterPlugin('cursorline')
    this.minimap = null
  },

  activatePlugin () {
    if (this.active) { return }

    this.subscriptions = new CompositeDisposable()
    this.active = true

    this.minimapsSubscription = this.minimap.observeMinimaps((minimap) => {
      if (MinimapCursorLineBinding === null) {
        MinimapCursorLineBinding = require('./minimap-cursorline-binding')
      }

      const id = minimap.id
      const binding = new MinimapCursorLineBinding(minimap)
      this.bindings[id] = binding

      const subscription = minimap.onDidDestroy(() => {
        binding.destroy()
        this.subscriptions.remove(subscription)
        subscription.dispose()
        delete this.bindings[id]
      })

      this.subscriptions.add(subscription)
    })
  },

  deactivatePlugin () {
    if (!this.active) { return }

    for (const id in this.bindings) { this.bindings[id].destroy() }
    this.bindings = {}
    this.active = false
    this.minimapsSubscription.dispose()
    this.subscriptions.dispose()
  }

}
