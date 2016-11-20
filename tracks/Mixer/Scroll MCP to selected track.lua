r = reaper
tr = r.GetSelectedTrack(0,0)
r.SetOnlyTrackSelected(tr)
r.Main_OnCommand(40914,0) -- set first selected track as last touched
r.SetMixerScroll(tr)
