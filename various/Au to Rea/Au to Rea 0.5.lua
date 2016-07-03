function nothing() end

local ansi_decode={
  [128]='\208\130',[129]='\208\131',[130]='\226\128\154',[131]='\209\147',[132]='\226\128\158',[133]='\226\128\166',
  [134]='\226\128\160',[135]='\226\128\161',[136]='\226\130\172',[137]='\226\128\176',[138]='\208\137',[139]='\226\128\185',
  [140]='\208\138',[141]='\208\140',[142]='\208\139',[143]='\208\143',[144]='\209\146',[145]='\226\128\152',
  [146]='\226\128\153',[147]='\226\128\156',[148]='\226\128\157',[149]='\226\128\162',[150]='\226\128\147',[151]='\226\128\148',
  [152]='\194\152',[153]='\226\132\162',[154]='\209\153',[155]='\226\128\186',[156]='\209\154',[157]='\209\156',
  [158]='\209\155',[159]='\209\159',[160]='\194\160',[161]='\209\142',[162]='\209\158',[163]='\208\136',
  [164]='\194\164',[165]='\210\144',[166]='\194\166',[167]='\194\167',[168]='\208\129',[169]='\194\169',
  [170]='\208\132',[171]='\194\171',[172]='\194\172',[173]='\194\173',[174]='\194\174',[175]='\208\135',
  [176]='\194\176',[177]='\194\177',[178]='\208\134',[179]='\209\150',[180]='\210\145',[181]='\194\181',
  [182]='\194\182',[183]='\194\183',[184]='\209\145',[185]='\226\132\150',[186]='\209\148',[187]='\194\187',
  [188]='\209\152',[189]='\208\133',[190]='\209\149',[191]='\209\151'
}
local utf8_decode={
  [128]={[147]='\150',[148]='\151',[152]='\145',[153]='\146',[154]='\130',[156]='\147',[157]='\148',[158]='\132',[160]='\134',[161]='\135',[162]='\149',[166]='\133',[176]='\137',[185]='\139',[186]='\155'},
  [130]={[172]='\136'},
  [132]={[150]='\185',[162]='\153'},
  [194]={[152]='\152',[160]='\160',[164]='\164',[166]='\166',[167]='\167',[169]='\169',[171]='\171',[172]='\172',[173]='\173',[174]='\174',[176]='\176',[177]='\177',[181]='\181',[182]='\182',[183]='\183',[187]='\187'},
  [208]={[129]='\168',[130]='\128',[131]='\129',[132]='\170',[133]='\189',[134]='\178',[135]='\175',[136]='\163',[137]='\138',[138]='\140',[139]='\142',[140]='\141',[143]='\143',[144]='\192',[145]='\193',[146]='\194',[147]='\195',[148]='\196',
    [149]='\197',[150]='\198',[151]='\199',[152]='\200',[153]='\201',[154]='\202',[155]='\203',[156]='\204',[157]='\205',[158]='\206',[159]='\207',[160]='\208',[161]='\209',[162]='\210',[163]='\211',[164]='\212',[165]='\213',[166]='\214',
    [167]='\215',[168]='\216',[169]='\217',[170]='\218',[171]='\219',[172]='\220',[173]='\221',[174]='\222',[175]='\223',[176]='\224',[177]='\225',[178]='\226',[179]='\227',[180]='\228',[181]='\229',[182]='\230',[183]='\231',[184]='\232',
    [185]='\233',[186]='\234',[187]='\235',[188]='\236',[189]='\237',[190]='\238',[191]='\239'},
  [209]={[128]='\240',[129]='\241',[130]='\242',[131]='\243',[132]='\244',[133]='\245',[134]='\246',[135]='\247',[136]='\248',[137]='\249',[138]='\250',[139]='\251',[140]='\252',[141]='\253',[142]='\254',[143]='\255',[144]='\161',[145]='\184',
    [146]='\144',[147]='\131',[148]='\186',[149]='\190',[150]='\179',[151]='\191',[152]='\188',[153]='\154',[154]='\156',[155]='\158',[156]='\157',[158]='\162',[159]='\159'},[210]={[144]='\165',[145]='\180'}
}

local nmdc = {
  [36] = '$',
  [124] = '|'
}

function AnsiToUtf8(s)
  local r, b = ''
  for i = 1, s and s:len() or 0 do
    b = s:byte(i)
    if b < 128 then
      r = r..string.char(b)
    else
      if b > 239 then
        r = r..'\209'..string.char(b - 112)
      elseif b > 191 then
        r = r..'\208'..string.char(b - 48)
      elseif ansi_decode[b] then
        r = r..ansi_decode[b]
      else
        r = r..'_'
      end
    end
  end
  return r
end

