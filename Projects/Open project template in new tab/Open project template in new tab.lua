local r = reaper

res_path = r.GetResourcePath()

t_path = res_path..[[\ProjectTemplates]]

local function read_only (file)
  local file_open = io.open(file, 'r'); data = file_open:read('*a'); file_open:close(); return data
end

local function write (file, str)
  local file_open = io.open(file, 'w'); file_open:write(str); file_open:close()
end

for i = 0,1000 do
  fn = r.EnumerateFiles(t_path, i)
  if not fn or fn == '' then break end
  if fn == 'Buffer.RPP' then found = 1 break end
end

if not found then
  x = r.MB('Buffer.RPP is not found. Create?','',1)
  if x == 1 then
    retval, templ_fn = r.GetUserFileNameForRead('', 'Select your favourite template', 'RPP')
    if retval == false then return end
    
    templ_fn_data = read_only(templ_fn)
    
    write(t_path..[[\Buffer.RPP]],templ_fn_data)
    if not r.file_exists(t_path..[[\Buffer.RPP]]) then
      r.MB('Writing error','Oops',0) return
    end
    
    r.MB('Buffer.RPP created! Now please set Buffer.RPP as default project template and restart script','',0)
    
    r.ViewPrefs(0, '')
  return end
end

local ini = r.get_ini_file()
local data = read_only (ini)
if not data then r.MB("Can't get ini file data",'',0) return end

for new_proj_t in data:gmatch'\nnewprojtmpl=(.-)\n' do
  if new_proj_t:match'Buffer%.RPP' then
    found1 = 1
  break end
end

if not found1 then 
  r.MB("Please set Buffer.RPP as default project template and restart script",'',0)
  r.ViewPrefs(0, '')
return end

retval, open_fn = r.GetUserFileNameForRead('', 'Select template', 'RPP')
if retval == false then return end

templ_fn_data = read_only(t_path..[[\Buffer.RPP]])

open_fn_data = read_only(open_fn)
write(t_path..[[\Buffer.RPP]],open_fn_data)

r.Main_OnCommand(40859,0)

write(t_path..[[\Buffer.RPP]],templ_fn_data)
