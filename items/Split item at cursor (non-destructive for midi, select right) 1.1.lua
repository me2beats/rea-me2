local r = reaper; local function nothing() end; local function bla() r.defer(nothing) end

local it = r.GetSelectedMediaItem(0, 0)
if not it then bla() return end

r.Undo_BeginBlock()
r.PreventUIRefresh(1)

local take = r.GetActiveTake(it)
if r.TakeIsMIDI(take) == true then
  local cur = r.GetCursorPosition()
  local it_len = r.GetMediaItemInfo_Value(it, 'D_LENGTH')
  local it_pos = r.GetMediaItemInfo_Value(it, 'D_POSITION')
  local it_end = it_len + it_pos
  if cur < it_end and cur > it_pos then
    r.ApplyNudge(0, 1, 3, 1, cur, 0, 0) -- trim right edge of initial item to cursor
    r.ApplyNudge(0, 1, 5, 1, it_pos+1, 0, 0) -- duplicate item and move right to 1 sec
    r.ApplyNudge(0, 0, 0, 1, -1, 0, 0) -- move new item back
    r.ApplyNudge(0, 1, 3, 1, it_end, 0, 0) -- trim right edge of new item to it_end
    r.ApplyNudge(0, 1, 1, 1, cur, 0, 0) -- trim left edge of new item to cursor
    r.UpdateArrange()
  end
else
  r.Main_OnCommand(40759, 0) -- split items at edit cursor (select right)
end
r.PreventUIRefresh(-1)
r.Undo_EndBlock('Split sel items at cursor (non-destructive for midi) 1.1', -1)
