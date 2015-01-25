libxml = require('xml.init')

local elements = {}
for a=1, 100000 do
    table.insert(elements, libxml.dom.Element("div"))
end