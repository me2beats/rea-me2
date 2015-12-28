sel_it_count = reaper.CountSelectedMediaItems(0)
if sel_it_count > 0 then
  p = reaper.GetExtState("Buffer", "pitch")
  for i = 0, sel_it_count-1 do
    sel_item = reaper.GetSelectedMediaItem(0, i)
    act_take = reaper.GetActiveTake(sel_item)
    reaper.SetMediaItemTakeInfo_Value(act_take, "D_PITCH", p)
    i = i+1
  end
  reaper.UpdateArrange()
end
