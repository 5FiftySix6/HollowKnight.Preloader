stringlist_add(getAutoAttachList(), "hollow_knight.exe");
 
form_show(UDF1)
 
function pensiveloafClick(sender)
     doLoad()
end
 
function invoke(domain, method, instance, args)
  local c = mono_method_getClass(method)
 
  local params = mono_method_get_parameters(method)
 
  if #args ~= #params.parameters then
    print('ERROR:my_mono_invoke_method : wrong length of args')
    return
  end
 
  local args_t = {}
  for i=1, #params.parameters do
    args_t[i] = {}
    args_t[i].type = monoTypeToVartypeLookup[params.parameters[i].type]
    args_t[i].value = args[i]
  end
 
  if method == nil or method == 0 then
    print('ERROR: invoke : method is nil')
    return
  end
 
  if instance == nil or instance == 0 then
    print('ERROR: invoke : instance is nil')
    return
  end
 
  return mono_invoke_method('', method, instance, args_t)
end
 
 
function doLoad()
    LaunchMonoDataCollector()
    monopipe.unlock()
 
    if monoSettings ~= nil then
       monoSettings.Value["ShowMethodParameters"] = false
    end
 
    local mid = nil
 
    local class = mono_findClass('UnityEngine.SceneManagement', 'SceneManager')
 
    local methods = mono_class_enumMethods(class, false)
    for i=1, #methods do
      if methods[i].name == "LoadScene" then
         mid = methods[i].method
         break
      end
    end
 
    print("MID is " .. mid)
 
    local addr = getAddress("hollow_knight.exe")
    addr = readPointer(addr + 0x00FAE894)
    addr = readPointer(addr + 0x118)
    addr = readPointer(addr + 0x15C)
    addr = readPointer(addr + 0x48)
    addr = addr - 0x500
 
    print(string.format("Addr %x", addr))
    scenes = {1, 2, 3, 4, 5, 6, 7, 8, 9, 19, 37, 38, 39, 40, 42, 43, 44, 46, 47, 48, 50, 52, 53, 54, 55, 61, 62, 66, 73, 74, 78, 79, 89, 91, 92, 93, 94, 95, 99, 100, 102, 104, 105, 106, 107, 108, 112, 113, 115, 116, 117, 118, 119, 120, 133, 136, 145, 146, 158, 159, 160, 161, 162, 163, 165, 166, 168, 172, 173, 184, 185, 186, 188, 189, 191, 198, 199, 204, 211, 215, 216, 222, 223, 224, 225, 226, 266, 267, 281, 283, 284, 285, 288, 309, 310, 311, 314, 316, 319, 320, 322, 323, 329, 365, 370, 371, 372, 373, 376, 378, 379}
    for i=1, #scenes do
        invoke('', mid, addr, {scenes[i]})
    end
    print("Done")
end
