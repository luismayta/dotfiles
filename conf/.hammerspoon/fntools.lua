function flatten(t)
  local ret = {}
  for _, v in ipairs(t) do
    if type(v) == 'table' then
      for _, fv in ipairs(flatten(v)) do
        ret[#ret + 1] = fv
      end
    else
      ret[#ret + 1] = v
    end
  end
  return ret
end

function isFunction(a)
  return type(a) == "function"
end

function maybe(func)
  return function (argument)
    if argument then
      return func(argument)
    else
      return nil
    end
  end
end

-- Flips the order of parameters passed to a function
function flip(func)
  return function(...)
    return func(table.unpack(reverse({...})))
  end
end

-- gets propery or method value
-- on a table
function result(obj, property)
  if not obj then return nil end

  if isFunction(property) then
    return property(obj)
  elseif isFunction(obj[property]) then -- string
    return obj[property](obj) -- <- this will be the source of bugs
  else
    return obj[property]
  end
end


invoke = result -- to indicate that we're calling a method

-- property, object
function getProperty(property)
    return partial(flip(result), property)
end


-- from Moses
--- Reverses values in a given array. The passed-in array should not be sparse.
-- @name reverse
-- @tparam table array an array
-- @treturn table a copy of the given array, reversed
function reverse(array)
  local _array = {}
  for i = #array,1,-1 do
    _array[#_array+1] = array[i]
  end
  return _array
end

function compose(...)
  local functions = {...}

  return function (...)
    local result

    for i, func in ipairs(functions) do
      if i == 1 then
        result = func(...)
      else
        result = func(result)
      end
    end

    return result
  end
end

-- http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- does a shallow comparison of
-- key based tables

-- a = {h = 50, w = 50}
-- b = {h = 50, w = 50}
-- c = {h = 100, w = 100}

-- compareShallow(a, b)
-- > true

-- compareShallow(a, c)
-- > false

-- @param tableA table
-- @param tableB table

-- @returns bool
function compareShallow(tableA, tableB)
  if tableA == nil or tableB == nil then return false end

  for k, v in pairs(tableA) do
    -- dbgf('comparing %s to %s', v, tableB[k])
    if v ~= tableB[k] then return false end
  end

  return true
end
