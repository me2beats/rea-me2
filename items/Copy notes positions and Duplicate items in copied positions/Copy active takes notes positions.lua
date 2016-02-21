function nothing() end

sel_items = reaper.CountSelectedMediaItems(0)
if sel_items > 0 then
  script_title = 'Copy active takes notes positions'
  reaper.Undo_BeginBlock()
  t = {}
  for i = 0, sel_items-1 do
    sel_it = reaper.GetSelectedMediaItem(0, i)
    take = reaper.GetActiveTake(sel_it)
    if reaper.TakeIsMIDI(take) == true then
      _, notes = reaper.MIDI_CountEvts(take)
      for n = 0, notes-1 do
        _, _, _, startppq = reaper.MIDI_GetNote(take, n)
        start = reaper.MIDI_GetProjTimeFromPPQPos(take, startppq)
        table.insert (t, start)
      end
    end
  end
  t_str = table.concat (t, ' ' )
  reaper.SetExtState('me2beats', 'take_notes_positions', t_str, false)
  reaper.Undo_EndBlock(script_title, -1)
else
  reaper.defer(nothing)
end

