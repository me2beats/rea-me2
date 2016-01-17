_, end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
if end_timesel ~= nil then
  reaper.SetEditCurPos(end_timesel, false, false)
else
  function nothing()
  end
  reaper.defer(nothing)
end
