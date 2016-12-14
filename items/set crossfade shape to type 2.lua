local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

r.Undo_BeginBlock()

local items = r.CountSelectedMediaItems()
if items ~= 2 then bla() return end

local item1 = r.GetSelectedMediaItem(0,0)
local item2 = r.GetSelectedMediaItem(0,1)
r.SetMediaItemInfo_Value(item1, 'C_FADEOUTSHAPE', 0)
r.SetMediaItemInfo_Value(item2, 'C_FADEINSHAPE', 0)

r.UpdateItemInProject(item1)
r.UpdateItemInProject(item2)

r.Undo_EndBlock('set crossfade shape to type 2', -1)
