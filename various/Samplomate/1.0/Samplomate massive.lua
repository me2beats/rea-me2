function nothing() end

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

res_path = reaper.GetResourcePath()
my_os = reaper.GetOS()
if my_os == 'Win32' or 'Win64' then x_ok = string.gsub (res_path, [==[\]==], [==[\\]==]) else x_ok = x end

samplomate_file = io.open(x_ok..[[\\Samplomate_data_(me2beats).txt]], "r")

if samplomate_file then
  samplomate_data = samplomate_file:read('*a')
  tb_excl_fn = {}

  reaper.Undo_BeginBlock(); reaper.PreventUIRefresh(111)

  for k = 0, reaper.CountMediaItems(0)-1 do
  
    item = reaper.GetSelectedMediaItem(0,k)
    if item then
      take = reaper.GetActiveTake(item)
      if reaper.TakeIsMIDI(take) ~= true then
        found = nil
        source = reaper.GetMediaItemTake_Source(take)
        filename = reaper.GetMediaSourceFileName(source, "")
        for j = 1, #tb_excl_fn do if filename == tb_excl_fn[j] then found = 1 end end
        if not found then
          tb_excl_fn[#tb_excl_fn+1] = filename
          len = #filename
          filename_64 = enc(filename)
  
          if math.fmod(len, 3) == 0 then
            div = '3n'; filename_64_ok = filename_64
          elseif math.fmod(len+1, 3) == 0 then
            div = '3n+1'; filename_64_ok = filename_64:sub(1,-2)
          elseif math.fmod(len+2, 3) == 0 then
            div = '3n+2' filename_64_ok = filename_64:sub(1,-3)
          end
      
          tracks_all = reaper.CountTracks(0)
          reaper.InsertTrackAtIndex(tracks_all, 0)
          tr = reaper.GetTrack(0, tracks_all)
          _, chunk = reaper.GetTrackStateChunk(tr, '', 0)
          tr_guid = chunk:match('\nTRACKID (.-)\n')
          
          start_str, after_track_id_str, end_str, var_str_1, var_str_2, var_str_3 =
          samplomate_data:match(
          '%[start_str%]=\n(.-)\n%[after_track_id_str%]=\n(.-)\n%[end_str%]=\n(.-)%[var_str_1%]=\n(.-)\n%[var_str_2%]=\n(.-)\n%[var_str_3%]=\n(.*)\n')
          tb = {}
          tb[1] = var_str_1
          tb[2] = var_str_2
          tb[3] = var_str_3
          if div == '3n' then
            for i = 1, 3 do if tb[i]:find('.DAud2F2') then g_spot = tb[i]:match('.DAud2F2(.*)') end end
          elseif div == '3n+2' then
            for i = 1, 3 do if tb[i]:find('.DAwLndhdg') then g_spot = tb[i]:match('.DAwLndhdg(.*)') end end
          elseif div == '3n+1' then
            for i = 1, 3 do if tb[i]:find('.C53YXY') then g_spot = tb[i]:match('.C53YXY(.*)') end end
          end
          
          new_chunk = start_str..tr_guid..after_track_id_str..filename_64_ok..g_spot..end_str
          fx_guid = new_chunk:match('\nFXID ({.-})')
          new_fx_guid = reaper.genGuid(fx_guid)
          new_chunk_ok = new_chunk:gsub(fx_guid, new_fx_guid)
          reaper.SetTrackStateChunk(tr, new_chunk, 0)
          reaper.SetOnlyTrackSelected(tr)
--          wanded_fx = reaper.TrackFX_GetByName(tr, 'reasamplomatic', 0)
--          reaper.TrackFX_Show(tr, wanded_fx, 1) -- 1 for show chain, 3 for show floating window
          reaper.TrackList_AdjustWindows(0)
        end
      end
    end
  end
  
  reaper.PreventUIRefresh(-111)
  reaper.Main_OnCommand(40913, 0) -- vertical scroll sel track into view
  reaper.Undo_EndBlock("Samplomate", -1)

else reaper.MB('Samlomate file could not be found. Please run Samplomate preparing.lua','File Not Found',0) reaper.defer(nothing) end
