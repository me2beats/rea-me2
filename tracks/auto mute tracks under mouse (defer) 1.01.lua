local r = reaper

function main()
  
  local tr = r.BR_TrackAtMouseCursor()
  if not tr then goto continue end

  muted = r.GetMediaTrackInfo_Value(tr, 'B_MUTE')
  if muted == false then goto continue end

  r.SetMediaTrackInfo_Value(tr, 'B_MUTE', 1)

  ::continue::

  r.defer(main)
end

-----------------------------------------------

function SetButtonON()
  r.SetToggleCommandState( sec, cmd, 1 )
  r.RefreshToolbar2( sec, cmd )
  main()
end

-----------------------------------------------

function SetButtonOFF()
  r.SetToggleCommandState( sec, cmd, 0 )
  r.RefreshToolbar2( sec, cmd ) 
end

-----------------------------------------------
_, _, sec, cmd = r.get_action_context()
SetButtonON()
r.atexit(SetButtonOFF)

