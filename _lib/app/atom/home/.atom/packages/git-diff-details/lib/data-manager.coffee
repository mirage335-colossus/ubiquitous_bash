JsDiff = require('diff')

module.exports = class DiffDetailsDataManager
  constructor: ->
    @invalidate()

  liesBetween: (hunk, row) ->
    hunk.start <= row <= hunk.end

  isDifferentHunk: ->
    if @previousSelectedHunk? and @previousSelectedHunk.start? and @selectedHunk? and @selectedHunk.start?
      return @selectedHunk.start != @previousSelectedHunk.start
    return true

  getSelectedHunk: (currentRow) ->
    if !@selectedHunk? or @selectedHunkInvalidated or !@liesBetween(@selectedHunk, currentRow)
      @updateLineDiffDetails()
      @updateSelectedHunk(currentRow)

    @selectedHunkInvalidated = false

    isDifferent = @isDifferentHunk()

    @previousSelectedHunk = @selectedHunk

    {selectedHunk: @selectedHunk, isDifferent}

  updateSelectedHunk: (currentRow) ->
    @selectedHunk = null

    if @lineDiffDetails?
      for hunk in @lineDiffDetails
        if @liesBetween(hunk, currentRow)
          @selectedHunk = hunk
          break

  updateLineDiffDetails: ->
    if !@lineDiffDetails? or @lineDiffDetailsInvalidated
      @prepareLineDiffDetails(@repo, @path, @text)
      @prepareWordDiffs(@lineDiffDetails) if @lineDiffDetails

    @lineDiffDetailsInvalidated = false
    @lineDiffDetails

  prepareLineDiffDetails: (repo, path, text) ->
    @lineDiffDetails = null

    repo = repo.getRepo(path)

    options = ignoreEolWhitespace: process.platform is 'win32'

    rawLineDiffDetails = repo.getLineDiffDetails(repo.relativize(path), text, options)

    return unless rawLineDiffDetails?

    @lineDiffDetails = []
    hunk = null

    for {oldStart, newStart, oldLines, newLines, oldLineNumber, newLineNumber, line} in rawLineDiffDetails
      # process modifications and deletions only
      unless oldLines is 0 and newLines > 0
        # create a new hunk entry if the hunk start of the previous line
        # is different to the current
        if not hunk? or (newStart isnt hunk.start)
          newEnd = null
          kind = null
          if newLines is 0 and oldLines > 0
            newEnd = newStart
            kind = "d"
          else
            newEnd = newStart + newLines - 1
            kind = "m"

          hunk = {
            start: newStart, end: newEnd,
            oldLines: [], newLines: [],
            newString: "", oldString: ""
            kind
          }
          @lineDiffDetails.push(hunk)

        if newLineNumber >= 0
          hunk.newLines.push(line)
          hunk.newString += line
        else
          hunk.oldLines.push(line)
          hunk.oldString += line

  prepareWordDiffs: (lineDiffDetails) ->
    for hunk in lineDiffDetails
      continue if hunk.kind isnt "m" or hunk.newLines.length != hunk.oldLines.length
      hunk.newWords = []
      hunk.oldWords = []
      for i in [0...hunk.newLines.length] by 1
        newCol = oldCol = 0
        diff = JsDiff.diffWordsWithSpace(hunk.oldLines[i], hunk.newLines[i])
        for word in diff
          word.offsetRow = i
          if word.added
            word.changed = true
            word.startCol = newCol
            newCol += word.value.length
            word.endCol = newCol
            hunk.newWords.push(word)
          else if word.removed
            word.changed = true
            word.startCol = oldCol
            oldCol += word.value.length
            word.endCol = oldCol
            hunk.oldWords.push(word)
          else
            newCol += word.value.length
            oldCol += word.value.length
            hunk.newWords.push(word)
            hunk.oldWords.push(word)

  invalidate: (@repo, @path, @text) ->
    @selectedHunkInvalidated = true
    @lineDiffDetailsInvalidated = true
    @invalidatePreviousSelectedHunk()

  invalidatePreviousSelectedHunk: ->
    @previousSelectedHunk = null
