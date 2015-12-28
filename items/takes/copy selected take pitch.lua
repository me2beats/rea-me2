if reaper.CountSelectedMediaItems(0) > 0 then
  sel_item = reaper.GetSelectedMediaItem(0, 0)
  act_take = reaper.GetActiveTake(sel_item)
  sel_take_pitch = reaper.GetMediaItemTakeInfo_Value(act_take, "D_PITCH")
  reaper.SetExtState("Buffer", "pitch", sel_take_pitch, false)
end