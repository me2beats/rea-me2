font_size = 20
font_name = "Arial"
window_w = 150
window_h = 40
marge = 20
marge2 = 100
line_height = 10

function init(window_w, window_h)
  gfx.init("" , window_w, window_h)
  gfx.setfont(1, font_name, font_size, 'b')
  gfx.a = 1
  gfx.r = 1
  gfx.g = 1
  gfx.b = 1
end

function run()
  
  
  tr = reaper.GetSelectedTrack(0,0)
  if tr ~= nil then
    cnt_tr_env = reaper.CountTrackEnvelopes(tr)
    if cnt_tr_env > 0 then
      hide_env_cnt = 0
      for e = 0, cnt_tr_env-1 do
        tr_env = reaper.GetTrackEnvelope(tr, e)
        _, env_chunk = reaper.GetEnvelopeStateChunk(tr_env, '', 0)
        hide = string.find (env_chunk, 'VIS 0')
        if hide ~= nil then
          hide_env_cnt = hide_env_cnt+1
        end
      end
    end
  end
  if cnt_tr_env == 0 or tr == nil then
     hide_env_cnt = 0
  end
          
      line = 0 
      
      gfx.x = marge
      
      gfx_a = 1
      gfx.r = 255/255
      gfx.g = 255/255
      gfx.b = 16/255
    
    line = line + 1
      gfx.x = marge
      gfx.y = line * line_height
      gfx.printf("Hidden env: ")
        
     
      line = 0
      gfx.r = 255/255
      gfx.g = 255/255
      gfx.b = 255/255
      
      line = line + 1
      gfx.x = marge + marge2
      gfx.y = line * line_height
      gfx.printf(hide_env_cnt)
    
          
  gfx.update()
  if gfx.getchar() >= 0 then reaper.defer(run) end

end

init(window_w, window_h)
run()
