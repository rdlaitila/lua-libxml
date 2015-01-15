libxml = require('xml.init')


local domParser = libxml.dom.DOMParser()
local document = domParser:parseFromString([[
    <!-- some comment -->
    <node attr="whatever">
        <childnode></childnode>
    </node>
]])

print(document.documentElement:getAttributeNode("attr").value)
