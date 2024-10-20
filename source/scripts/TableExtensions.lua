function table.getKeys(t, sort)
    local keys = {}
    for key,_ in pairs(t) do
        table.insert(keys, key)
    end

    if sort then
        table.sort(keys)
    end
    return keys
end

function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return -1
end

function table.contains(array, value)
    return table.indexOf(array, value) ~= -1
end

function table.removeValue(array, value)
    for i, v in ipairs(array) do
        if v == value then
            table.remove(array, i)
            return
        end
    end
end

function table.where(array, predicate)
    local whereArray = {}
    for _, v in ipairs(array) do
        if predicate(v) then
            table.insert(whereArray, v)
        end
    end
    return whereArray
end

function table.containsAny(array, predicate)
    return table.find(array, predicate) ~= nil
end

function table.find(array, predicate)
    for _, v in ipairs(array) do
        if predicate(v) then
            return v
        end
    end
    return nil
end

function table.addRange(array, otherArray)
    for _, v in ipairs(otherArray) do
        table.insert(array, v)
    end
end