function nothing() end; function bla() reaper.defer(nothing) end
local retval, pan = reaper.GetUserInputs("Pan", 1, "Set track pan, percents:", "")
if retval == true then
  pan = tonumber(pan)
  if pan >=-100 and pan <=100 then
    reaper.Undo_BeginBlock()
    local tr = reaper.BR_TrackAtMouseCursor()
    if tr then reaper.SetMediaTrackInfo_Value(tr, 'D_PAN', 0.01*pan) end
    reaper.Undo_EndBlock('Set pan for selected tracks', -1)
  else bla() end
else bla() end
