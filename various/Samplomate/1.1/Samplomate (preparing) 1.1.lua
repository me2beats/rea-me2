function error() reaper.MB('Please select 3 tracks with ReaSamlOmatic','Input Error',0) end

tracks = reaper.CountSelectedTracks(0)
if tracks == 3 then

  tr = reaper.GetSelectedTrack(0,0)
  _, chunk = reaper.GetTrackStateChunk(tr, '', 0)
  if chunk:find('<VST "VSTi: ReaSamplOmatic') then
    start_str, after_track_id_str, end_str = chunk:match('(.-\nTRACKID ).-(\n.-<VST "VSTi: ReaSamplOmatic.-\n.-\n).-\n.-(\n.*)')

    tb = {}
    for i = 1, 3 do

      tr = reaper.GetSelectedTrack(0,i-1)

      _, chunk = reaper.GetTrackStateChunk(tr, '', 0)
      if chunk:find('<VST "VSTi: ReaSamplOmatic') then
        wanted_str = chunk:match('.-<VST "VSTi: ReaSamplOmatic.-\n.-\n(.-\n.-)\n')
        if wanted_str:find('.DAud2F2') then
          var_str = wanted_str:match('.DAud2F2.*') -- 3n
        elseif wanted_str:find('.C53YXY') then
          var_str = wanted_str:match('.C53YXY.*') -- 3n+2
        elseif wanted_str:find('.DAwLndhdg') then
          var_str = wanted_str:match('.DAwLndhdg.*') -- 3n+1
        else
          reaper.MB('Error xxx','Error xxx',0)
        end
        
        tb[#tb+1] = var_str
        
      else error() oops = 1 break end
    end

    if oops ~= 1 then
      
      samplomate_data =
      '[start_str]=\n'..
      start_str..'\n'..
      '[after_track_id_str]=\n'..
      after_track_id_str..'\n'..
      '[end_str]=\n'..
      end_str..'\n'..
      '[var_str_1]=\n'..
      tb[1]..'\n'..
      '[var_str_2]=\n'..
      tb[2]..'\n'..
      '[var_str_3]=\n'..
      tb[3]..'\n'
            
      x = reaper.GetResourcePath(); my_os = reaper.GetOS()
      
      if my_os == 'Win32' or 'Win64' then
        x_ok = string.gsub (x, [==[\]==], [==[\\]==])
        samplomate_file = io.open(x_ok..[[\\Samplomate_data_(me2beats).txt]], "w")
      else
        x_ok = x
        samplomate_file = io.open(x_ok..[[/Samplomate_data_(me2beats).txt]], "w")
      end
      
      
      samplomate_file:write(samplomate_data)
      test = samplomate_file:read(1)
      samplomate_file:close()
      if test and test ~= '' then reaper.MB('Successful','Ok',0)
      else reaper.MB('Something went wrong','Oops',0) end
    end
  else error() end
else error() end
