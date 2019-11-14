print("starting application.lua...")

is_data_sent = false
is_file_exists = false
--ds18b20 = require("ds18b20")

--ds18b20.setup(ds18b20_pin)
--ds18b20.setting({},11) --11 bit resolution

if dsleep_time_s == nil then
    if file.open(file_name_deep_sleep ,"r")then
        line = file.readline()
        line = string.gsub(line,"\n","")
        dsleep_time_s  = tonumber(line)
        file.close()
    else
        dsleep_time_s = 120
    end
end

if is_connected_wifi then
  mqtt_broker = mqtt_start()
  --synchronize time forever with nodemcu servers
  sntp.sync(nil, nil, nil, 1)
end

is_temp_ready = false
temperature=0

--ds18b20.read(function(ind,rom,res,temp,tdec,par)
--is_temp_ready = true
--temperature = temp 
--end,{})

tmr.create():alarm(main_timer_interval, tmr.ALARM_AUTO, function()
  sec = rtctime.get()
   --add 7200 seconds to make utc+2
  tm = rtctime.epoch2cal(sec+7200)
 
  if is_temp_ready and sec > 0 then
    date_time = string.format("%04d-%02d-%02d %02d:%02d:%02d", tm["year"],
    tm["mon"], tm["day"], tm["hour"], tm["min"], tm["sec"])
    data = string.format("%f",temperature)..delimiter..date_time
    if is_mqtt_connected then
      if not is_file_exists and file.open(file_name_data,"r") ~= nil then
        is_file_exists = true
      else
        is_temp_ready = false
        print(".................")
        print("sending..."..data)
        mqtt_broker:publish(publish_path,data,1,0) 
        is_data_sent= true
      end
    else
      is_temp_ready = false
      print("writing data to file")
      file_write_data(data)    
      is_data_sent = true     
    end
  end

end)
--timer for sending chunks of data from file
tmr.create():alarm(data_timer_interval, tmr.ALARM_AUTO, function()
    if is_file_exists then
        send_next_line()
    end
end)

tmr.create():alarm(dsleep_timer_interval, tmr.ALARM_AUTO, function()
    if is_data_sent then
        is_data_sent = false
        print("going to deep sleep for "..dsleep_time_s.." seconds")
--        wifi.sta.disconnect()
--        dsleep_for(dsleep_time_s)
    end
end)

function dsleep_for(seconds)
  rtctime.dsleep(seconds*1000000)
end
