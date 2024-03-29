import CSI 1.0
import "../../Defines"
import "../Common/DeckHelpers.js" as Helpers

/*
  This file represents a hardware module on the S4MK3
*/
Module
{
  id: module
  property string surface: ""
  property string propertiesPath: ""
  property int topDeckIdx: 0 
  property int bottomDeckIdx: 0 
  property alias shift: shiftProp
  property int focusedDeckIdx: topDeckFocus.value ? topDeckIdx : bottomDeckIdx
  property bool hapticHotcuesEnabled: true

  //--------------------------HelperFunctions-----------------------------

  function updatePads() 
  {
    if(PadsMode.isPadsModeSupported(focusedDeck().padsMode, focusedDeck().deckType))
    {
      focusedDeck().enablePads = true;
      nonFocusedDeck().enablePads = false;
    }
    else if(focusedDeck().padsMode == PadsMode.remix && nonFocusedDeck().deckType === DeckType.Remix)
    {
      focusedDeck().enablePads = false;
      nonFocusedDeck().enablePads = true
      nonFocusedDeck().padsMode = PadsMode.remix;
    }
    else
    {
      focusedDeck().padsMode = PadsMode.defaultPadsModeForDeck(focusedDeck().deckType);
    }

    // Keep pads state in sync with focused deck, will only trigger callbacks if value has changed
    globalPadsMode.value = focusedDeck().padsMode;
  }

  function nonFocusedDeck()
  {
    return topDeckFocus.value ? bottomDeck : topDeck;
  }

  function focusedDeck()
  {
    return topDeckFocus.value ? topDeck : bottomDeck;
  }

  //--------------------------MAPPING-----------------------------

  // Deck focus //

  MappingPropertyDescriptor
  {
    id: topDeckFocus;
    path: propertiesPath + ".top_deck_focus";
    type: MappingPropertyDescriptor.Boolean;
    value: true;
    onValueChanged:
    {
      updatePads();
    }  
  }

  Wire
  {
    from: "%surface%.top_deck";
    to: SetPropertyAdapter  { path: propertiesPath + ".top_deck_focus"; value: true; color: Helpers.colorForDeck(module.topDeckIdx) }
  } 

  Wire
  {
    from: "%surface%.bottom_deck";
    to: SetPropertyAdapter  { path: propertiesPath + ".top_deck_focus"; value: false; color: Helpers.colorForDeck(module.bottomDeckIdx) }
  } 

  // Performace pads mode  //

  // <CUSTOM>
  AppProperty { id: flux;  path: "app.traktor.decks." + focusedDeckIdx + ".flux.enabled" }
  AppProperty { id: snap;  path: "app.traktor.snap" }
  // </CUSTOM>

  MappingPropertyDescriptor
  {
    id: globalPadsMode;
    path: propertiesPath + ".pads_mode";
    type: MappingPropertyDescriptor.Integer;
    value: PadsMode.disabled;
    onValueChanged:
    {
      // <CUSTOM>
      if (focusedDeck().padsMode == PadsMode.customloop) {
        // Reset flux when exiting loop mode.
        flux.value = false
        snap.value = true
      }
      // </CUSTOM>

      focusedDeck().padsMode = globalPadsMode.value

      // <CUSTOM>
      if (focusedDeck().padsMode == PadsMode.customloop) {
        flux.value = true
        snap.value = false
      }
      // </CUSTOM>

    }
  }

  Wire {
    enabled: PadsMode.isPadsModeSupported(PadsMode.hotcues, focusedDeck().deckType);
    from: "%surface%.hotcues";
    to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.hotcues; color: Helpers.colorForDeck(focusedDeckIdx) }
  }

  Wire {
    // <CUSTOM>
    enabled: PadsMode.isPadsModeSupported(PadsMode.remix, bottomDeck.deckType) || PadsMode.isPadsModeSupported(PadsMode.remix, topDeck.deckType) && shiftProp.value;
    // </CUSTOM>
    from: "%surface%.samples";
    to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.remix }
  }

  Wire {
    // <CUSTOM>
    enabled: PadsMode.isPadsModeSupported(PadsMode.stems , focusedDeck().deckType) && shiftProp.value;
    // </CUSTOM>
    from: "%surface%.stems";
    to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.stems; color: Helpers.colorForDeck(focusedDeckIdx)   }
  }

  // <CUSTOM>
  Wire {
    enabled: PadsMode.isPadsModeSupported(PadsMode.customloop, focusedDeck().deckType) && !shiftProp.value
    from: "%surface%.samples"
    to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.customloop; color: Color.Green }
  }

  Wire {
    enabled: PadsMode.isPadsModeSupported(PadsMode.customjump, focusedDeck().deckType) && !shiftProp.value
    from: "%surface%.stems"
    to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.customjump; color: Helpers.colorForDeck(focusedDeckIdx) }
  }
  // </CUSTOM>

  // Shift //
  MappingPropertyDescriptor { id: shiftProp; path: propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "%surface%.shift";  to: DirectPropertyAdapter { path: propertiesPath + ".shift"  } }

  //------------------------------------SUBMODULES---------------------------------------------//

  KontrolScreen { name: "screen"; side: topDeckIdx==1 ? ScreenSide.Left : ScreenSide.Right; propertiesPath: module.propertiesPath; flavor: ScreenFlavor.S4MK3 }
  Wire { from: "screen.output";   to: "%surface%.display" }

  S4MK3Deck
  {
    id: topDeck
    name: "topDeck"
    surface: module.surface
    deckPropertiesPath: propertiesPath + "." + topDeckIdx
    isLinkedDeckEncoderInUse: bottomDeck.isEncoderInUse
    shift: shiftProp.value
    deckIdx: topDeckIdx
    active: topDeckFocus.value
    hapticHotcuesEnabled: module.hapticHotcuesEnabled
    onDeckTypeChanged:
    {
      updatePads();
    }
    onPadsModeChanged:
    {
      updatePads();
    }
  }

  S4MK3Deck
  {
    id: bottomDeck
    name: "bottomDeck"
    surface: module.surface
    isLinkedDeckEncoderInUse: topDeck.isEncoderInUse
    deckPropertiesPath: propertiesPath + "." + bottomDeckIdx
    shift: shiftProp.value
    deckIdx: bottomDeckIdx
    active: !topDeckFocus.value
    hapticHotcuesEnabled: module.hapticHotcuesEnabled
    onDeckTypeChanged:
    { 
      updatePads();
    }
    onPadsModeChanged:
    {
      updatePads();
    }
  }

//#ifdef DEVELOPMENT_MODE
  Wire { from: "%surface%.record";  to: TriggerPropertyAdapter { path:"app.traktor.debug.take_screenshot"; output: false } enabled: topDeck.shift }
//#endif

}
