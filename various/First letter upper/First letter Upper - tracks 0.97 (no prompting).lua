function main()
  tracks = reaper.CountTracks(0)
  for i = 0, tracks-1 do
    tr = reaper.GetTrack(0,i)
    _, tr_name = reaper.GetSetMediaTrackInfo_String(tr, 'P_NAME', '', 0)
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

function first_letter_upper_all_tracks()
  st_ch = reaper.GetProjectStateChangeCount(0) - init_st_ch
  if st_ch - update_st_ch > 0 then update_st_ch = st_ch; main() end
  reaper.defer(first_letter_upper_all_tracks)
end

-- Set ToolBar Button ON
function SetButtonON()
  _, _, sec, cmd = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  reaper.RefreshToolbar2( sec, cmd )
end
--
-- Set ToolBar Button OFF
function SetButtonOFF()
  _, _, sec, cmd = reaper.get_action_context()
  state = reaper.GetToggleCommandStateEx( sec, cmd )
  reaper.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  reaper.RefreshToolbar2( sec, cmd )
end

init_st_ch = reaper.GetProjectStateChangeCount(0)
update_st_ch = reaper.GetProjectStateChangeCount(0) - init_st_ch

main()
first_letter_upper_all_tracks()

SetButtonON()

reaper.atexit( SetButtonOFF )
