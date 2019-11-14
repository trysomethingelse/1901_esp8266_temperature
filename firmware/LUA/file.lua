

function file_write_data(data)
    file.open(file_name_data, "a+")
    file.writeline(data)
    file.close()
end

function send_next_line()
    line = file.readline()
    if line ~= nil then
        if is_mqtt_connected then
            print(".................")
            print("sending from file: ")
            line = string.gsub(line,"\n","")
            print(line)
            mqtt_broker:publish(publish_path,line,1,0)          
        end
    else
        file.close()
        file.remove(file_name_data)
        is_file_exists = false
    end
   
end
