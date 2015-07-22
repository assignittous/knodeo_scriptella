
/*

 * Scriptella

This library is a wrapper for running scriptella.
 */
var Mustache, _, aitutils, file, logger, path, shell;

aitutils = require("aitutils").aitutils;

file = aitutils.file;

logger = aitutils.logger;

path = require("path");

shell = require("shelljs");

_ = require("lodash");

Mustache = require("mustache");

exports.Scriptella = {
  testMode: false,
  execute: function(scriptPath, properties, locals) {
    var cmdoutput, command, propertiesPath, propertyTemplate;
    command = "scriptella " + scriptPath;
    if (properties != null) {
      propertiesPath = path.normalize(path.dirname(scriptPath) + "/etl.properties");
      propertyTemplate = this.generatePropertiesTemplate(properties);
      console.log(propertyTemplate);
      this.writeProperties(propertiesPath, propertyTemplate, locals);
      console.log(propertiesPath);
    }
    logger.shell(command);
    if (!this.testMode) {
      cmdoutput = shell.exec(command, {
        encoding: "utf8",
        silent: false,
        async: false
      });
      if (cmdoutput.stdout != null) {
        return cmdoutput.stdout.on('data', function(data) {
          console.log(data);
          return exit(1);
        });
      }
    }
  },
  generatePropertiesTemplate: function(obj, ancestry) {
    var lines, that;
    that = this;
    lines = "";
    _.forIn(obj, function(value, key) {
      var childKey;
      if (ancestry != null) {
        childKey = ancestry + "." + key;
      } else {
        childKey = "" + key;
      }
      if (value instanceof Object) {
        return lines += that.generatePropertiesTemplate(value, childKey);
      } else {
        return lines += childKey + "=" + value + "\n";
      }
    });
    return lines;
  },
  writeProperties: function(path, template, locals) {
    var output;
    if (locals == null) {
      locals = {};
    }
    output = Mustache.render(template, locals);
    return file.save(path, output);
  }
};
