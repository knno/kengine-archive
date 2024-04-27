/// A script to generate markdown from GML code.
/// Written by Kenan Masri.
"use strict";

const mainNamespaceName = "Kengine";
const mainNamespaceLongname = mainNamespaceName;
const perNamespace = true;

const jsdoc2md = require("jsdoc-to-markdown");
const fs = require("fs");
const Path = require("path");
var argv = require("minimist")(process.argv.slice(2));
const FileSet = require("file-set");
const config = require("../config.js");

let configure = argv.configure;
let outputDir = Path.join(
  __dirname,
  "..",
  config.latestVersion,
  argv.destination ?? ""
);
let partials = argv.partials;

const templateData = jsdoc2md.getTemplateDataSync({
  configure: configure,
  files: argv._,
});

function isParentWithinDepth(path1, path2, depth = 1) {
  const parts1 = path1.split(".");
  const parts2 = path2.split(".");

  // Compare segments up to the shorter path length
  const minLength = Math.min(parts1.length, parts2.length);
  for (let i = 0; i < minLength; i++) {
    if (parts1[i] !== parts2[i]) {
      return false;
    }
  }

  // If path1 is shorter than path2, it is a parent
  if (parts1.length <= parts2.length - 1) {
    return parts2.length - parts1.length == depth;
  }
  return false;
}

function setUpNamespaceTemplateData(name) {
  let mainNamespaceNames = [];
  let namespaceNames = templateData.reduce((namespaceNames, identifier) => {
    identifier.lowerLongname = `${identifier.longname
      .toLowerCase()
      .replace(/\./g, "-")}`;

    if (identifier.returns) {
      for (const ret of identifier.returns) {
        if (ret.description) {
          if (ret.description.startsWith("<p>")) {
            ret.description = ret.description.replace(/<p>(.*)<\/p>/gs, "$1");
          }
        }
      }
    }

    if (identifier.description) {
      if (identifier.description.startsWith("<p>")) {
        identifier.description = identifier.description.replace(
          /<p>(.*)<\/p>/gs,
          "$1"
        );
      }
    }

    if (identifier.kind === "namespace") {
      if (identifier.memberof == "undefined" || (identifier.definedAsMainNamespace == true)) {
        identifier.hideDetails = false;
        mainNamespaceNames.push(identifier.longname);
      }
      namespaceNames.push([identifier.name, identifier.longname]);
    }
    if (identifier.memberof == name) {
      identifier.isInMainNamespace = true;
    }
    return namespaceNames;
  }, []);
  return [namespaceNames, mainNamespaceNames];
}

function namespacedTemplateData(
  namespaceLongName,
  allTemplateData,
  mainNamespaceNames,
  depth = 1
) {
  subTemplateDatas = [];

  for (const templateDatum of allTemplateData) {

    templateDatum.hideDetails = false;

    if (templateDatum.kind == "namespace") {
      if (mainNamespaceNames.indexOf(templateDatum.longname) != -1 && mainNamespaceNames.indexOf(namespaceLongName) == -1) {
        templateDatum.hideDetails = true;
      }
    }

    if (templateDatum.longname == namespaceLongName) {
      if (subTemplateDatas.indexOf(templateDatum) == -1) {
        subTemplateDatas.push(templateDatum);
      }
    }

    if (templateDatum.memberof !== undefined) {
      //if (mainNamespaceNames.indexOf(templateDatum.memberof) == -1) {
        if (
          isParentWithinDepth(
            namespaceLongName,
            templateDatum.memberof,
            depth
          ) ||
          templateDatum.memberof == namespaceLongName
        ) {
          if (subTemplateDatas.indexOf(templateDatum) == -1) {
            subTemplateDatas.push(templateDatum);
          }
        }
      //}
    }
  }
  return subTemplateDatas;
}

function writeOne(namespaceName, namespaceLongName, opts) {
  const template = `{{#namespace name="${namespaceName}"}}{{>docs}}{{/namespace}}`;
  const outputFile = Path.resolve(outputDir, `${namespaceLongName}.md`);
  opts.template = template;
  console.log(`rendering ${namespaceLongName}`);
  var output = jsdoc2md.renderSync(opts);

  // Links
  let reg = /\[([^ \t]*)\]\(#?([^ \t]*)\)/gm;
  let noLinks = [
    'Kengine.Utils',
  ]
  output = output.replace(reg, (match, displayText, urlText) => {
    for (var [_nsn, nsln] of Array.from(namespaceNames).sort(function (a, b) {
      return b[1].length - a[1].length;
    })) {
      if (urlText.startsWith(nsln)) {
        urlText = urlText
          .replace(nsln + ".", nsln + "?id=")
          .replace(/\?id=.*$/, `?id=${urlText.toLowerCase()}`);
        break;
      }
    }
    if (noLinks.indexOf(urlText.split('?id=')[0]) !== -1) {
      return displayText
    }
    let ret = `[${displayText}](${urlText})`;
    return ret;
  });

  reg = /\`([^ \t]*)\` [^⇒]/gm;
  output = output.replace(reg, (match, displayText) => {
    let urlText = displayText;
    for (var [_nsn, nsln] of Array.from(namespaceNames).sort(function (a, b) {
      return b[1].length - a[1].length;
    })) {
      if (displayText.startsWith(nsln)) {
        urlText = urlText
          .replace(nsln + ".", nsln + "?id=")
          .replace(/\?id=.*$/, `?id=${urlText.toLowerCase()}`);
        break;
      }
    }
    if (noLinks.indexOf(urlText.split('?id=')[0]) !== -1) {
      return displayText
    }
    let ret = `[${displayText}](${urlText})`;
    return ret;
  });

  fs.writeFileSync(outputFile, output);
  return outputFile;
}

var opts = {
  "name-format": true,
  "heading-depth": 1,
  data: templateData,
  "example-lang": "gml",
};
if (typeof partials != undefined) {
  partials = Path.resolve(partials, "./**/*.hbs");
  const fileSet = new FileSet(partials);
  opts.partial = fileSet.files;
}

let subTemplateDatas = [];

let [namespaceNames, mainNamespaceNames] = setUpNamespaceTemplateData(
  mainNamespaceLongname
);

if (perNamespace) {
  for (const [namespaceName, namespaceLongName] of namespaceNames) {
    opts.data = namespacedTemplateData(
      namespaceLongName,
      templateData,
      mainNamespaceNames
    );
    writeOne(namespaceName, namespaceLongName, opts);
  }
} else {
  opts.data = templateData;
  writeOne(mainNamespaceName, mainNamespaceLongname, opts);
}

console.log(`All written to "${outputDir}"\nPlease update accordingly`);
