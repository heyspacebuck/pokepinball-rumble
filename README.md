# Pokémon Pinball Peripheral Rumble

Pokémon Pinball was a 1999 game title for the Game Boy and Game Boy Color. It's one of the few Game Boy games that came with a rumble pack built into the cartridge, letting the player feel the action on the pinball table. This project breaks out the rumble feature, enabling an emulated Pokémon Pinball game to control peripheral devices.

Holy moly, when I published this last year I got it SO WRONG in SO MANY WAYS. The method I used last year worked, but only due to a series of very dumb coincidences. Now that I know a ROM patch is unnecessary, there isn't much to put in this repo, is there? It may as well just be a gist. If I continue to work on this, it will most likely be on [my site](https://www.spacebuck.net/projects.php?proj=pokepinball).

## Setup

### The Emulator

Download BizHawk. Download the file `rumble.lua` to BizHawk's "Lua" folder (or, y'know, wherever is convenient). In EmuHawk, open `Tools > Lua Console`. Once the game is loaded, load `rumble.lua`.

### The Peripheral

TODO: setup peripheral server for Intiface/Buttplug

If you have a Double-Oh Battery, then the rumble turns on for 0.2 seconds whenever you send a GET request to `doubleoh.local/pinball`.

## What is going on

On the original Pokémon Pinball cartridge, the rumble feature is controlled with a PWM signal coming from a pin on the MBC5 control chip. That pin outputs a HIGH or LOW value corresponding to bit 3 of memory address `0x4000`. However, address `0x4000` is write-only? I'm not entirely sure why that means I can't monitor the values written to it in an emulator. Regardless, there is more useful information at addresses `0xD803` and `0xD804`. These control the intensity and duration, respectively, of the rumble.

I think it's neat how `0xD803` controls the vibration intensity. On every instruction cycle, the contents of `0xD803` are rotated by one position, and the new lowest bit gets copied to bit 3 of `0x4000`. So if the initial value of `0xD803` is `0b1111 1111`, then the motor would stay on during every instruction cycle. But if the initial value is `0b0010 0000`, for example, the motor only turns on when once every eight instruction cycles. The same would be true if it started with the value `0b1000 0000`, or `0b0000 0100`. Similarly, `0xAA` (`0b1010 1010`) and `0x33` (`0b0011 0011`) would have the same 50% intensity, but the PWM frequency of `0xAA` is twice that of `0x33`. Like I said, I just think it's pretty neat.

The contents of address `0xD804` determine the duration of the rumble, in frames. So a value of `0xFF` would trigger a rumble that lasted 255 frames—4.25 seconds! The value automatically decrements once per frame, and when it reaches a value of `0x00`, it sets the rumble intensity value back to zero as well.

Currently, the Lua script checks memory address 0xD803 every frame. We can't directly turn on the peripheral from within the Lua script; instead, we have to fetch a page running on a local server.

## Acknowledgements

None of this would be possible without [PRET](https://github.com/pret/pokepinball), [Pan Docs](https://gbdev.io/pandocs/), and the [Game Boy CPU Manual](http://marc.rawer.de/Gameboy/Docs/GBCPUman.pdf).
