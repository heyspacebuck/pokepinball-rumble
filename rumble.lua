-- My first Lua script for BizHawk and the hacked Pokemon Pinball ROM
-- Space Buck, October 3 2020
foo = 0;

--comm.socketServerSetIp("192.168.178.71");

while true do
  local rumble = memory.readbyte(0xff01)
  -- If bit 3 is HIGH, rumble is happening
  if rumble==0x08 then
    if foo < 0 then
      foo = 12
      -- cURL here?
      io.popen("curl doubleoh.local/pinball")
      --comm.httpGet("http://doubleoh.local/pinball");
      print('bzzz')
    end
  end
  foo = foo - 1;
  emu.frameadvance();
end
