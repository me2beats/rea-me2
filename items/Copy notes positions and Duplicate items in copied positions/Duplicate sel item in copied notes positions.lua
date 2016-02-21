function nothing() end

sel_item = reaper.GetSelectedMediaItem(0,0)
if sel_item ~= nil then
  script_title = 'Duplicate sel item in copied notes positions'
  reaper.Undo_BeginBlock()
  t_str = reaper.GetExtState('me2beats', 'take_notes_positions')
  if t_str ~= '' then
    sep = "%s"
    t={} ; iter=1
    for str in string.gmatch(t_str, "([^"..sep.."]+)") do
      t[iter] = str
      iter = iter + 1
    end
    for x = 1, #t do
      pos = t[x]
      reaper.ApplyNudge(0, 1, 5, 1, pos, false, 0)
    end
    reaper.UpdateArrange()
  else
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end
