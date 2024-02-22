<!-- Template used: https://github.com/othneildrew/Best-README-Template -->

<a name="readme-top"></a>



<!-- PROJECT LOGO -->

<br />
<div align="center">
  <a href="https://github.com/knno/kengine">
    <img src="https://raw.githubusercontent.com/knno/kengine/main/images/ICON.png" alt="Logo" width="150">
  </a>

  <h3 align="center"><i>Kengine</i></h3>

  <!-- PROJECT SHIELDS -->

  [![Contributors][contributors-shield]][contributors-url]
  [![Forks][forks-shield]][forks-url]
  [![Stargazers][stars-shield]][stars-url]
  [![Issues][issues-shield]][issues-url]
  [![MIT License][license-shield]][license-url]

  <p align="center">
    A GameMaker framework for modding support of your projects.
    <br />
    <a href="https://knno.github.io/kengine/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/knno/kengine/issues">Report Bug</a>
    ·
    <a href="https://github.com/knno/kengine/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
      <ul>
        <li><a href="#introduction">Introduction</a></li>
        <li><a href="#what-is-kengine">What is Kengine?</a></li>
      </ul>
    <li><a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation-for-use">Installation for Use</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->

## About The Project

<!-- [![Kengine concept img][concept-img]](https://knno.github.io/kengine) -->

### Introduction

Sometimes, you want to make your GameMaker project moddable by your end-users community.

For example, here's a few possible scenarios:

* Adding and replacing in-game assets.
* Modifying the assets dynamically by reading archive files, or with code from an API.
* Enable support for mod files of your game that would manipulate some of the assets.
* Allow the user to enable and disable mods.
* So on... :smile:

Of course, your exact implementations and needs may be different. This is found as a base project template for those requirements.

It is made in a way that can be added to existing projects, too.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### What is Kengine

Kengine is a set of script files that add many possibilites into your GameMaker project. It is a singleton global in your game that you can access anytime for different uses. It comprises sub structs such as:

- `utils` functions:
  - This contains most functions that you can use in your project.
  - It also contains other utility functions for arrays, structs, strings ...etc.
  - See [this page](https://knno.github.io/kengine/tutorial-Utils) for more information.

Kengine also finds specific extension scripts that you can have added to the project. Such scripts should contain a function `ken_init_ext_<name>` that is run when Kengine starts. Some of these extensions are internal and required to run smoothly. Here are a few:

- `parser` extension:
  - This extension contributes a way to parse external script files. It depends on [Tiny Expression Runtime](https://github.com/YAL-GameMaker/tiny-expression-runtime/) for parsing the files (included with a few modifications). Although, with some work, you can replace it with any interpreter you may already have. See [this page](https://knno.github.io/kengine/tutorial-Parser) for more information.

- `mods` extension:
  - This extension adds the ability to read external ZIP files that act as "mods". A Mod is a set of asset configuration files (called `AssetConf`) that define what assets to add or replace. See [This page](https://knno.github.io/kengine/tutorial-Mods) for more information.

- `panels` extension:
  - This extension adds a very basic GUI system called "Kengine panels". It is required for the Console to work. Otherwise, you can disable the Console completely and remove this.
  - [Click here](https://knno.github.io/kengine/tutorial-Panels) to learn how to use Panels.

- `tests` extension:
  - This extension adds a system for doing tests inside your project. It adds a Test constructor, a Fixture and a Test Manager.
  - Any script that starts with `ken_test_` is **called twice** in order to find its fixtures and to run the actual test.
  - A fixture is simply an object with `setup` and `cleanup` functions that are required for the test. Mulitple tests can have the same fixtures (by the name.)
  - To learn more about the tests system, [click here](https://knno.github.io/kengine/tutorial-Tests).


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
2. Backup your `KengineConfig` script in your GameMaker project to **another location and name** (if it exists)
3. Delete the `Kengine` folder in your project.
4. Import the downloaded file into your project by `Tools > Import local package`.
5. Compare the values of both `KengineConfig`s scripts. It is recommended to use the newer values.
6. Don't forget to add `obj_kengine` object to your very first room!
7. Done

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

> For guides, please refer to the [Documentation](https://knno.github.io/kengine/). As there are many uses of Kengine.
> Ranging from replacing a simple asset, to managing game mods.

These are a few examples on how to use Kengine.

### Simplest Asset Replacement Usage

Let's assume you want to use a sprite that is replaceable or addable, for an object already in your asset resources,
see the following code as an example.

```gml
/// obj_player : Creation Code

// obj_player has  spr_player initially.
// whether sprite is replaced or not, we must "refresh the sprite handle"

sprite_index = Kengine.utils.get_asset("sprite", "spr_player").id;

// This code updates the object's sprite to a different sprite
// since it is added or "replaced" to the runtime of your game.
```

You must check if the asset is there, but it's not necessary **unless if it's not in the asset resources before.** because assets are indexed by default.

```gml
var spr_asset = Kengine.utils.get_asset("sprite", "new_spr_player");
if asset != undefined {
  sprite_index = spr_asset.id;
} else {
  // Keep the sprite.
}
```

> #### A note on custom objects
> Did you know that you don't actually have to set the sprite_index if your object is a Kengine object (a custom asset) from a mod? Since mods can use self-referencing to sprites they have in definition. Example mod as below
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
Kengine.utils.get_asset(asset_type, asset_name)
```
This will return the correct asset if it is replaced or not. it will be resolved to the correct asset. If the name is not in the index, it can return `undefined` if not found.

From now on, please check the full documentation for concepts and info.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->

## Roadmap

Check out the `Projects` tab on GitHub.

See the [open issues](https://github.com/knno/kengine/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->

## Contact

Kenan Masri
* Discord: `knno`
* Project link: [https://github.com/knno/kengine](https://github.com/knno/kengines)
<!-- Marketplace link: [https://marketplace.] -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

#### [Img Shields](https://shields.io)

#### Tiny Expression Runtime by YAL

Credits to [Tiny Expressions Runtime - YAL](https://github.com/YAL-GameMaker/tiny-expression-runtime/). It has been modified to be used as a custom scripts parser and for the Console panel.

#### Snap by JujuAdams

Credits to [Snap - JujuAdams](https://github.com/JujuAdams/SNAP/). It is used for opening mod files (yaml syntax by default) although you should be able to replace this with your own parsing code.

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
[license-url]: https://github.com/knno/kengine/blob/master/LICENSE.txt
[concept-img]: images/concept-img.png
