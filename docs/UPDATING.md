# Docs

This folder contains the documentations for Kengine.

Below are notes for myself mostly..

## Updating Docs

1. Copy latest version to a new folder "major.minor"
2. Make your changes to the documentation.
3. Add the version to `otherVersions` in `config.js`. Also set the version to the latest one.
4. Update `package.json`
5. Update `KengineInfo.gml` jsdoc and version.
6. Optional: re-generate APIs by the command `npm run docs:api` and modify them accordingly.
