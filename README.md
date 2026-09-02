# Project Time Tracker

![Plugin icon](/addons/project-time-tracker/icon.png)

A small editor widget which provides basic functions for tracking your time with the Godot editor. Track which main screen view you are using the most.

![Plugin preview](/images/preview-1.png)

## Features
- Track the time you have spent since the start of your project
- Track the time you have spent in each workspace (2D, 3D, Script, etc.)
- A bar chart shows the time spent in each workspace relative to the total time
- Starts tracking when project is loaded
- Stops tracking after a customizable period of inactivity and resumes automatically (AFK management)
	- Editable in project settings
- Counts time as "External" when godot is not focused (for users that use external code editor)
	- Editable in project settings
- Sections and bar chart can be hide separately
	- Editable in project settings
- Timers are saved each time a scene or script is saved


## Update

> [!IMPORTANT]
> ### Update v2.0.X -> v3.0.0-rc1
> 
> **Please backup your project_time_tracker.json file before update**
> 
> - Due to a typo, if you use the default save filename, you must rename the file from “project_time_traker.json” to “project_time_tracker.json.
> - Some settings have been changed. Please check them.

### v3.0.0-rc1

- Godot 4.7
- Big refactor : Most of the code has been rewritten to better align with the purpose of this add-on compared to what was originally planned in the base project, and to make it easier to understand, thereby facilitating contributions to the project.
- Fix typo: traker -> tracker [#11](https://github.com/Fifut/project-time-tracker/pull/11) Thanks @Ickerday
- Add a "Documentation" section
- Replacing AssetLib with Asset Store
- When AFK is triggered, his time is deducted
- Active section is highlighted
- Each sections can be excluded in project settings
- Time measurement is now more accurate
- Improving the readability of percentage values
- Mouse movement is no longer taken into account when selecting a section or when AFK
- "Game" no longer has priority over other windows [#9](https://github.com/Fifut/godot-time-tracker/issues/9)
- The "3D" workspace is no longer forced at startup [#10](https://github.com/Fifut/godot-time-tracker/issues/10)
- Add a journal: Track the time spent each day [#12](https://github.com/Fifut/godot-time-tracker/issues/12)


### v2.0.8
- Add project settings to customize json file name
- Add project settings to customize json file location
- Fix switching back and forth between the game and the script
- Fix project settings property info
- Fix pause override by window focus
- Force saving of times when the editor is closed ( [until the editor is fixed](https://github.com/godotengine/godot/issues/118929) ) [#8](https://github.com/Fifut/godot-time-tracker/issues/8)

### v2.0.7
- If use_external is not enabled, counters no longer counts when the window is not in focus
- Fix: [#6](https://github.com/Fifut/godot-time-tracker/issues/6)
- Fixed an issue where an external signal already connected to the window prevented the add-on signal from connecting

### v2.0.6
- Godot 4.6
- New icon
- Now handle floating windows
- AFK handle floating windows
- Add project settings to use or not External
- Add project settings to use or not AFK
- Add project settings to custom sections color
- Add button to show and hide trash icons
- Add button to edit sections times
- Custom icons sections
- Visual enhancements

### v2.0.5
- Fix: Counts being in the embeded game mode as 'external' [#4](https://github.com/Fifut/godot-time-tracker/issues/4)
- Mono font
- Total hours for sections
- Add project settings to show/hide sections and graphs
- Add project settings to define AFK timer (in seconds)

### v2.0.4
- Godot 4.4
- Add section for Game
- Add total hours in main timer
- Fix: Popup menus count as “external” [#5](https://github.com/Fifut/godot-time-tracker/issues/5)

### v2.0.3
- AFK refactor
- Add sections for AFK and External
[#2](https://github.com/Fifut/godot-time-tracker/issues/2)
[#3](https://github.com/Fifut/godot-time-tracker/issues/3)

### v2.0.2
- AFK management

### v2.0.1
- Days management to fix hours overflow


## Installation
Available from AssetLib within the Editor: https://godotengine.org/asset-library/asset/.

Or clone/download this repository and put `addons/project-time-tracker` folder inside your project folder.


## Credit
Fork of [Godot Time Traker](https://github.com/YuriSizov/godot-time-tracker) by [YuriSizov](https://github.com/YuriSizov)
