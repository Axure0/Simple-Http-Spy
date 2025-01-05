getgenv().HTTPSpy = {}

assert(request, "Executor does not support request.")

-- // Settings

local Settings = { ... }

-- // Clone Functions

local NewInstance = clonefunction(Instance.new)
local tostring = clonefunction(tostring)
local format = clonefunction(string.format)
local getnamecallmethod = clonefunction(getnamecallmethod)

-- // Define Http Methods

local HttpMethods = {
    "HttpGet",
    "HttpGetAsync",
    "HttpPost",
    "HttpPostAsync"
}

-- // Utilities

local Event = NewInstance("BindableEvent")

local FileLogIndex = 0

local CustomPrint = function(Contents)
    if Settings.SaveLogs then
        local FileName = format("HTTP-SPY-Log-(%s)-#%s.txt", tostring(game.PlaceId), tostring(FileLogIndex))

        writefile(FileName, Contents)

        FileLogIndex += 1

        return
    end

    print(Contents)
end

-- // Hooks

local RequestHook; RequestHook = hookfunction(request, function(params)
    if type(params) == "string" then
        CustomPrint(format("New Plain URL Request: %s", params))
    end

    if type(params) == "table" then
        local PrintContent = "New URL Request:\n\n"

        for Index, Value in pairs(params) do
            PrintContent = PrintContent .. format("%s = %s\n", tostring(Index), tostring(Value))
        end

        CustomPrint(PrintContent)
    end

    if Event then
        Event:Fire(params)
    end

    return RequestHook(params)
end)

local HttpHook; HttpHook = hookmetamethod(game, "__namecall", function(self, ...)
    local Args = { ... }
    local Namecall = getnamecallmethod()

    if table.find(HttpMethods, Namecall) then
        local PrintContent = format("New %s Request:\n\n", Namecall)

        for Index, Value in pairs(Args) do
            PrintContent = PrintContent .. format("%s = %s\n", tostring(Index), tostring(Value))
        end

        CustomPrint(PrintContent)

        if Event then
            Event:Fire(Args)
        end
    end

    return HttpHook(self, ...)
end)

-- // Return our Event

HTTPSpy.OnEvent = Event.Event

return HTTPSpy
