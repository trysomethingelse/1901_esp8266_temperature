is_mqtt_connected = false
function mqtt_start()
    m=mqtt.Client(client_id,120)

    --last will and testamet
    m:lwt(lw_path,"offline",0,0)

    m:on("connect", function(client) print("connected")end)
    m:on("offline",function(client) print "offline"end)

    m:on("message", function(client, topic, data)
        print(topic..":")
        if data ~= nil then
            print(data)
            if topic == subscribe_path then
                file.open(file_name_deep_sleep, "w")
                file.writeline(data)
                file.close()
                dsleep_time_s = tonumber(data)
            end
        end
    end)

    m:on("overflow", function(client, topic, data)
    print(topic .. " partial overflowed message: " .. data )
    end)
    m:connect(ip_address, port, 0, function(client)
        print("mqtt connected")
        is_mqtt_connected = true      
        client:subscribe(subscribe_path, 1, function(client) print("subscribe success") end)    
        
    end,
    function(client, reason)
      print("failed reason: " .. reason)
    end)
    
    return m
end

