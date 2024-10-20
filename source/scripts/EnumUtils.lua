EnumUtils = {}

function EnumUtils.createEnum(names)
    local enum = {}
    local toNameLookup = {}

    enum.length = #names
    for value, name in ipairs(names) do
        enum[name] = value
        toNameLookup[value] = name
    end

    enum.toName = function(value)
        return toNameLookup[value]
    end

    enum.randomValue = function()
        return enum[math.randomSelect(toNameLookup)]
    end

    return enum
end

-- Create a zero indexed enum, useful if you want it to match up to a C one.
function EnumUtils.createZeroIndexedEnum(names)
    local enum = {}
    local toNameLookup = {}

    enum.length = #names
    for index, name in ipairs(names) do
        local value = index - 1
        enum[name] = value
        toNameLookup[value] = name
    end

    enum.toName = function(value)
        return toNameLookup[value]
    end

    enum.randomValue = function()
        return enum[math.random(0, #toNameLookup - 1)]
    end

    return enum
end