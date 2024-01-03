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
    A GameMaker framework that helps with modding functions for your projects.
    <br />
    <a href="https://knno.github.io/kengine/"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://knno.github.io/kengine/issues">Report Bug</a>
    ·
    <a href="https://knno.github.io/kengine/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->

<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation-for-usage">Installation for Usage</a></li>
        <li><a href="#installation-for-development">Installation for Development</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->

## About The Project

<!-- [![Kengine concept img][concept-img]](https://knno.github.io/kengine) -->

Usually you want to make your GameMaker project, moddable.

Here's a few possible requirements that you might have:

* Adding and replacing assets in-game.
* Modifying the assets dynamically by reading archive files or with code.
* Enable mods support of your game that manipulate those assets.
* Allow the user to enable and disable mods possibily with their mod dependencies.
* So on... :smile:

Of course, your exact implementations and needs may be different. This is found as a base project template for GameMaker projects.
It is made in a way that can be added to existing projects, too.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->

## Getting Started

### Installation for Use

1. download the latest .yyps package from this repository releases.
2. Import it in your project. Select `Extensions/Kengine` folder, and `Rooms/rm_init` if needed.
3. Make sure that your first room, or when the rooms are started, the following script is called:

```gml
// Call this preferrably in the first room creation code.
ken_init();

```

This is already done in `Rooms/rm_init` that is provided.

And now you can use and build on it!


### Installation for Development

1. Clone the repository
   ```sh
   git clone https://github.com/knno/kengine.git
   ```
2. Install NPM packages
   ```sh
   npm install
   ```
3. Start development of your extension or code!

<!-- You can check <a href="https://knno.github.io/kengine/">this documentation section</a> for more info on this. -->

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE -->

## Usage

> For guides, please refer to the [Documentation](https://knno.github.io/kengine/). As there are many uses of Kengine.
> Ranging from replacing a simple asset, to loading a whole mod.

These are a few examples on how to use Kengine.

### Creating a new asset type and an asset in it.

```gml
/// ken_customize.gml

Kengine.conf.asset_types.my_new_asset_type = {
  name: "foo",
  name_plural: "foos",
  index_range: [0,1],
};
```

This will define a `Kengine.AssetType` that can be used later. Then you can use it after Kengine is initiated.
Now to get an asset id (the real sprite_index of the asset.)

```gml
var asset = Kengine.fn.utils.get_asset("sprite", "spr_ball");
if asset {
  return asset.id
}
```
This will return the correct ID regardless the asset is replaced or not. it will be resolved to correct sprite.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ROADMAP -->

## Roadmap

- [x] Add AssetType
- [x] Add Asset
- [x] Add Instance wrapper
- [ ] Improve KScripts.
- [ ] Add Tutorials in Docs
  - [ ] Add Level Asset
  - [ ] How to work with mods
- [ ] Add Additional Examples
- [ ] Add Changelog
- [ ] Add tests
- [ ] Improve Mods extension
  - [ ] Read external files
- [ ] Improve Panels

See the [open issues](https://github.com/knno/kengine/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Create your extension/code and jsdoc it
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->

## Contact

Kenan Masri - @kenanmasri - knno in discord!

Project link: [https://github.com/knno/kengine](https://github.com/knno/kengine)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->

## Acknowledgments

* [Img Shields](https://shields.io)
* [GameMaker - YoYoGames](https://github.com/YoYoGames)
* [Tiny Expressions Runtime - YAL](https://github.com/YellowAfterlife)

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
