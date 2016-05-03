trnum = reaper.GetExtState("me2beats_save-restore", "FX_preset_trnum")
fxnum = reaper.GetExtState("me2beats_save-restore", "FX_preset_fxnum")
preset_index = reaper.GetExtState("me2beats_save-restore", "FX_preset_preset_index")
if trnum ~= '' and fxnum ~= '' and preset_index ~= '' then
  reaper.Undo_BeginBlock()
  tr = reaper.GetTrack(0,trnum-1)
  reaper.TrackFX_SetPresetByIndex(tr, fxnum, preset_index)
  reaper.Undo_EndBlock('Restore preset beta', -1)
end
