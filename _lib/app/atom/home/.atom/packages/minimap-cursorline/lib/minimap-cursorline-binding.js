'use babel'

import { CompositeDisposable } from 'atom'

export default class MinimapCursorLineBinding {

  constructor (minimap) {
    this.minimap = minimap
    this.subscriptions = new CompositeDisposable()
    this.editor = this.minimap.getTextEditor()
    this.decorationsByMarkerId = {}
    this.decorationSubscriptionsByMarkerId = {}

    this.subscriptions.add(this.editor.observeCursors((cursor) => {
      this.handleMarker(cursor.getMarker())
    }))
  }

  handleMarker (marker) {
    const { id } = marker
    const decoration = this.minimap.decorateMarker(
      marker, { type: 'line', class: 'cursor-line' }
    )
    this.decorationsByMarkerId[id] = decoration
    this.decorationSubscriptionsByMarkerId[id] = decoration.onDidDestroy(() => {
      this.decorationSubscriptionsByMarkerId[id].dispose()

      delete this.decorationsByMarkerId[id]
      delete this.decorationSubscriptionsByMarkerId[id]
    })
  }

  destroy () {
    for (const id in this.decorationsByMarkerId) {
      const decoration = this.decorationsByMarkerId[id]
      this.decorationSubscriptionsByMarkerId[id].dispose()
      decoration.destroy()

      delete this.decorationsByMarkerId[id]
      delete this.decorationSubscriptionsByMarkerId[id]
    }

    this.subscriptions.dispose()
  }

}
