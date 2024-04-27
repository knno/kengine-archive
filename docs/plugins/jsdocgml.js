exports.handlers = {
    beforeParse: function(e) {
        const str = e.source;
        // Regular expression for JSDOCs (group m) and rest of text (group t).
        const regex = /(?<m>[ \t]*(?:(?:\/\*\*\s*(?:.*))\n(?:[^\*]|(?:\*(?!\/)))*\*\/)|(?:(?:\/{3}\s*(?:.*)\n?)+))|(?<t>.+)/gm;
        // Only keep group m in str.
        const subst = `$<m>`;
        const result = str.replace(regex, subst);
        // Store actual source by filename in `this`.
        this._actualSourcesByFilename = this._actualSourcesByFilename || {};
        this._actualSourcesByFilename[e.filename] = e.source;
        // Use new source (to make parsing jsdocs regardless of language.)
        e.source = result;
    },
    fileComplete: function(e) {
        // Restore source for when opening source files in the docs.
        e.source = this._actualSourcesByFilename[e.filename];
    }
};

exports.defineTags = function(dictionary) {
    // A tag to display constructor usage of a class.
    dictionary.defineTag("new_name", {
        mustHaveValue: true,
        onTagged: function(doclet, tag) {
            doclet.new_name = tag.value;
        }
    })
    dictionary.defineTag("main_namespace", {
        mustNotHaveValue: true,
        onTagged: function(doclet, tag) {
            doclet.definedAsMainNamespace = true;
        }
    });
};
