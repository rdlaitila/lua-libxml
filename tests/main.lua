libxml = require('libxml.libxml')

-- Check if we are testing love2d or standard lua
if love ~= nil then
    function love.load()
       xmldoc = libxml.load("player.xml")
       name = xmldoc.documentElement.childNodes[1].getAttribute("name")       
       print(name)
    end
else
    xmldoc = libxml.load("tests//player.xml")
    print(xmldoc.documentElement.childNodes[1].getAttribute("name"))
end