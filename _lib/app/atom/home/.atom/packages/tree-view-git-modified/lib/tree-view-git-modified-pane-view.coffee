{CompositeDisposable} = require 'event-kit'
_ = require 'lodash'
{$} = require 'space-pen'

module.exports =
class TreeViewOpenFilesPaneView

  constructor: (repo) ->
    @items = []
    @panes = []
    @activeItem = null
    @repo = repo
    @paneSub = new CompositeDisposable

    repoPath = repo.getWorkingDirectory()
    repoName = repoPath.split('/')[repoPath.split('/').length-1]

    @element = document.createElement('li')
    @element.setAttribute('is', 'tree-view-git-modified')
    @element.classList.add('tree-view-git-modified', 'list-nested-item', 'expanded')
    @container = document.createElement('ol')
    @container.classList.add('entries', 'list-tree')
    @header = document.createElement('div')
    @header.classList.add('header', 'list-item')

    headerSpan = document.createElement('span')
    headerSpan.classList.add('name', 'icon', 'icon-mark-github')
    headerSpan.setAttribute('data-name', 'Git Modified: ' + repoName)
    headerSpan.innerText = 'Git Modified: ' + repoName
    @header.appendChild headerSpan
    @element.appendChild @header
    @element.appendChild @container

    $(@header).on 'click', ->
      nested = $(this).closest('.list-nested-item')
      nested.toggleClass('expanded')
      nested.toggleClass('collapsed')

    # @loadRepo()
    self = this

    $(@element).on 'click', '.list-item[is=tree-view-file]', ->
      atom.workspace.open(self.entryForElement(this).item)

  setRepo: (repo) ->
    self = this
    @repo = repo
    @reloadStatuses self, repo
    if (repo.onDidChangeStatuses? or repo.onDidChangeStatus?)
      repo.onDidChangeStatuses =>
        self.reloadStatuses self, repo
        , (err) ->
          console.log err
      repo.onDidChangeStatus (item) =>
        self.reloadStatuses self, repo
        , (err) ->
          console.log err
    else
      self.removeAll()

  reloadStatuses: (self, repo) ->
    if self.isReloading
      console.warn 'Already performing reloadStatuses -- skipping this one!'
    else if repo?
      self.isReloading = true
      self.removeAll()
      repoPath = repo.getWorkingDirectory()
      innerRepo = repo.getRepo()
      for filePath in Object.keys(innerRepo.getStatus())
        if innerRepo.isPathModified(filePath)
          self.addItem filePath, repoPath, 'status-modified'
        if repo.isPathNew(filePath)
          self.addItem filePath, repoPath, 'status-new'
      self.isReloading = false

  setPane: (pane) ->
    @paneSub.add pane.observeActiveItem (item) =>
      @activeItem = item
      @setActiveEntry item

    @paneSub.add pane.onDidChangeActiveItem (item) =>
      if (!item)
        @activeEntry?.classList.remove 'selected'

    @paneSub.add pane.onDidChangeActive (isActive) =>
      @activeItem = pane.activeItem
      if (isActive)
        @setActiveEntry pane.activeItem

  addItem: (item, repoPath, status) ->
    # Checks if item already exists to avoid adding it twice
    exists = _.findIndex @items, (itemsItem) -> itemsItem.item is item

    if (exists < 0)
      listItem = document.createElement('li')
      listItem.classList.add('file', 'list-item', status)
      listItem.setAttribute('is', 'tree-view-file')
      listItemName = document.createElement('span')
      listItemName.innerText = item.split('/')[item.split('/').length-1]
      listItemName.classList.add('name', 'icon', 'icon-file-text')
      listItemName.setAttribute('data-path', item)
      listItemName.setAttribute('data-name', item)
      listItemName.setAttribute('data-repo-path', repoPath)
      listItem.appendChild listItemName

      listItemStatus = document.createElement('span')

      if (status == 'status-modified')
        listItemStatus.innerText = 'M'

      if (status == 'status-new')
        listItemStatus.innerText = 'N'

      listItemStatus.classList.add('pull-right')

      listItem.appendChild listItemStatus

      @container.appendChild listItem

      item = repoPath + '/' + item

      @items.push item: item, element: listItem

      if (@activeItem)
        @setActiveEntry @activeItem

  updateTitle: (item, siblings=true, useLongTitle=false) ->
    title = item.getTitle()

    if siblings
      for entry in @items
        if entry.item isnt item and entry.item.getTitle?() == title
          useLongTitle = true
          @updateTitle entry.item, false, true

    if useLongTitle and item.getLongTitle?
      title = item.getLongTitle()

    if entry = @entryForItem(item)
      $(entry.element).find('.name').text title

  entryForItem: (item) ->
    _.detect @items, (entry) ->
      if item.buffer && item.buffer.file
        item.buffer.file.path.indexOf(entry.item) > -1

  entryForElement: (item) ->
    _.detect @items, (entry) ->
      if (entry.element is item)
        return item

  setActiveEntry: (item) ->
    if item
      @activeEntry?.classList.remove 'selected'
      if entry = @entryForItem item
        entry.element.classList.add 'selected'
        @activeEntry = entry.element

  removeAll: ->
    for item in @items
      item.element.remove()
    @items = []

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  hide: ->
    @element.classList.add 'hidden'

  show: ->
    @element.classList.remove 'hidden'

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    @paneSub.dispose()
