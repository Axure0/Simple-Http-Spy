if getgenv().HTTPSpy then return getgenv().HTTPSpy end

getgenv().HTTPSpy = {}

assert(request, "Executor does not support request.")

-- // Settings

local BaseSettings = {
    ToConsole = false
}

local Settings = ... or BaseSettings

if not type(Settings) == "table" then
    Settings = BaseSettings
end

-- // Clone Functions

local rconsoleprint = clonefunction(rconsoleprint)
local messagebox = clonefunction(messagebox)
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

local CustomPrint = function(Contents)
    if Settings.ToConsole then
        if rconsoleprint then
            rconsoleprint(Contents)

            return
        end

        if messagebox then
            messagebox(Contents)

            return
        end
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