function Utf8ToAnsi(s)
  local a, j, r, b = 0, 0, ''
  for i = 1, s and s:len() or 0 do
    b = s:byte(i)
    if b < 128 then
      if nmdc[b] then
        r = r..nmdc[b]
      else
        r = r..string.char(b)
      end
    elseif a == 2 then
      a, j = a - 1, b
    elseif a == 1 then
      a, r = a - 1, r..utf8_decode[j][b]
    elseif b == 226 then
      a = 2
    elseif b == 194 or b == 208 or b == 209 or b == 210 then
      j, a = b, 1
    else
      r = r..'_'
    end
  end
  return r
end


function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    for filename in popen('echo |chcp 1251|dir "'..directory..'" /b'):lines() do
        i = i + 1; t[i] = filename
    end
    return t
end

function get_element (data, tag)
  spaces, dirty = nil, nil; spaces, dirty = data:match('( -)<'..tag..'>\n(.-)</'..tag..'>')
  if spaces then return dirty:sub(#spaces+2,-#spaces-2) end
end

retval, path_ = reaper.GetUserInputs("Au to Rea 0.4", 1, "Path:", "")
if retval == true and path_ and path_ ~= '' then
  path = Utf8ToAnsi(path_)
  os = reaper.GetOS()
  
  files = scandir(path)
  if #files > 0 then
    for i = 1, #files do if files[i]:match('xml$') then f = files[i] break end end
    
    if os == 'Win32' or 'Win64' then filename_esc = path:gsub([[\]], [[\\]])..[[\\]]..f:gsub ([[\]], [[\\]])
    else filename_esc = path..[[\\]]..filename end
    
    xml = io.open(filename_esc, "r")
    if xml then xml_data = xml:read('*a'); xml:close() end
    if xml_data then
    
      reaper.PreventUIRefresh(111)
    
      if reaper.GetToggleCommandState(40041) == 1 then -- toggle auto-crossfade
        autocrsf = 1; reaper.Main_OnCommand(40041, 0) -- toggle auto-crossfade
      end
      if reaper.GetToggleCommandState(41117) == 1 then -- toggle trim behind
        trimcnt = 1; reaper.Main_OnCommand(41117, 0) -- toggle trim behind
      end
    
      items_tb = {}; waves_tb = {}
    
      ses_info = xml_data:match('<SessionHeaderInfo>(.-)</SessionHeaderInfo>')
      samplerate = get_element (ses_info, 'iSampleRate')
    
      for wave_data in xml_data:gmatch('<EntityInfo>(.-)</EntityInfo>') do
        wave_id = get_element (wave_data, 'dwWaveformID')
        item_fn_short = get_element (wave_data, 'wszFilename')
--        waves_tb[wave_id] = item_fn_short
        waves_tb[wave_id] = Utf8ToAnsi(item_fn_short)
      end
    
      for item_data in xml_data:gmatch('<CommonBlockInfo>(.-)</CommonBlockInfo>') do
    
        wave_id       = get_element (item_data, 'dwEntityID')
        offset        = get_element (item_data, 'dwOffset')
        size          = get_element (item_data, 'dwSize')
        indent        = get_element (item_data, 'dwFileIndent')
        track         = get_element (item_data, 'iTrack')
    
        if offset and size and indent and samplerate and track then
        
          offset     = tonumber(offset)
          size       = tonumber(size)
          indent     = tonumber(indent)
          samplerate = tonumber(samplerate)
    
          for k,v in pairs(waves_tb) do if k == wave_id then item_fn_short_ = v break end end
    
          item_fn = path:gsub ([[\]], [[\\]])..[[\\]]..item_fn_short_
    
          if not items_tb[track] then items_tb[track] = {} end
          items_tb[track][#items_tb[track]+1] = {offset, size, indent, item_fn}
        end
      end
      
      for _,v in pairs(items_tb) do
        for i = 1, #v do
          offset, size, indent, item_fn = table.unpack(v[i])
          reaper.Main_OnCommand(40289, 0) -- unselect all items
          reaper.Main_OnCommand(40297, 0) -- unselect all tracks
    
          reaper.InsertMedia(AnsiToUtf8(item_fn), 1)
          
          reaper.ApplyNudge(0, 1, 1, 1, indent/samplerate, 0, 0) -- trim start
          reaper.ApplyNudge(0, 1, 0, 1, offset/samplerate, 0, 0) -- set position
          reaper.ApplyNudge(0, 1, 3, 1, (offset+size)/samplerate, 0, 0) -- trim end
        end
      end
      if autocrsf then reaper.Main_OnCommand(40041, 0) end -- toggle auto-crossfade
      if trimcnt then reaper.Main_OnCommand(41117, 0) end -- toggle trim behind
      
      reaper.TrackList_AdjustWindows(0)
      reaper.PreventUIRefresh(-111)
      
    end
  end
end
