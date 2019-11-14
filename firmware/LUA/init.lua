-- load credentials, 'SSID' and 'PASSWORD' declared and initialize in there
dofile("my_http_server.lua")
dofile("credentials.lua")
dofile("constants.lua")
dofile("mqtt.lua")
dofile("file.lua")

is_connected_wifi = nil

function startup()
    if file.open("init.lua") == nil then
        print("init.lua deleted or renamed")
    else
        print("Running")
        file.close("init.lua")
        -- the actual application is stored in 'application.lua'
        dofile("application.lua")
    end
end

-- Define WiFi station event callbacks
wifi_connect_event = function(T)
  print("Connection to AP("..T.SSID..") established!")
  print("Waiting for IP address...")
  if disconnect_ct ~= nil then disconnect_ct = nil end
  if disconnect_ct_no_ap ~= nil then disconnect_ct_no_ap = nil end
end

wifi_got_ip_event = function(T)
  -- Note: Having an IP address does not mean there is internet access!
  -- Internet connectivity can be determined with net.dns.resolve().
  is_connected_wifi = true
  print("Wifi connection is ready! IP address is: "..T.IP)
  print("Startup will resume momentarily, you have 3 seconds to abort.")
  print("Waiting...")
  tmr.create():alarm(3000, tmr.ALARM_SINGLE, startup)
end

wifi_disconnect_event = function(T)
  if T.reason == wifi.eventmon.reason.ASSOC_LEAVE then
    --the station has disassociated from a previously connected AP
    return
  end

  print("\nWiFi connection to AP("..T.SSID..") has failed!")

  --There are many possible disconnect reasons, the following iterates through
  --the list and returns the string corresponding to the disconnect reason.
  for key,val in pairs(wifi.eventmon.reason) do
    if val == T.reason then
      print("Disconnect reason: "..val.."("..key..")")
      break
    end
  end

  if disconnect_ct == nil or disconnect_ct_no_ap == nil then
    disconnect_ct = 1
    disconnect_ct_no_ap = 1
  else
    disconnect_ct = disconnect_ct + 1
    if val == 201 then --no ap found
      disconnect_ct_no_ap = disconnect_ct_no_ap + 1
    end
  end
  if disconnect_ct < total_tries and disconnect_ct < no_ap_tries  then
    print("Retrying connection...(attempt "..(disconnect_ct+1).." of "..total_tries..")")
  else
    wifi.sta.disconnect()
    print("Aborting connection to AP!")
    disconnect_ct = nil
    disconnect_ct_no_ap = nil

    is_connected_wifi = false
    print("Cant connect to WIFI")
    print("Going to save data to memory")
    print("Startup will resume momentarily, you have 3 seconds to abort.")
    print("Waiting...")
    tmr.create():alarm(3000, tmr.ALARM_SINGLE, startup)
  end
end

-- Register WiFi Station event callbacks
wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, wifi_connect_event)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, wifi_got_ip_event)
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, wifi_disconnect_event)

print("Connecting to WiFi access point...")
wifi.setmode(wifi.STATION)
wifi.sta.config({ssid=SSID, pwd=PASSWORD})



