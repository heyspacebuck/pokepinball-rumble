-- A Lua script for BizHawk and a regular Pokemon Pinball ROM
-- Space Buck, August 30 2021

-- Ideally this would read address 0xD803 to get vibration intensity and 0xD804 to get vibration duration, but that would involve re-writing things in the Double-Oh Repo that I don't have the means to test right now.

local rumbleDuration = 0

while true do
  local rumble = memory.readbyte(0xd803)
  if rumble ~= 0x00 then
    if rumbleDuration < 0 then
      rumbleDuration = 12
      io.popen("curl doubleoh.local/pinball") -- Of course you can change this to suit your purposes
      print('bzzz')
    end
  end
  rumbleDuration = rumbleDuration - 1
  emu.frameadvance()
end
