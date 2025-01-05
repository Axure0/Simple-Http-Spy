# Simple-Http-Spy

I haven't seen many HTTP-Spy scripts, so I thought I'd make one.

(This HTTP-Spy was meant to be something basic, I wouldn't recommend it for more advanced usage.)

```lua
  local HTTPSpy = loadstring(game:HttpGet("https://raw.githubusercontent.com/Axure0/Simple-Http-Spy/refs/heads/main/main.lua"))({
    SaveLogs = false -- // Set this to true if you prefer the requests to save to your workspace folder instead of printing.
  })

  -- // Quick Example of how to use OnEvent

  HTTPSpy.OnEvent:Connect(function(...)
    local Args = { ... }

    print("[HTTP Spy] Event Connected.")

    for Index, Value in pairs(Args) do
      print(tostring(Index), tostring(Value))
    end
  end)
```
