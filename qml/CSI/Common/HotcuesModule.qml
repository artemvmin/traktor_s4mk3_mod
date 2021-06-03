import CSI 1.0

Module
{
  id: module
  property bool shift: false
  property string surface: ""
  property int deckIdx: 0
  property bool active: false

  Hotcues   { name: "hotcues";      channel: deckIdx }

  // <CUSTOM>
  AppProperty { id: hotcue1Exists;  path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.1.exists"}
  AppProperty { id: hotcue2Exists;  path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.2.exists"}
  AppProperty { id: hotcue3Exists;  path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.3.exists"}
  AppProperty { id: hotcue4Exists;  path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.4.exists"}
  AppProperty { id: hotcue5Exists;  path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.5.exists"}
  AppProperty { id: hotcue6Exists;  path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.6.exists"}
  AppProperty { id: hotcue7Exists;  path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.7.exists"}
  AppProperty { id: hotcue8Exists;  path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.8.exists"}

  AppProperty { id: hotcue1Type;    path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.1.type" }
  AppProperty { id: hotcue2Type;    path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.2.type" }
  AppProperty { id: hotcue3Type;    path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.3.type" }
  AppProperty { id: hotcue4Type;    path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.4.type" }
  AppProperty { id: hotcue5Type;    path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.5.type" }
  AppProperty { id: hotcue6Type;    path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.6.type" }
  AppProperty { id: hotcue7Type;    path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.7.type" }
  AppProperty { id: hotcue8Type;    path: "app.traktor.decks." + (deckIdx) + ".track.cue.hotcues.8.type" }

  readonly property var hotcueMarkerTypes: { 0: "hotcue", 1: "fadeIn", 2: "fadeOut", 3: "load", 4: "grid", 5: "loop" }

  property string hotcue1State:       ( hotcue1Exists.value && hotcue1Type.value != -1) ? hotcueMarkerTypes[hotcue1Type.value] : "off"
  property string hotcue2State:       ( hotcue2Exists.value && hotcue2Type.value != -1) ? hotcueMarkerTypes[hotcue2Type.value] : "off"
  property string hotcue3State:       ( hotcue3Exists.value && hotcue3Type.value != -1) ? hotcueMarkerTypes[hotcue3Type.value] : "off"
  property string hotcue4State:       ( hotcue4Exists.value && hotcue4Type.value != -1) ? hotcueMarkerTypes[hotcue4Type.value] : "off"
  property string hotcue5State:       ( hotcue5Exists.value && hotcue5Type.value != -1) ? hotcueMarkerTypes[hotcue5Type.value] : "off"
  property string hotcue6State:       ( hotcue6Exists.value && hotcue6Type.value != -1) ? hotcueMarkerTypes[hotcue6Type.value] : "off"
  property string hotcue7State:       ( hotcue7Exists.value && hotcue7Type.value != -1) ? hotcueMarkerTypes[hotcue7Type.value] : "off"
  property string hotcue8State:       ( hotcue8Exists.value && hotcue8Type.value != -1) ? hotcueMarkerTypes[hotcue8Type.value] : "off"
  // </CUSTOM>

  WiresGroup
  {
    enabled: active 

    WiresGroup
    {
      enabled: !module.shift

      Wire { from: "%surface%.pads.1";   to: "hotcues.1.trigger" }
      Wire { from: "%surface%.pads.2";   to: "hotcues.2.trigger" }
      Wire { from: "%surface%.pads.3";   to: "hotcues.3.trigger" }
      Wire { from: "%surface%.pads.4";   to: "hotcues.4.trigger" }
      Wire { from: "%surface%.pads.5";   to: "hotcues.5.trigger" }
      Wire { from: "%surface%.pads.6";   to: "hotcues.6.trigger" }
      Wire { from: "%surface%.pads.7";   to: "hotcues.7.trigger" }
      Wire { from: "%surface%.pads.8";   to: "hotcues.8.trigger" }
    }

    WiresGroup
    {
      enabled: module.shift

      Wire { from: "%surface%.pads.1";   to: "hotcues.1.delete" }
      Wire { from: "%surface%.pads.2";   to: "hotcues.2.delete" }
      Wire { from: "%surface%.pads.3";   to: "hotcues.3.delete" }
      Wire { from: "%surface%.pads.4";   to: "hotcues.4.delete" }
      Wire { from: "%surface%.pads.5";   to: "hotcues.5.delete" }
      Wire { from: "%surface%.pads.6";   to: "hotcues.6.delete" }
      Wire { from: "%surface%.pads.7";   to: "hotcues.7.delete" }
      Wire { from: "%surface%.pads.8";   to: "hotcues.8.delete" }
    }

    // <CUSTOM>
    // Auto deactivate loop when triggering hotcues which are not loops

    // Deck A
    WiresGroup {
      enabled: deckIdx == 1

      Wire { enabled: hotcue1State != "loop" && hotcue1State != "off"; from: "%surface%.pads.1";   to: SetPropertyAdapter { path: "app.traktor.decks.1.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue2State != "loop" && hotcue2State != "off"; from: "%surface%.pads.2";   to: SetPropertyAdapter { path: "app.traktor.decks.1.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue3State != "loop" && hotcue3State != "off"; from: "%surface%.pads.3";   to: SetPropertyAdapter { path: "app.traktor.decks.1.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue4State != "loop" && hotcue4State != "off"; from: "%surface%.pads.4";   to: SetPropertyAdapter { path: "app.traktor.decks.1.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue5State != "loop" && hotcue5State != "off"; from: "%surface%.pads.5";   to: SetPropertyAdapter { path: "app.traktor.decks.1.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue6State != "loop" && hotcue6State != "off"; from: "%surface%.pads.6";   to: SetPropertyAdapter { path: "app.traktor.decks.1.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue7State != "loop" && hotcue7State != "off"; from: "%surface%.pads.7";   to: SetPropertyAdapter { path: "app.traktor.decks.1.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue8State != "loop" && hotcue8State != "off"; from: "%surface%.pads.8";   to: SetPropertyAdapter { path: "app.traktor.decks.1.loop.active"; value: 0; output: false } }
    }

    // Deck C
    WiresGroup {
      enabled: deckIdx == 3

      Wire { enabled: hotcue1State != "loop" && hotcue1State != "off"; from: "%surface%.pads.1";   to: SetPropertyAdapter { path: "app.traktor.decks.3.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue2State != "loop" && hotcue2State != "off"; from: "%surface%.pads.2";   to: SetPropertyAdapter { path: "app.traktor.decks.3.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue3State != "loop" && hotcue3State != "off"; from: "%surface%.pads.3";   to: SetPropertyAdapter { path: "app.traktor.decks.3.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue4State != "loop" && hotcue4State != "off"; from: "%surface%.pads.4";   to: SetPropertyAdapter { path: "app.traktor.decks.3.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue5State != "loop" && hotcue5State != "off"; from: "%surface%.pads.5";   to: SetPropertyAdapter { path: "app.traktor.decks.3.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue6State != "loop" && hotcue6State != "off"; from: "%surface%.pads.6";   to: SetPropertyAdapter { path: "app.traktor.decks.3.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue7State != "loop" && hotcue7State != "off"; from: "%surface%.pads.7";   to: SetPropertyAdapter { path: "app.traktor.decks.3.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue8State != "loop" && hotcue8State != "off"; from: "%surface%.pads.8";   to: SetPropertyAdapter { path: "app.traktor.decks.3.loop.active"; value: 0; output: false } }
    }

    // Deck B
    WiresGroup {
      enabled: deckIdx == 2

      Wire { enabled: hotcue1State != "loop" && hotcue1State != "off"; from: "%surface%.pads.1";   to: SetPropertyAdapter { path: "app.traktor.decks.2.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue2State != "loop" && hotcue2State != "off"; from: "%surface%.pads.2";   to: SetPropertyAdapter { path: "app.traktor.decks.2.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue3State != "loop" && hotcue3State != "off"; from: "%surface%.pads.3";   to: SetPropertyAdapter { path: "app.traktor.decks.2.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue4State != "loop" && hotcue4State != "off"; from: "%surface%.pads.4";   to: SetPropertyAdapter { path: "app.traktor.decks.2.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue5State != "loop" && hotcue5State != "off"; from: "%surface%.pads.5";   to: SetPropertyAdapter { path: "app.traktor.decks.2.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue6State != "loop" && hotcue6State != "off"; from: "%surface%.pads.6";   to: SetPropertyAdapter { path: "app.traktor.decks.2.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue7State != "loop" && hotcue7State != "off"; from: "%surface%.pads.7";   to: SetPropertyAdapter { path: "app.traktor.decks.2.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue8State != "loop" && hotcue8State != "off"; from: "%surface%.pads.8";   to: SetPropertyAdapter { path: "app.traktor.decks.2.loop.active"; value: 0; output: false } }
    }

    // Deck D
    WiresGroup {
      enabled: deckIdx == 4

      Wire { enabled: hotcue1State != "loop" && hotcue1State != "off"; from: "%surface%.pads.1";   to: SetPropertyAdapter { path: "app.traktor.decks.4.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue2State != "loop" && hotcue2State != "off"; from: "%surface%.pads.2";   to: SetPropertyAdapter { path: "app.traktor.decks.4.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue3State != "loop" && hotcue3State != "off"; from: "%surface%.pads.3";   to: SetPropertyAdapter { path: "app.traktor.decks.4.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue4State != "loop" && hotcue4State != "off"; from: "%surface%.pads.4";   to: SetPropertyAdapter { path: "app.traktor.decks.4.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue5State != "loop" && hotcue5State != "off"; from: "%surface%.pads.5";   to: SetPropertyAdapter { path: "app.traktor.decks.4.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue6State != "loop" && hotcue6State != "off"; from: "%surface%.pads.6";   to: SetPropertyAdapter { path: "app.traktor.decks.4.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue7State != "loop" && hotcue7State != "off"; from: "%surface%.pads.7";   to: SetPropertyAdapter { path: "app.traktor.decks.4.loop.active"; value: 0; output: false } }
      Wire { enabled: hotcue8State != "loop" && hotcue8State != "off"; from: "%surface%.pads.8";   to: SetPropertyAdapter { path: "app.traktor.decks.4.loop.active"; value: 0; output: false } }
    }
  }
}
