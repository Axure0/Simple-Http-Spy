# Simple-Http-Spy

I haven't seen many HTTP-Spy scripts, so I thought I'd make one.

(This HTTP-Spy was meant to be something basic, I wouldn't recommend it for more advanced usage.)

```lua
  local HTTPSpy = loadstring(game:HttpGet("https://raw.githubusercontent.com/Axure0/Simple-Http-Spy/refs/heads/main/main.lua"))({
    ToConsole = false -- // Set this to true if you prefer the requests to be added to the executor console.
  })

  -- // Quick Example of how to use OnEvent

  HTTPSpy.OnFired:Connect(function(k, v)
    print("[HTTP Spy] Event Connected.")

    print(k, v)
  end)
```
