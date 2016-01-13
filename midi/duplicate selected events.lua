function SaveLoopTimesel()
  init_start_timesel, init_end_timesel = reaper.GetSet_LoopTimeRange(0, 0, 0, 0, 0)
  init_start_loop, init_end_loop = reaper.GetSet_LoopTimeRange(0, 1, 0, 0, 0)
end

function RestoreLoopTimesel()
  reaper.GetSet_LoopTimeRange(1, 0, init_start_timesel, init_end_timesel, 0)
  reaper.GetSet_LoopTimeRange(1, 1, init_start_loop, init_end_loop, 0)
end

function nothing()
end

take = reaper.MIDIEditor_GetTake(reaper.MIDIEditor_GetActive())
if take ~= nil then
      
  retval, notes, ccs, sysex = reaper.MIDI_CountEvts(take)
  x = 0
  for k = 0, notes-1 do
    retval, sel, muted, startppqposOut, endppqposOut, chan, pitch, vel = reaper.MIDI_GetNote(take, k)
    if sel == true then
    
      script_title = "duplicate selected events"
      reaper.Undo_BeginBlock()
    
--      reaper.MB('sel == true','123',0)
      SaveLoopTimesel()
      reaper.MIDIEditor_LastFocused_OnCommand(40752, false) -- set time selection to selected notes
      reaper.MIDIEditor_LastFocused_OnCommand(40883, false) -- duplicate events within time selection
      RestoreLoopTimesel()
    
      reaper.Undo_EndBlock(script_title, -1)

      x = 1
      break
    end
  end
  if x == 0 then
    reaper.defer(nothing)
  end
else
  reaper.defer(nothing)
end
