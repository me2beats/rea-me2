local r = reaper

tr = r.GetSelectedTrack(0, 0)
if not tr then return end

tr_vol = r.GetMediaTrackInfo_Value(tr, 'D_VOL')

r.DeleteExtState('me2beats_copy-paste', 'tr_vol', 0)
r.SetExtState('me2beats_copy-paste', 'tr_vol', tr_vol, 0)