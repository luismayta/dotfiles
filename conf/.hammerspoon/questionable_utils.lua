function curry(func, num_args)
  num_args = num_args or debug.getinfo(func, "u").nparams

  if num_args < 2 then return func end

  local function helper(argtrace, n)
    if n < 1 then
      return func(unpack(flatten(argtrace)))
    else
      return function (...)
        return helper({argtrace, ...}, n - select("#", ...))
      end
    end
  end
  return helper({}, num_args)
end

function variadic_maybe (func)

  -- the basic problem here is that it dumps
  -- nil values, i.e there's no way of telling ..
  function all (...)
    local args = pack2{...}
    hs.alert.show(hs.inspect.inspect(...), hs.inspect.inspect(args))
    for i, v in pairs(args) do
      print(v)
      if not v then
        print("FOO")
        return false
      end
    end
    return true
  end

  return function (...)
    hs.alert.show(hs.inspect.inspect(...))
    if all(...) then
      return func(...)
    else
      return nil
    end
  end
end