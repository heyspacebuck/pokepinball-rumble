# Pokémon Pinball Peripheral Rumble

Pokémon Pinball was a 1999 game title for the Game Boy and Game Boy Color. It's one of the few Game Boy games that came with a rumble pack built into the cartridge, letting the player feel the action on the pinball table. This project breaks out the rumble feature, enabling an emulated Pokémon Pinball game to control peripheral devices.

## Setup

### The ROM

Download "patch.ips" and use a patching tool (such as Lunar IPS) to apply it to the Pokémon Pinball ROM. How you obtain the Pokémon Pinball ROM is up to you.

### The Emulator

Download BizHawk. To control the peripherals, we have to start EmuHawk (the BizHawk Emulator) from the command line with an additional flag.

Windows: `.\EmuHawk.exe --url_get=x.invalid`

### The "Hook"

Download the file "rumble.lua" to BizHawk's "Lua" folder. In EmuHawk, open Tools > Lua Console. After starting the patched ROM, load rumble.lua.

### The Peripheral

TODO: setup peripheral server for Intiface/Buttplug

If you have a Double-Oh Battery, then the rumble turns on for 0.2 seconds whenever you send a GET request to `doubleoh.local/pinball`.

## Why we have to go through all these steps

On the original Pokémon Pinball cartridge, the rumble feature is turned on by writing a 1 to bit 3 of memory address 0x4000. However, if we inspect 0x4000 in a debugger, we won't see the change, because bytes 0x4000-0x5FFF display the ROM contents of a particular memory bank, regardless of what's written to them. The patch forces the game to write to memory address 0xFF01, which we can observe changing, instead of memory address 0x4000. This lets us see byte 0xFF01 change value whenever rumble is triggered.

The Lua script checks memory address 0xFF01 every frame. We can't directly turn on the peripheral from within the Lua script; instead, we have to fetch a page running on a local server.
