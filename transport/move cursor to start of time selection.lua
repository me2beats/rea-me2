start_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
if start_timesel ~= nil then
  reaper.SetEditCurPos(start_timesel, false, false)
else
  function nothing()
  end
  reaper.defer(nothing)
end
