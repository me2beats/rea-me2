function nothing()
end

old = 127
new = 125

take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
if take ~= nil then

  script_title = 'set notes with velocity = '..old..' to '..new..''
  reaper.Undo_BeginBlock()

  retval, notes, ccs, sysex = reaper.MIDI_CountEvts(take)
  for n = 0, notes-1 do
    retval, sel, muted, startpos, endpos, chan, pitch, vel = reaper.MIDI_GetNote(take, n)
    if vel == old then
      reaper.MIDI_SetNote(take, n, sel, muted, startpos, endpos, chan, pitch, new)
    end
  end
  reaper.Undo_EndBlock(script_title, -1)
else
  reaper.defer(nothing)
end
