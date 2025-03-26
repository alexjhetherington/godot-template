# Godot Template
Use this template to skip building the boring stuff, or to learn how you might structure a godot game. it includes:
* Main menu
* Simple level manager with one level
* Basic settings
* Pause screen
* Console
* Save / Load framework (without implementation)
* Transitions framework (with simple fade implemented)
* Sound Manager (framework for playing repeatable sounds with variations)
* Bonus shaders (cloudy sky, psx shaders, portal cards)

For experienced users the contents of this repo should be self-explanatory.

For beginners, read on for more details.

## Principles

This template is:
* Opinionated; I don't claim this is the 'right' way to structure a project
* Intended to be modified. All games are unique; if you don't want a main menu, don't use it

## Control Flow

`main.tscn` is the main scene. It does nothing other than call `AppState.main_menu()`

It essentially means the entry point into your game is code, rather than the godot scene system. I find this approach a bit cleaner.

`AppState` has methods that control the overall state of the game, including switching levels, and pausing and unpausing.

The pause and settings menus are global menus (always loaded). It's convenient.

## Settings

The main settings logic is in `settings.gd`. Each setting is implemented as a property (with a `getter` and `setter`) which allows the `_ready` method to do some magic to iterate and load all the settings at the start of the game.

`SettingsManager` is responsible for actually persisting the settings to a file, using the `ConfigFile` API. Be careful when calling `set_value`; the string name parameter must match the property name.

## Console

The console is a modified version of the plugin by `jitspoe`. My own modifications change the tab auto complete functionality to work to my preference, and expose the `add_known_word` method (they are not signficant changes).

Add console commands by calling `Console.add_command`. You can do thinks like create console commands to load levels, teleport the player, and generally help you test your game. 

If you want autocomplete to recognise parameters, use `add_known_word`.

## Save / Load advice

Saving and loading is not implemented because that is very game specific.

You can use `save_manager.gd` to save and load games.

`save_manager.gd` maintains a list (save slots) of arbitrary `Nodes` in memory and on file. The idea is create a class (Node) that has fields that represent your save game. You can arbitrarily call the `save` function to persist that data into memory and file. Loading the game is a matter of just selecting a slot and looking at the node in that index.

There are other ways to do save games and this method has it's advantages and disadvantages. I would just highlight:

* I prefer working with Nodes in memory (rather than say, resources) because I think the API (with regards to lifecycle) is a bit more understandable
* I manually transform each Node to and from JSON. This presents some problems for some data types (at least at the time I wrote this). I prefer this to resources because I want the file to be ultra human readable i.e. JSON

## Notes on Sound Manager

`SoundManager` is a very useful singleton that requires some setup. The setup is started for you in the template, but it still requires some work:
* Make `SoundLibrary` or `SoundFolder` assets in the `assets/audio/library` folder path (hardcoded). One is created for you
* Each library requires data setup in the inspector
* Each library can point to a different audio bus
* Your job is to fill in the `Sound Configs` array in the inspector; each sound config points to an audio file, has various options for sound setup, and can be given aliases. `SoundManager.play` can be called from anywhere in code; a sound file will be played that matches has a matching alias. In this way, you can load up 4 or 5 sounds for footsteps, for example, and play them randomly just by calling `SoundManager.play("footstep")`

## Other Notes

* A basic UI theme has been created for your and associated with the existing menus for your convenience, at `assets/themes/default_theme.tres`
