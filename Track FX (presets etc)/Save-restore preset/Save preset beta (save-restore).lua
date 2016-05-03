retval, trnum, _, fxnum = reaper.GetFocusedFX()
if retval == 1 then
  tr = reaper.GetTrack(0,trnum-1)  
  filename = reaper.TrackFX_GetUserPresetFilename(tr, fxnum, '')
  preset_index = reaper.TrackFX_GetPresetIndex(tr, fxnum)
  reaper.SetExtState("me2beats_save-restore", "FX_preset_trnum", trnum, false)
  reaper.SetExtState("me2beats_save-restore", "FX_preset_fxnum", fxnum, false)
  reaper.SetExtState("me2beats_save-restore", "FX_preset_preset_index", preset_index, false)
end
