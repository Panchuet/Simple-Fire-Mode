# Simple Fire Mode
This script lets players toggle a weapon between Full-Auto and Semi-Auto firing modes.

**Step 1: Component Setup**
1. Select the main (root) game object of your weapon in Unity
2. Add a `Scripted Behaviour` component to it
3. Add a `Data Container` component to the same object
4. Set the Source of the Scripted Behaviour to your script file. The file must be named exactly `SimpleFireMode.lua`
5. Enable `Keep Scripts On Third Person` in the `Weapon` script
6. Use the latest `Weapon` script from https://discord.com/channels/1439609938518347869/1479396551922159678. Choose `One Shot` in `Audio Mode`

**Step 2: Data Container Setup**
Open your Data Container and add these 6 keys exactly as written.
- `startSemi` — **Bool**
  - True (Checked): Weapon starts in Semi-Auto. False (Unchecked): Weapon starts in Full-Auto
- `switchCooldown` — **Float**
  - Time in seconds before the player can switch modes and fire again. Best if you match this to animation length
- `switchKeybind` — **String**
  - The lowercase letter the player presses to change modes (like `t`)
- `switchParameterName` — **String**
  - The exact name of the Trigger parameter you will make in your Animator (Step 3)
- `selectorParameterName` — **String**
  - The exact name of the Int parameter you will make in your Animator (Step 3)
- `selectorValues` — **String**
  - Two numbers separated by a single space (like `0 1`). The first number is for Auto (Mode 0), and the second number is for Semi (Mode 1)

**Step 3: Animator Setup**
Open your Animator's Parameters tab and add two new entries:
1. A `Trigger` parameter. Name it exactly what you typed in `switchParameterName`
2. An `Int` (Integer) parameter. Name it exactly what you typed in `selectorParameterName`

**The Physical Selector Switch**
1. Create a new Animator Layer for the gun's lever. Click the layer's gear icon and set Weight to `1` and Blending to `Additive`
2. Create two states in this layer: one static animation clip for the Auto position, and one for the Semi position
3. Make transition arrows connecting the two states to each other
4. Click the transition arrow going to the Auto state. Under Conditions, set your Int parameter to Equals your first number (e.g., `0`)
5. Click the transition arrow going to the Semi state. Set the condition to Equals your second number (e.g., `1`)

**The Hand Animation**
1. In your main animation layer, create a state for the hand reaching out to flip the switch
2. Create a transition line from `Any State` into this hand-switching state
3. Under Conditions, add your Trigger parameter
4. Create a transition line from the hand-switching state back to your `Hip State`

**Credits**
Huge huge thanks to ProfessionalDebil for the massive help, and for letting me use his script as a reference for this
