it = reaper.GetSelectedMediaItem(0, 0)
if it ~= nil then

  script_title = 'Split sel items at cursor (non-destructive for midi, select right)'
  reaper.Undo_BeginBlock()
  
  take = reaper.GetActiveTake(it)
  midi = reaper.TakeIsMIDI(take)
  if midi == true then
    cur = reaper.GetCursorPosition()
    it_len = reaper.GetMediaItemInfo_Value(it, 'D_LENGTH')
    it_pos = reaper.GetMediaItemInfo_Value(it, 'D_POSITION')
    it_end = it_len + it_pos
    if cur < it_end and cur > it_pos then
      reaper.ApplyNudge(0, 1, 3, 1, cur, false, 0) -- trim right edge of initial item to cursor
      reaper.ApplyNudge(0, 1, 5, 1, it_pos+1, false, 0) -- duplicate item and move right to 1 sec
      reaper.ApplyNudge(0, 0, 0, 1, -1, false, 0) -- move new item back
      reaper.ApplyNudge(0, 1, 3, 1, it_end, false, 0) -- trim right edge of new item to it_end
      reaper.ApplyNudge(0, 1, 1, 1, cur, false, 0) -- trim left edge of new item to cursor
      reaper.UpdateArrange()
    end
  else
    reaper.Main_OnCommand(40759, 0) -- split items at edit cursor (select right)
  end
  
  reaper.Undo_EndBlock(script_title, -1)
  
else
  function nothing()
  end
  reaper.defer(nothing)
end
