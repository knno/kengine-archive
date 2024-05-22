<img src="https://raw.githubusercontent.com/knno/kengine/main/images/ICON.png" width="50%" style="display: block; margin: auto;" />
<h1 align="center">Kengine 0.2</h1>
<p align="center">A GameMaker framework for modding support of your projects by <a href="https://www.kenanmasri.com/" target="_blank">Kenan Masri (knno)</a></p>
<p align="center"><a href="https://github.com/knno/kengine/releases/" target="_blank">Download the .yymps</a></p>

<a id="readme-top"></a>

---

<!-- ABOUT THE PROJECT -->

## About The Project {docsify-ignore}

<!-- [![Kengine concept img][concept-img]](https://knno.github.io/kengine) -->

### Introduction

Sometimes, you want to make your GameMaker project moddable by your end-users community, or you want to make DLC content for your game.

For example, here's a few possible scenarios:

* Adding and replacing in-game assets.
* Modifying the assets dynamically by reading archive files, or with code from an API.
* Enable support for mod files of your game that would manipulate some of the assets.
* Allow the user to enable and disable mods.
* So on... ⭐

Of course, your exact implementations and needs may be different. This is found as a base project template for those requirements.

It is made in a way that can be added to existing projects, too.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### What is Kengine?

Kengine is a big library. It is a set of scripts that add many possibilites to your GameMaker project. Programmatically it is a singleton in your game that you can access anytime for different uses. It comprises namespaces such as:

- [Utils](Utils)
- [Extensions](Extensions)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->

## Getting Started

### Quick Install/Usage

1. Download the latest .yymps from the Releases tab of GitHub.
2. Import the downloaded file into your project by `Tools > Import local package`.
3. Add `obj_kengine` object to your very first room.
4. Start using the engine in your code! See below.
5. Done

### Quick Upgrade

1. Download the latest .yymps from the Releases tab of GitHub.
2. Backup your `KengineConfig` script in your GameMaker project to **another location**.
3. Backup your `KengineAssetTypes` script in your GameMaker project to **another location**.
4. Delete the `Kengine` folder in your project.
5. Import the downloaded file into your project by `Tools > Import local package`.
6. Compare the values of both `KengineConfig` scripts. It is recommended to use the newer values.
7. Do the same for the `KengineAssetTypes` scripts **carefully**. See the changelogs and act upon it if you have custom definitions.
8. Don't forget to add `obj_kengine` object to your very first room!
9. Done

> If you'd like to sync the project however with all the projects you are working on, you can use my [GmDm](https://github.com/knno/gmdm) program. Simply clone the repository into a location for GmDm to > find, and install it by adding this link to your `gmdm.yml` file in your new/exiting project(s):
> ```yml
> name: my project.yyp
> imports:
>   - Kengine
> ```
> 
> This enables syncing it with all your projects and the base Kengine project. Or, you can simply refer back to installation/upgrade guide above.
> 


<!-- USAGE -->

## Usage

> Note that there are many uses of Kengine.
> Ranging from replacing a simple asset, to managing game mods.

Below are a few examples on how to use Kengine.

### Simplest Asset Replacement Usage

Let's assume you want to use a sprite that is replaceable or addable, for an object already in your asset resources,
see the following code as an example.

```gml
/// obj_player : Creation Code

// obj_player has  spr_player initially.
// whether sprite is replaced or not, we must "refresh the sprite handle"

sprite_index = Kengine.Utils.GetAsset("sprite", "spr_player").id;

// This code updates the object's sprite to a different sprite
// since it is added or "replaced" to the runtime of your game.
```

You must check if the asset is there, but it's not necessary **unless if it's not in the asset resources before.** because assets are indexed by default.

```gml
var spr_asset = Kengine.Utils.GetAsset("sprite", "new_spr_player");
if asset != undefined {
  sprite_index = spr_asset.id;
} else {
  // Keep the sprite.
}
```

> #### A note on custom objects
> Did you know that you don't actually have to set the `sprite_index` if your object is a Kengine object (a custom asset) from a mod? Since mods can self-reference sprites they have in definition. Example mod as below
> ```yml
> assets:
>   sprite:
>     - spr_new_player: ...
>   object:
>     - obj_new_player:
>       sprite_index: spr_new_player
>   ...
> ```

Now let's look at this function:

```gml
Kengine.Utils.GetAsset(asset_type, asset_name)
```
This will return the correct asset if it is replaced or not. it will be resolved to the correct asset. If the name is not in the index, it can return `undefined` if not found.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->

## Roadmap

Check out the [Projects](https://github.com/knno/kengine/projects/) tab on GitHub.

See the [open issues](https://github.com/knno/kengine/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See [`LICENSE`](https://github.com/knno/kengine/blob/main/LICENSE) for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->

## Contact

Kenan Masri
* Discord: `knno`
* Project link: [https://github.com/knno/kengine](https://github.com/knno/kengine)
* Marketplace link: [https://knno.itch.io/kengine](https://knno.itch.io/kengine)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

Please click on [Credits](./Credits) to view credits.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/knno/kengine.svg
[contributors-url]: https://github.com/knno/kengine/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/knno/kengine.svg
[forks-url]: https://github.com/knno/kengine/network/members
[stars-shield]: https://img.shields.io/github/stars/knno/kengine.svg
[stars-url]: https://github.com/knno/kengine/stargazers
[issues-shield]: https://img.shields.io/github/issues/knno/kengine.svg
[issues-url]: https://github.com/knno/kengine/issues
[license-shield]: https://img.shields.io/github/license/knno/kengine.svg
[license-url]: https://github.com/knno/kengine/blob/main/LICENSE.txt
[concept-img]: images/concept-img.png
