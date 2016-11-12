r = reaper

function main()
  time = os.time()-init
  if time - last_update >= 1 then 
    if not last_active_editor then
      last_active_editor = r.MIDIEditor_GetActive()
      if last_active_editor then
        take = r.MIDIEditor_GetTake(r.MIDIEditor_GetActive())
        item = r.GetMediaItemTake_Item(take)
      end
    else
      active_editor = r.MIDIEditor_GetActive()
      if last_active_editor ~= active_editor then
        _, notes = r.MIDI_CountEvts(take)
        for k = 0, notes-1 do
          _, sel, muted, start_note, end_note, chan, pitch, vel = r.MIDI_GetNote(take, k)
          r.MIDI_SetNote(take, k, 0, muted, start_note, end_note, chan, pitch, vel)
        end
        r.SetMediaItemSelected(item,0)
        r.UpdateItemInProject(item)
        last_active_editor = nil
      end
    end
    last_update = time
  end
  r.defer(main)
end

-----------------------------------------------

function SetButtonON()
  r.SetToggleCommandState( sec, cmd, 1 ) -- Set ON
  r.RefreshToolbar2( sec, cmd )
  main()
end

-----------------------------------------------

function SetButtonOFF()
  r.SetToggleCommandState( sec, cmd, 0 ) -- Set OFF
  r.RefreshToolbar2( sec, cmd ) 
end

-----------------------------------------------

init = os.time()
last_update = os.time()-init
_, _, sec, cmd = r.get_action_context()
SetButtonON()
r.atexit(SetButtonOFF)

