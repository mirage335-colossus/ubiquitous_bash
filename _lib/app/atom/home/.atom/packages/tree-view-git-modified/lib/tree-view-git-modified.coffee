{CompositeDisposable} = require 'atom'
{requirePackages} = require 'atom-utils'
TreeViewGitModifiedView = require './tree-view-git-modified-view'

module.exports = TreeViewGitModified =

  treeViewGitModifiedView: null
  subscriptions: null
  isVisible: true

  activate: (state) ->
    @treeViewGitModifiedView = new TreeViewGitModifiedView(state.treeViewGitModifiedViewState)
    @isVisible = state.isVisible

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-git-modified:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-git-modified:openAll': => @openAll()
    @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-git-modified:show': => @show()
    @subscriptions.add atom.commands.add 'atom-workspace', 'tree-view-git-modified:hide': => @hide()

    @subscriptions.add atom.project.onDidChangePaths (path) =>
      @show()

    atom.packages.activatePackage('tree-view').then((pkg) =>

      if pkg && pkg.mainModule && pkg.mainModule.treeView

        treeView = pkg.mainModule.treeView
        if (!@treeViewGitModifiedView)
          @treeViewGitModifiedView = new TreeViewGitModifiedView

        if (treeView && @isVisible) or (@isVisible is undefined)
          @treeViewGitModifiedView.show()

        atom.commands.add 'atom-workspace', 'tree-view:toggle', =>
          if treeView?.isVisible()
            @treeViewGitModifiedView.hide()
          else
            if @isVisible
              @treeViewGitModifiedView.show()

        atom.commands.add 'atom-workspace', 'tree-view:show', =>
          if @isVisible
            @treeViewGitModifiedView.show()
    , null)


  deactivate: ->
    @subscriptions.dispose()
    @treeViewGitModifiedView.destroy()

  serialize: ->
    isVisible: @isVisible
    # treeViewGitModifiedViewState: @treeViewGitModifiedView.serialize()

  toggle: ->
    if @isVisible
      @treeViewGitModifiedView.hide()
    else
      @treeViewGitModifiedView.show()
    @isVisible = !@isVisible

  show: ->
    @treeViewGitModifiedView.show()
    @isVisible = true

  hide: ->
    @treeViewGitModifiedView.hide()
    @isVisible = false

  openAll: ->
    self = this
    repos = atom.project.getRepositories()
    for repo in repos
      innerRepo = repo.repo
      for filePath in Object.keys(innerRepo.getStatus())
          if innerRepo.isPathModified(filePath) or innerRepo.isPathNew(filePath)
              atom.workspace.open(innerRepo.getWorkingDirectory() + '/' + filePath)
