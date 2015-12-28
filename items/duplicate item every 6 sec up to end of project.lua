if reaper.CountSelectedMediaItems(0) > 0 then
  reaper.Main_OnCommand(40043, 0)
  end_pos = reaper.GetCursorPosition()
  sel_item = reaper.GetSelectedMediaItem(0, 0)
  sel_item_start = reaper.GetMediaItemInfo_Value(sel_item, "D_POSITION")
  d = 6
  k = math.floor ((end_pos - sel_item_start)/d) - 1
  reaper.ApplyNudge(0, 0, 5, 1, d, false, k)
end