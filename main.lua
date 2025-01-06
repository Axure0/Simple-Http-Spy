if getgenv().HTTPSpy then return getgenv().HTTPSpy end

assert(request, "Executor does not support request.")

-- // HTTPSpy Metatable (Bindable Events suck so I'll go with this)

local Events = {}
local OnFiredFunction = nil

local HTTPSpy = setmetatable(Events, {
    __index = function(t, k)
        if type(k) == "string" and k:lower() == "onfired" then
            local Self = {}

            function Self:Connect(func)
                func()
            end

            return Self
        end

        return rawget(Events, k)
    end,

    __newindex = function(t, k, v)
        if Events[k] == v then return end

        rawset(Events, k, v)

        if OnFiredFunction then
            OnFiredFunction(k, v)
        end
    end
})

-- // Settings

local BaseSettings = {
    ToConsole = false
}

local Settings = ... or BaseSettings

if not (type(Settings) == "table") then
    Settings = BaseSettings
end

-- // Clone Functions

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
    return
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

    HTTPSpy[#HTTPSpy + 1] = params

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

        HTTPSpy[#HTTPSpy + 1] = Args
    end

    return HttpHook(self, ...)
end)

-- // Return our Metatable

getgenv().HTTPSpy = HTTPSpy

return getgenv().HTTPSpy
