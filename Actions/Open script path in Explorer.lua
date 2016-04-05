my_os = reaper.GetOS()
if my_os == 'Win32' or 'Win64' then
  x = reaper.GetResourcePath()
  retval, script_id = reaper.GetUserInputs("Open script path in Explorer", 1, "Script ID:", "")
  if script_id:sub(1,1) == '_' then
    script_id = script_id:sub(2,-1)
    if retval == true then 
      x_ok = string.gsub (x, [==[\]==], [==[\\]==])
      kb = x_ok..[[\\reaper-kb.ini]]
      file = io.open(kb, "r")
      if file ~= nil then
        data = file:read('*a')
        file:close()
        c = data:match(script_id..'.-'..'"'..'.-'..'"'..'(.-)'..'\n')
        if c ~= nil then
        
          c = c:sub(3,-2)
          if c:find(':') ~= nil then
            path = c
          else
            c = c:gsub([[/]],[[\]])
            path = x..[[\Scripts\]]..c
          end
          str = "Explorer "..[[/select,]]..[["]]..path..[["]]
          path_dbl = path:gsub([[\]],[[\\]])
          file = io.open(path_dbl, "r")
          if file ~= nil then
            file:close()
            os.execute(str)
          else
            reaper.MB('File\n\n'..path..'\n\ndoes not exist, so you can delete it from Action List','Open script path in Explorer',0)
          end
        else
          reaper.MB("Can't find this ID in reaper-kb.ini","Open script path in Explorer",0)
        end
      end
    end
  else
    reaper.MB('Wrong script ID',"Open script path in Explorer",0)
  end
end
