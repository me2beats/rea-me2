retval, trnum, _, fxnum = reaper.GetFocusedFX()
if retval == 1 then
  tr = reaper.GetTrack(0,trnum-1)  
  preset_index = reaper.TrackFX_GetPresetIndex(tr, fxnum)
    
  reaper.Undo_BeginBlock()

  if preset_index == 0 then
    filename = reaper.TrackFX_GetUserPresetFilename(tr, fxnum, '')
    _, preset_name = reaper.TrackFX_GetPreset(tr, fxnum, '')
    
    os = reaper.GetOS()
    if os == 'Win32' or 'Win64' then
      filename_ok = string.gsub (filename, [[\]], [[\\]])
    else
      filename_ok = filename
    end
    file = io.open(filename_ok, "r")
    if file ~= nil then
      x = file:read('*a')
      file:close()
      presets = tonumber(x:match("NbPresets=(%d*)"))
    
      reaper.TrackFX_SetPresetByIndex(tr, fxnum, presets-1)      
    end
  else
    reaper.TrackFX_SetPresetByIndex(tr, fxnum, preset_index-1)
  end
  
  instr_num = reaper.TrackFX_GetInstrument(tr)
  
  if instr_num == fxnum then
    
    _, new_preset_name = reaper.TrackFX_GetPreset(tr, fxnum, '')
    reaper.GetSetMediaTrackInfo_String(tr, "P_NAME", new_preset_name, true)
  end
  
  reaper.Undo_EndBlock('', 2)
end
