AtomGitDiffDetailsView = require "./git-diff-details-view"

module.exports =
  config:
    closeAfterCopy:
      type: "boolean"
      default: false
      title: "Close diff view after copy"

    keepViewToggled:
      type: "boolean"
      default: true
      title: "Keep view toggled when leaving a diff"

    enableSyntaxHighlighting:
      type: "boolean"
      default: false
      title: "Enable syntax highlighting in diff view"

    showWordDiffs:
      type: "boolean"
      default: true
      title: "Show word diffs"

  activate: ->
    atom.workspace.observeTextEditors (editor) ->
      new AtomGitDiffDetailsView(editor)
