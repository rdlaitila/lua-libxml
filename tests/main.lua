local loadlibstarttime = os.clock()
libxml = require('xml.init')
local loadlibendtime = os.clock()

print("Total libxml require time: ", loadlibendtime - loadlibstarttime)

local elements = {}
for a=1, 10000 do
    table.insert(elements, libxml.dom.Element("div"))
end