function nothing()
end
  
retval, trnum, _, fxnum = reaper.GetFocusedFX()
if retval == 1 then

  tr = reaper.GetTrack(0,trnum-1)
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
    
    if presets > 1 then

      _, preset_name = reaper.TrackFX_GetPreset(tr, fxnum, '')
      script_title = 'Sort presets of focused FX'
      reaper.Undo_BeginBlock()


      l = {}
      
      for w, ww in string.gmatch(x, '%[Preset(.-)]%\n.-Name=(.-)%\n') do
        l[ww] = w
      end
      
      table.sort(l)


      tab = {}
      local ordered_keys = {}
      
      for k in pairs(l) do
        table.insert(ordered_keys, k)
      end
      
      table.sort(ordered_keys)
      for i = 1, #ordered_keys do
        local k, v = ordered_keys[i], l[ ordered_keys[i] ]
        x = x:gsub('%[Preset'..v..'%]', '[Preset'..(i-1)..']', 1)
      end
 
 
      file_new = io.open(filename_ok, "w")
      file_new:write(x)
      file_new:close()

      reaper.TrackFX_SetPreset(tr, fxnum, preset_name)

      reaper.Undo_EndBlock(script_title, -1)
    end
  end
else
  reaper.defer(nothing)
end
