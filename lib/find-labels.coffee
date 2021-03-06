fsPlus = require 'fs-plus'
fs = require 'fs-plus'
path = require 'path'

module.exports =
FindLabels =
  getLabelsByText: (text, file = "") ->
    labelRex = /\\label{([^}]+)}/g
    matches = []
    while (match = labelRex.exec(text))
      matches.push {label: match[1]}
    return matches unless file?
    inputRex = /\\(input|include){([^}]+)}/g
    while (match = inputRex.exec(text))
      matches = matches.concat(@getLabels(@getAbsolutePath(file, match[2])))
    matches

  getLabels: (file) ->
    return [] unless fsPlus.isFileSync(file)
    text = fs.readFileSync(file).toString()
    @getLabelsByText(text, file)

  getAbsolutePath: (file, relativePath) ->
    if (ind = file.lastIndexOf("/")) isnt file.length
      file = file.substring(0,ind)
    path.resolve(file, relativePath)
