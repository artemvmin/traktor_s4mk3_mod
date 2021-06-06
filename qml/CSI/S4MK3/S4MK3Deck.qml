import CSI 1.0
import "../../Defines"
import "../Common"
import "../Common/DeckHelpers.js" as Helpers

Module
{
  id: module
  property bool active: false
  property bool enablePads: false
  property bool shift: false
  property string surface: ""
  property string deckPropertiesPath: ""
  property int padsMode: 0
  property int deckIdx: 0
  property int deckType: deckTypeProp.value
  property bool deckPlaying: deckPlayingProp.value
  property bool isEncoderInUse: samples.isSlotSelected || stems.isStemSelected
  property bool isLinkedDeckEncoderInUse: false
  property var deckColor: Helpers.colorForDeck(deckIdx)
  property bool hapticHotcuesEnabled: true

  MappingPropertyDescriptor {
    id: deckColorProp
    path: deckPropertiesPath + ".deck_color"
    type: MappingPropertyDescriptor.Integer
    value: module.deckColor
  }

  AppProperty
  {
    id: deckTypeProp;
    path: "app.traktor.decks." + deckIdx + ".type";
  }

  AppProperty
  {
    id: deckPlayingProp;
    path: "app.traktor.decks." + deckIdx + ".play";
  }

  AppProperty { id: gridAdjust; path: "app.traktor.decks." + module.deckIdx + ".track.gridmarker.move" ; }
  AppProperty { id: enableTick; path: "app.traktor.decks." + module.deckIdx + ".track.grid.enable_tick"; }
  AppProperty { id: gridLockedProp; path: "app.traktor.decks." + module.deckIdx + ".track.grid.lock_bpm" }

  MappingPropertyDescriptor 
  { 
    id: gridAdjustEnableProp; 
    path: deckPropertiesPath + ".grid_adjust"; 
    type: MappingPropertyDescriptor.Boolean; 
    value: false;
    onValueChanged: { enableTick.value = gridAdjustEnableProp.value; } 
  }

  //----------------------------------- Grid Adjust------------------------------------//

  readonly property bool gridAdjustAvailable: module.active
                                              && jogMode.value === JogwheelMode.Jogwheel
                                              && Helpers.deckTypeSupportsGridAdjust(deckType)
                                              && !gridLockedProp.value;

  // Wire
  // { 
    // enabled: gridAdjustAvailable;
    // from: "%surface%.grid_adjust"; 
    // to: HoldPropertyAdapter { path: deckPropertiesPath + ".grid_adjust"; value: true; color: module.deckColor }
  // }

  // Wire
  // {
    // enabled: gridAdjustAvailable && gridAdjustEnableProp.value;
    // from: "%surface%.jogwheel.rotation"; 
    // to: EncoderScriptAdapter 
    // {
      // onTick: 
      // { 
        // const minimalTickValue = 0.0035;
        // const rotationScaleFactor = 20;
        // if (value < -minimalTickValue || value > minimalTickValue)
          // gridAdjust.value = value * rotationScaleFactor; 
      // }
    // }
  // }

  // <CUSTOM>
  Beatgrid { name: "DeckA_Beatgrid"; channel: 1 }
  Beatgrid { name: "DeckB_Beatgrid"; channel: 2 }
  Beatgrid { name: "DeckC_Beatgrid"; channel: 3 }
  Beatgrid { name: "DeckD_Beatgrid"; channel: 4 }

  function deckLetter() {
    switch (deckIdx) {
    case 1:
      return "A"
    case 2:
      return "B"
    case 3:
      return "C"
    case 4:
      return "D"
    }
  }

  SwitchTimer { name: "ResetHoldTimer";  setTimeout: 1000 }
  Wire { from: "%surface%.grid_adjust";  to: "ResetHoldTimer.input"; enabled: module.shift }
  Wire { from: "ResetHoldTimer.output";  to: "Deck" + deckLetter() + "_Beatgrid.reset" }

  Wire {
    enabled: gridAdjustAvailable && !module.shift
    from: "%surface%.grid_adjust"; 
    to: HoldPropertyAdapter { path: deckPropertiesPath + ".grid_adjust"; value: true; color: module.deckColor }
  }

  Wire {
    enabled: gridAdjustAvailable && module.shift
    from: "%surface%.grid_adjust"
    to: "Deck" + deckLetter() + "_Beatgrid.tap"
  }

  Wire {
    enabled: gridAdjustAvailable && gridAdjustEnableProp.value
    from: "%surface%.jogwheel.rotation"
    to: EncoderScriptAdapter {
      onTick: {
        const minimalTickValue = 0.0001
        const rotationScaleFactor = 100
        if (value < -minimalTickValue || value > minimalTickValue)
          gridAdjust.value = value * rotationScaleFactor
      }
    }
  }

  // </CUSTOM>

  //-----------------------------------JogWheel------------------------------------//


  MappingPropertyDescriptor {
    id: jogMode
    path: deckPropertiesPath + ".jog_mode"
    type: MappingPropertyDescriptor.Integer
  }

  Turntable
  {
      name: "turntable"
      channel: module.deckIdx
  }

  WiresGroup
  {
      enabled: module.active

      Wire
      {
          from: "%surface%.jogwheel"
          to: "turntable"
          enabled: !gridAdjustEnableProp.value
      }
      
      Wire { from: "%surface%.jogwheel.mode";     to: "turntable.mode"     }
      Wire { from: "%surface%.jogwheel.mode";     to: DirectPropertyAdapter { path: deckPropertiesPath + ".jog_mode" }    }
      Wire { from: "%surface%.jogwheel.pitch";    to: "turntable.pitch"    }
      Wire { from: "%surface%.shift";             to: "turntable.shift"    }
      Wire { from: "%surface%.jogwheel.timeline"; to: "turntable.timeline"; enabled: module.hapticHotcuesEnabled }

      Wire
      {
          from: DirectPropertyAdapter { path: "app.traktor.decks." + deckIdx + ".play" }
          to: "%surface%.jogwheel.motor_on"
          // motor_on is currenty also used to tell the HWS if taktor is playing in Jog Mode.
      }


      Wire {
          from: "%surface%.play";
          to: "%surface%.jogwheel.motor_off";
          enabled: module.shift && deckPlaying
      }

      //Wire { from: "%surface%.jogwheel.motor_on"; to: "turntable.motor_on" }

      Wire {
        from: "%surface%.jogwheel.haptic_ticks"
        to: DirectPropertyAdapter { path: "mapping.settings.haptic.ticks_density"; input: false }
        enabled: (jogMode.value === JogwheelMode.Jogwheel || jogMode.value === JogwheelMode.CDJ) && !module.shift
      }

      Wire
      {
          from: DirectPropertyAdapter { path: deckPropertiesPath + ".deck_color"; input: false }
          to: "%surface%.jogwheel.led_color"
      }

      Wire
      {
          from: "%surface%.pitch.fader"
          to: "%surface%.jogwheel.tempo"
      }

      Wire
      {
          from: "%surface%.jogwheel.platter_speed"
          to:   DirectPropertyAdapter{ path: "mapping.settings.haptic.platter_speed"; input: false}
      }
  }

  //------------------------------------Key lock and adjust------------------------------------//
 
  KeyControl { name: "key_control"; channel: deckIdx }
  Wire { from: "%surface%.loop_size";  to: "key_control.coarse"; enabled: module.shift && module.active }

  //------------------------------------LOOP-----------------------------------------------//
  
  Loop { name: "loop";  channel: deckIdx }

  WiresGroup
  {
    // only enable loop control when the deck is in focus and no stem or slot is selected for either deck.
    enabled: module.active && !module.isEncoderInUse && !module.isLinkedDeckEncoderInUse

    WiresGroup
    {
      enabled: !module.shift
      Wire { from: "%surface%.loop_size"; to: "loop.autoloop"; }
      Wire { from: "%surface%.loop_move"; to: "loop.move";     }
    }
  
    Wire { from: "%surface%.loop_move"; to: "loop.one_beat_move"; enabled:  module.shift }
  }

  //------------------------------------SUBMODULES------------------------------------------//

  HotcuesModule
  {
    name: "hotcues"
    shift: module.shift
    surface: module.surface
    deckIdx:  module.deckIdx
    active: padsMode == PadsMode.hotcues && module.enablePads
  }

  S4MK3Stems
  {
    id: stems
    name: "stems"
    surface: module.surface
    deckPropertiesPath: module.deckPropertiesPath
    deckIdx: module.deckIdx
    active: padsMode == PadsMode.stems && module.enablePads
    shift: module.shift
  }

  S4MK3Samples
  {
    id: samples
    name: "samples"
    shift: module.shift
    surface: module.surface
    deckPropertiesPath: module.deckPropertiesPath
    deckIdx: module.deckIdx
    active: padsMode == PadsMode.remix && module.enablePads
  }

  S4MK3TransportButtons
  {
    name: "transport"
    surface: module.surface
    deckIdx: module.deckIdx
    active: module.active
    shift: module.shift
  }

  S4MK3TempoControl
  {
    name: "TempoControl"
    surface: module.surface
    deckIdx: module.deckIdx
    active: module.active
    shift: module.shift
    canLock: jogMode.value != JogwheelMode.Turntable
  }

  ExtendedBrowserModule
  {
    name: "browse"
    surface: module.surface
    deckIdx: module.deckIdx
    active: module.active && !samples.isSlotSelected && !module.isLinkedDeckEncoderInUse
  }


  // <CUSTOM>
  // Jump pads
  AppProperty { id: deckMoveMode;     path: "app.traktor.decks." + module.deckIdx + ".move.mode"              }
  AppProperty { id: deckMoveSize;     path: "app.traktor.decks." + module.deckIdx + ".move.size"              }
  AppProperty { id: deckMove;         path: "app.traktor.decks." + module.deckIdx + ".move"                   }
  AppProperty { id: setLoopIn;        path: "app.traktor.decks." + module.deckIdx + ".loop.set.in"            }
  AppProperty { id: setLoopOut;       path: "app.traktor.decks." + module.deckIdx + ".loop.set.out"           }
  AppProperty { id: deckInActiveLoop; path: "app.traktor.decks." + module.deckIdx + ".loop.is_in_active_loop" }
  AppProperty { id: deckFluxEnabled;  path: "app.traktor.decks." + module.deckIdx + ".flux.enabled"           }

  readonly property real onBrightness:     1.0
  readonly property real dimmedBrightness: 0.0
  property int jumpLight: 0

  function updateMoveMode() {
    deckFluxEnabled.value = false
    if (deckInActiveLoop.value) {
      deckMoveMode.value = 1
    } else {
      deckMoveMode.value = 0
    }
  }

  WiresGroup {
    enabled: padsMode == PadsMode.customjump && module.enablePads

    WiresGroup {
      enabled: !module.shift

      Wire { from: "%surface%.pads.1"; to: ButtonScriptAdapter {
        brightness: jumpLight == 1 ? onBrightness : dimmedBrightness;
        color: Color.DarkOrange;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_4; deckMove.value = -1; jumpLight = 1 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.2"; to: ButtonScriptAdapter {
        brightness: jumpLight == 2 ? onBrightness : dimmedBrightness;
        color: Color.DarkOrange;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_4; deckMove.value = 1; jumpLight = 2 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.3"; to: ButtonScriptAdapter {
        brightness: jumpLight == 3 ? onBrightness : dimmedBrightness;
        color: Color.Red;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_8; deckMove.value = -1; jumpLight = 3 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.4"; to: ButtonScriptAdapter {
        brightness: jumpLight == 4 ? onBrightness : dimmedBrightness;
        color: Color.Red;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_8; deckMove.value = 1; jumpLight = 4 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.5"; to: ButtonScriptAdapter {
        brightness: jumpLight == 5 ? onBrightness : dimmedBrightness;
        color: Color.Fuchsia;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_16; deckMove.value = -1; jumpLight = 5 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.6"; to: ButtonScriptAdapter {
        brightness: jumpLight == 6 ? onBrightness : dimmedBrightness;
        color: Color.Fuchsia;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_16; deckMove.value = 1; jumpLight = 6 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.7"; to: ButtonScriptAdapter {
        brightness: jumpLight == 7 ? onBrightness : dimmedBrightness;
        color: Color.Blue;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_32; deckMove.value = -1; jumpLight = 7 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.8"; to: ButtonScriptAdapter {
        brightness: jumpLight == 8 ? onBrightness : dimmedBrightness;
        color: Color.Blue;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_32; deckMove.value = 1; jumpLight = 8 }
        onRelease: { jumpLight = 0 }
      }}
    }

    WiresGroup {
      enabled: module.shift

      Wire { from: "%surface%.pads.1"; to: ButtonScriptAdapter {
        brightness: jumpLight == 1 ? onBrightness : dimmedBrightness;
        color: Color.Green;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_1; deckMove.value = -1; jumpLight = 1 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.2"; to: ButtonScriptAdapter {
        brightness: jumpLight == 2 ? onBrightness : dimmedBrightness;
        color: Color.Green;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_1; deckMove.value = 1; jumpLight = 2 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.3"; to: ButtonScriptAdapter {
        brightness: jumpLight == 3 ? onBrightness : dimmedBrightness;
        color: Color.WarmYellow;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_2; deckMove.value = -1; jumpLight = 3 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.4"; to: ButtonScriptAdapter {
        brightness: jumpLight == 4 ? onBrightness : dimmedBrightness;
        color: Color.WarmYellow;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_2; deckMove.value = 1; jumpLight = 4 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.5"; to: ButtonScriptAdapter {
        brightness: jumpLight == 5 ? onBrightness : dimmedBrightness;
        color: Color.DarkOrange;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_4; deckMove.value = -1; jumpLight = 5 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.6"; to: ButtonScriptAdapter {
        brightness: jumpLight == 6 ? onBrightness : dimmedBrightness;
        color: Color.DarkOrange;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_4; deckMove.value = 1; jumpLight = 6 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.7"; to: ButtonScriptAdapter {
        brightness: jumpLight == 7 ? onBrightness : dimmedBrightness;
        color: Color.Red;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_8; deckMove.value = -1; jumpLight = 7 }
        onRelease: { jumpLight = 0 }
      }}
      Wire { from: "%surface%.pads.8"; to: ButtonScriptAdapter {
        brightness: jumpLight == 8 ? onBrightness : dimmedBrightness;
        color: Color.Red;
        onPress: { updateMoveMode(); deckMoveSize.value = MoveSize.move_8; deckMove.value = 1; jumpLight = 8 }
        onRelease: { jumpLight = 0 }
      }}
    }
  }

  // Loop pads
  ButtonSection { name: "loop_pads";  buttons: 8; color: Color.Green; stateHandling: ButtonSection.External }

  MappingPropertyDescriptor { id: loop_1_16; path: propertiesPath + ".loopSize_1_16" ; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_16 }
  MappingPropertyDescriptor { id: loop_1_8;  path: propertiesPath + ".loopSize_1_8"  ; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_8  }
  MappingPropertyDescriptor { id: loop_1_4;  path: propertiesPath + ".loopSize_1_4"  ; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_4  }
  MappingPropertyDescriptor { id: loop_1_2;  path: propertiesPath + ".loopSize_1_2"  ; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1_2  }
  MappingPropertyDescriptor { id: loop_1;    path: propertiesPath + ".loopSize_1"    ; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_1    }
  MappingPropertyDescriptor { id: loop_2;    path: propertiesPath + ".loopSize_2"    ; type: MappingPropertyDescriptor.Integer; value: LoopSize.loop_2    }

  Wire { from: DirectPropertyAdapter { path: propertiesPath + ".loopSize_1_16" ; input: false } to: "loop_pads.button1.value" }
  Wire { from: DirectPropertyAdapter { path: propertiesPath + ".loopSize_1_8"  ; input: false } to: "loop_pads.button2.value" }
  Wire { from: DirectPropertyAdapter { path: propertiesPath + ".loopSize_1_4"  ; input: false } to: "loop_pads.button3.value" }
  Wire { from: DirectPropertyAdapter { path: propertiesPath + ".loopSize_1_2"  ; input: false } to: "loop_pads.button4.value" }
  Wire { from: DirectPropertyAdapter { path: propertiesPath + ".loopSize_1"    ; input: false } to: "loop_pads.button5.value" }
  Wire { from: DirectPropertyAdapter { path: propertiesPath + ".loopSize_2"    ; input: false } to: "loop_pads.button6.value" }

  WiresGroup {
    enabled: padsMode == PadsMode.customloop && module.enablePads

    Wire { from: "%surface%.pads.1";   to: "loop_pads.button1" }
    Wire { from: "%surface%.pads.2";   to: "loop_pads.button2" }
    Wire { from: "%surface%.pads.3";   to: "loop_pads.button3" }
    Wire { from: "%surface%.pads.4";   to: "loop_pads.button4" }
    Wire { from: "%surface%.pads.5";   to: "loop_pads.button5" }
    Wire { from: "%surface%.pads.6";   to: "loop_pads.button6" }
    Wire { from: "%surface%.pads.7"; to: ButtonScriptAdapter {
      brightness: deckInActiveLoop.value ? onBrightness : dimmedBrightness;
      color: Color.Blue;
      onPress: { setLoopIn.value = 1 }
    }}
    Wire { from: "%surface%.pads.8"; to: ButtonScriptAdapter {
      brightness: deckInActiveLoop.value ? onBrightness : dimmedBrightness;
      color: Color.Red;
      onPress: { setLoopOut.value = 1 }
    }}

    Wire { from: "loop_pads.value";  to: "loop.autoloop_size"   }
    Wire { from: "loop_pads.active"; to: "loop.autoloop_active" }
  }

  // Auto sync loaded deck
  AppProperty { id: deck1Loaded; path: "app.traktor.decks.1.is_loaded" }
  AppProperty { id: deck2Loaded; path: "app.traktor.decks.2.is_loaded" }
  AppProperty { id: deck3Loaded; path: "app.traktor.decks.3.is_loaded" }
  AppProperty { id: deck4Loaded; path: "app.traktor.decks.4.is_loaded" }
  AppProperty { id: deck1Synced; path: "app.traktor.decks.1.sync.enabled" }
  AppProperty { id: deck2Synced; path: "app.traktor.decks.2.sync.enabled" }
  AppProperty { id: deck3Synced; path: "app.traktor.decks.3.sync.enabled" }
  AppProperty { id: deck4Synced; path: "app.traktor.decks.4.sync.enabled" }
  AppProperty { path: "app.traktor.decks.1.is_loaded_signal";  onValueChanged: onDeckLoaded(1); }
  AppProperty { path: "app.traktor.decks.2.is_loaded_signal";  onValueChanged: onDeckLoaded(2); }
  AppProperty { path: "app.traktor.decks.3.is_loaded_signal";  onValueChanged: onDeckLoaded(3); }
  AppProperty { path: "app.traktor.decks.4.is_loaded_signal";  onValueChanged: onDeckLoaded(4); }

  function anyDeckSynced() {
    return deck1Synced.value || deck2Synced.value || deck3Synced.value || deck4Synced.value
  }

  function onDeckLoaded(deckId) {
    if (!anyDeckSynced()) {
      return
    }

    switch (deckId) {
    case 1:
      if (deck1Loaded.value) { deck1Synced.value = true }
      break
    case 2:
      if (deck2Loaded.value) { deck2Synced.value = true }
      break
    case 3:
      if (deck3Loaded.value) { deck3Synced.value = true }
      break
    case 4:
      if (deck4Loaded.value) { deck4Synced.value = true }
      break
    }
  }
  // </CUSTOM>
}
