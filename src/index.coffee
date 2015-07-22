###

# Scriptella

This library is a wrapper for running scriptella.

###
aitutils = require("aitutils").aitutils

file = aitutils.file
logger = aitutils.logger
path = require "path"
shell = require "shelljs"
_ = require "lodash"
Mustache = require "mustache"


exports.Scriptella = {

  testMode: false # When true, the commands are output to the console  

  execute: (scriptPath, properties, locals)->
    command = "scriptella #{scriptPath}"




    if properties?
      propertiesPath = path.normalize(path.dirname(scriptPath) + "/etl.properties")

      propertyTemplate = @generatePropertiesTemplate(properties)
      console.log propertyTemplate
      @writeProperties propertiesPath, propertyTemplate, locals
      console.log propertiesPath


    logger.shell command
    if !@testMode
      cmdoutput = shell.exec(command, {encoding: "utf8", silent: false, async: false })
      if cmdoutput.stdout?
        cmdoutput.stdout.on 'data', (data)->
          console.log data
          exit(1)

  generatePropertiesTemplate: (obj, ancestry)->
    that = @
    lines = ""
    _.forIn obj, (value, key)->
      if ancestry?
        childKey = "#{ancestry}.#{key}"
      else
        childKey = "#{key}"      
      if value instanceof Object
        lines += that.generatePropertiesTemplate(value, childKey)
      else
        lines += "#{childKey}=#{value}\n"
    return lines

  writeProperties: (path, template, locals)->
    if !locals?
      locals = {}
    output = Mustache.render(template, locals)
    file.save path, output

}