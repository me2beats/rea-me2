function nothing()
end

v = 125

take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
if take ~= nil then

  script_title = 'set selected notes velocity to '..v..''
  reaper.Undo_BeginBlock()

  retval, notes, ccs, sysex = reaper.MIDI_CountEvts(take)
  x = 0
  for n = 0, notes-1 do
    retval, sel, muted, startpos, endpos, chan, pitch, vel = reaper.MIDI_GetNote(take, n)
    if sel == true then
      reaper.MIDI_SetNote(take, n, sel, muted, startpos, endpos, chan, pitch, v)
    end
  end
  reaper.Undo_EndBlock(script_title, -1)
else
  reaper.defer(nothing)
end
