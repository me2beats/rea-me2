retval, trnum, _, fxnum = reaper.GetFocusedFX()
if retval == 1 then
  tr = reaper.GetTrack(0,trnum-1)  
  preset_index = reaper.TrackFX_GetPresetIndex(tr, fxnum)
  
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

    reaper.Undo_BeginBlock()

    if preset_index == presets-1 then
      reaper.TrackFX_SetPresetByIndex(tr, fxnum, 0)
    else
      reaper.TrackFX_SetPresetByIndex(tr, fxnum, preset_index+1)
    end
    reaper.Undo_EndBlock('', 2)
  end
end
