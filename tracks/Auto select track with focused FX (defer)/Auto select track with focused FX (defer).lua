function main()
  local _, trnum = reaper.GetFocusedFX()

  if not last_trnum or last_trnum ~= trnum then
    if trnum then reaper.SetOnlyTrackSelected(reaper.GetTrack(0,trnum-1)) end
  end

  last_trnum = trnum
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
