function nothing()
end
  
retval, trnum, _, fxnum = reaper.GetFocusedFX()
if retval == 1 then

  tr = reaper.GetTrack(0,trnum-1)
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
    preset_index = reaper.TrackFX_GetPresetIndex(tr, fxnum)
    
    if presets > preset_index then
      _, fx_name = reaper.TrackFX_GetFXName(tr, fxnum, '')
      prompt = reaper.MB('Deleting preset: '..preset_name..'; '..fx_name..'. Continue?', 'Delete current FX preset', 1)
      if prompt == 1 then

        script_title = 'Delete current FX preset'
        reaper.Undo_BeginBlock()

        y = x:gsub("NbPresets=(%d*)", "NbPresets="..math.ceil(presets-1), 1)

        if preset_index == presets-1 then
          z = y:gsub('%[Preset'..preset_index..'.*', "")
        else
          z = y:gsub('%[Preset'..preset_index..'%]'..'.-%'..'[Preset', "[Preset")    
          for i = preset_index, presets-1 do
            z = z:gsub('%[Preset'..i..'%]', '[Preset'..(i-1)..']', 1)
          end
        end
 

        file_new = io.open(filename_ok, "w")
        file_new:write(z)
        file_new:close()

        if preset_index == presets-1 then
          reaper.TrackFX_SetPresetByIndex(tr, fxnum, 0)
        else
          reaper.TrackFX_SetPresetByIndex(tr, fxnum, preset_index)
        end

        reaper.Undo_EndBlock(script_title, -1)
      end
    else
      reaper.MB("Can't delete built-in presets",'Delete current FX preset',0)
    end
  else
    reaper.MB('The preset file does not exist','Delete current FX preset',0)
  end
else
  reaper.defer(nothing)
end
