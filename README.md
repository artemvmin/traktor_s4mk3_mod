# Traktor S4MK3 Mod

## Compatibility

Traktor Pro 3.4.2

## Modifications

### Browser

- Loading:
  - Tracks are automatically synced on load
- Sorting:
  - PUSH STAR [★] to toggle sort by BPM or Key
  - SHIFT + PUSH STAR [★] to invert sort order
- Preparation [1]:
  - PUSH ADD-TO-LIST to add/remove from the prep list
  - SHIFT + PUSH ADD-TO-LIST to jump to the prep list

[1] Preparation requires you to manually select a prep list by right clicking on a playlist in the Traktor software and clicking [Select as Preparation List].

### Jump Mode

Jump mode allows you to skip around the track and initiate custom loops using the pads. Mark the start of a loop with [loop in] and initiate the loop with [loop out]. Press either button, or the loop knob, to exit the loop. Jumping with a loop enabled moves the entire loop.

- PUSH STEMS for jump mode

Layout:

| -32 | loop in | loop out | 32 |
|:---:|:-------:|:--------:|:--:|
| -16 |    -8   |     8    | 16 |

Layout (with SHIFT or SAMPLES held):

| -4 |    |   | 4 |
|:--:|:--:|:-:|:-:|
| -2 | -1 | 1 | 2 |

### Loop Mode

Loop mode allows you to initiate short loops using the pads. I recommend experimenting by enabling FLUX and/or disabling SNAP.

- PUSH SHIFT + STEMS for loop mode

Layout:

| 1/16 | 1/8 | 1/4 | 1/2 |
|:----:|:---:|:---:|:---:|
|   1  |  2  |  4  |  8  |

## Installation

**Windows:**

1. Download or clone the repository.
2. Copy the qml folder to `C:\Program Files\Native Instruments\Traktor Pro 3\Resources64` and replace all files.

**Mac:**

1. Download or clone the repository.
2. Navigate to `Applications/Native Instruments/Traktor Pro 3`.
3. Right click on Traktor and select `Show Package Contents`.
4. Manually copy each qml file to the appropriate folder in `Contents/Resources`.

Note: MacOS does not make this process easy because I chose to only upload files that I modified. Replacing will clobber the entire directory with my partial files. Merging will preserve newer items, but there is no guarantee that the mod files are newer than your current Traktor files.

## Credits

As far as I'm aware, all inputs and ouputs for these configuration scripts are completely undocumented. That means that this process requires tedious guess and checking with no guarantee of success. There are some features I simply would not have figured out on my own. A huge thanks to the following trailblazers:

- [Aleix Jiménez](https://www.patreon.com/supremeedition) makes an incredibly feature-rich Traktor mod. It's seriously light years ahead of mine and you should go support him on Patreon.
