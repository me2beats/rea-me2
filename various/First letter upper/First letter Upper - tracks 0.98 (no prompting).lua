function main()
  local ch_count = reaper.GetProjectStateChangeCount(0)

  if not last_ch_count or last_ch_count ~= ch_count then
    local tracks = reaper.CountTracks(0)
    for i = 0, tracks-1 do
      local tr = reaper.GetTrack(0,i)
      local _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
      if tr_name ~= '' then
        if tr_name:sub(1,1):match('%l') then
          if #tr_name > 1 then
            tr_name = tr_name:sub(1,1):upper()..tr_name:sub(2,-1)
          else tr_name = tr_name:sub(1,1):upper() end
          reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', tr_name, 1)
        end
      end     
    end
  end

  last_ch_count = ch_count
  reaper.defer(main)
end

-----------------------------------------------

function SetButtonON()
  reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  reaper.RefreshToolbar2( sec, cmd )
  main()
end

-----------------------------------------------

function SetButtonOFF()
  reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  reaper.RefreshToolbar2( sec, cmd ) 
end

-----------------------------------------------

  _, _, sec, cmd = reaper.get_action_context()
  SetButtonON()
  reaper.atexit(SetButtonOFF)
