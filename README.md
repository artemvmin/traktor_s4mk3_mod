# Traktor S4MK3 Mod

## Compatibility

Traktor Pro 3.4.2

## Modifications

### Global

- QUANT/SNAP button is flipped for better snap visibility

### Browser

- Sorting:
  - PUSH STAR [★] to toggle sort by BPM or Key
  - SHIFT + PUSH STAR [★] to invert sort order
- Browsing:
  - BROWSE KNOB to navigate list
  - SHIFT + BROWSE KNOB to navigate favorite folders
- Preview:
  - PUSH PREVIEW [▷] to load/unload the selected track into the preview player
  - TURN BROWSE KNOB to seek through the previewed track.
- Loading:
  - Loading a track exits full screen list view mode
  - A deck will auto-sync when a new track is loaded, as long as at least one other deck is synced
- Preparation [2]:
  - PUSH ADD-TO-LIST to add/remove from the prep list
  - SHIFT + PUSH ADD-TO-LIST to jump to the prep list

[1] For the optimal sync experience, set the master tempo to AUTO and sync the first track as it is running. This will match the master tempo to the tempo of the running track.
[2] Preparation requires you to manually select a prep list by right clicking on a playlist in the Traktor software and clicking [Select as Preparation List].

### Jump Mode

Jump mode allows you to skip around the track using the pads. Jumping with a loop enabled moves the entire loop.

- PUSH STEMS for jump mode

Layout:

|  -4 |  +4 |  -8 |  +8 |
|-----|-----|-----|-----|
| -16 | +16 | -32 | +32 |

Layout (with SHIFT held):

| -1 | +1 | -2 | +2 |
|----|----|----|----|
| -4 | +4 | -8 | +8 |

- PUSH SHIFT + STEMS for stems mode

### Loop Mode

Loop mode allows you to initiate loop rolls using the pads. Entering loop mode enables FLUX and disabled SNAP for better loop control. Switching to a different mode reverts these settings. Note that SNAP affects loop and hotcue placement globally.

- PUSH SAMPLES for loop mode

Layout:

| 1/8 loop    | 1/4 loop    | 1/2 loop    | 1 loop    |
|-------------|-------------|-------------|-----------|
| 1/8 reverse | 1/4 reverse | 1/2 reverse | 1 reverse |

- PUSH SHIFT + SAMPLES for remix mode

### Beatgrid Edit

- HOLD GRID + TURN DECK to move grid lines
- SHIFT + TAP GRID 4 TIMES to adjust BPM and grid lines to your beat
- SHIFT + HOLD to re-analyze and reset beatgrid

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
