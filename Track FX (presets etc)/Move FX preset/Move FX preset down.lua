--function nothing() end

retval, trnum, _, fxnum = reaper.GetFocusedFX()
if retval == 1 then
  tr = reaper.GetTrack(0,trnum-1)  
  preset_index = reaper.TrackFX_GetPresetIndex(tr, fxnum)
  filename = reaper.TrackFX_GetUserPresetFilename(tr, fxnum, '')
  
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
    if preset_index ~= presets-1 then
    
      reaper.Undo_BeginBlock()
      
      _, preset_name = reaper.TrackFX_GetPreset(tr, fxnum, '')
      x = x:gsub('%[Preset'..(preset_index+1)..'%]', '[Preset'..'n'..']', 1)
      x = x:gsub('%[Preset'..preset_index..'%]', '[Preset'..(preset_index+1)..']', 1)
      x = x:gsub('%[Preset'..'n'..'%]', '[Preset'..preset_index..']', 1)

      file_new = io.open(filename_ok, "w")
      file_new:write(x)
      file_new:close()
      reaper.TrackFX_SetPreset(tr, fxnum, preset_name)
      reaper.Undo_EndBlock('', 2)
    end
  end
end
