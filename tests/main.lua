DOMDocument = require('xml.dom.document')

for key, value in pairs(package.loaded) do
    print(key, value)
end

os.exit(1)
-- Check if we are testing love2d or standard lua
if love ~= nil then
    function love.load()
       xmldoc = libxml.load("player.xml")
       name = xmldoc.documentElement.childNodes[1].getAttribute("name")       
       print(name)
    end
else
    xmldoc = libxml:load("tests//player.xml")
    print(xmldoc.documentElement.childNodes[1]:getAttribute("name"))
end