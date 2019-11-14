print("Creating http server...")

require("httpserver").createServer(80, function(req, res)
  -- analyse method and url
  print("+R", req.method, req.url, node.heap())
  -- setup handler of headers, if any
  req.onheader = function(self, name, value)
    print("+H", name, value)
    -- E.g. look for "content-type" header,
    --   setup body parser to particular format
    -- if name == "content-type" then
    --   if value == "application/json" then
    --     req.ondata = function(self, chunk) ... end
    --   elseif value == "application/x-www-form-urlencoded" then
    --     req.ondata = function(self, chunk) ... end
    --   end
    -- end
  end
  -- setup handler of body, if any
  req.ondata = function(self, chunk)
--    print("+B", chunk and #chunk, node.heap())
    if not chunk then
      -- reply
      local request = "HTTP/1.1\r\n Connection:close\r\n\r\n"
--      local conn2 = net.createConnection(net.TCP, 0)
      res:send(request)
      res:finish()
      

    end
  end
  -- or just do something not waiting till body (if any) comes
--  res:finish("")
  --res:finish("Salut, monde!")
end)