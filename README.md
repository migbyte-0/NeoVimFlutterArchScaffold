# NeoVimFlutterArchScaffold

FlutterArchScaffold is a Neovim Lua script designed to streamline the process of setting up a Flutter project's architecture. It supports the automated scaffolding of project features with BLoC and Cubit patterns, helping developers focus more on development and less on repetitive setup tasks.

## Features

- Quick scaffolding of Flutter project architecture for features.
- Support for BLoC and Cubit patterns.
- Automatic generation of directory structure and necessary files.
- Creation of export files for simplified import management.

## Installation

1. Ensure you have Neovim installed on your system.
2. Clone this repository or download the `flutter_arch_scaffold.lua` script directly into your Neovim configuration directory, typically found at `~/.config/nvim/lua/`.
3. Require the script in your Neovim `init.lua` file:![WhatsApp Image 2024-03-31 at 6 21 13 PM](https://github.com/migbyte-0/NeoVimFlutterArchScaffold/assets/152094060/6277eb04-92db-40dc-996a-e0401316540f)


```lua
require('flutter_arch_scaffold')

## Usage
To use FlutterArchScaffold, open Neovim and execute the following command in your command mode:

:lua require('flutter_arch_scaffold').prompt_architecture_and_feature()

Follow the prompts to choose your architecture (BLoC or Cubit) and enter the name of the feature you're scaffolding.

## Contributing
Contributions to FlutterArchScaffold are welcome and greatly appreciated. You can contribute in several ways:

* Submit bug reports or feature requests.
* Improve documentation.
* Submit pull requests with bug fixes or new features.





