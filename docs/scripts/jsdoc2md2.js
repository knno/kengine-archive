/// A script to generate markdown from GML code.
/// Written by Kenan Masri.
"use strict";

const jsdoc2md = require("jsdoc-to-markdown");
const fs = require("fs");
const Path = require("path");
const dmd = require("dmd");
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

/* reduce templateData to an array of namespaces names */
const mainNamespaceNames = [];
const namespaceNames = templateData.reduce((namespaceNames, identifier) => {
  if (identifier.kind === "namespace") {
    identifier.isNamespace = true;
    if (
      typeof identifier.memberof === "undefined" ||
      identifier.memberof === "Kengine"
    ) {
      if (identifier.memberof === "Kengine") {
        identifier.isMainNamespace = true;
      } else {
        identifier.isInMainNamespace = true;
      }
      mainNamespaceNames.push(identifier.longname);
      namespaceNames.push([identifier.name, identifier.longname]);
      identifier.isSeparateFile = true;
    }
    if (mainNamespaceNames.indexOf(identifier.memberof) != -1) {
      namespaceNames.push([identifier.name, identifier.longname]);
      identifier.isSeparateFile = true;
    }
  }
  return namespaceNames;
}, []);

var opts = { data: templateData, "example-lang": "gml" };
if (typeof partials != undefined) {
  partials = Path.resolve(partials, "./**/*.hbs");
  const fileSet = new FileSet(partials);
  opts.partial = fileSet.files;
}

for (const [namespaceName, namespaceLongName] of namespaceNames) {
  const template = `{{#namespace name="${namespaceName}"}}{{>docs}}{{/namespace}}`;
  const outputFile = Path.resolve(outputDir, `${namespaceLongName}.md`);
  opts.template = template;
  console.log(`rendering ${namespaceLongName}`);
  const output = jsdoc2md.renderSync(opts);
  fs.writeFileSync(outputFile, output);
}

console.log(`All written to "${outputDir}"\nPlease update accordingly`);
