-- Obtain our path to our lib
local RP="";for w in (...):gmatch("(.-)%.") do if w=="xml" then RP=RP.."xml"..".";break else RP=RP..w.."." end end

-- Load dependencies
local upperclass    = require(RP..'lib.upperclass')
local Node          = require(RP..'dom.node')
local Element       = require(RP..'dom.element')
--local Attribute     = require('libxml_dom_attribute')
--local Comment       = require('libxml_dom_comment')
--local CDATASection  = require('libxml_dom_cdata')
--local Text          = require('libxml_dom_text')

-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local Document = upperclass:define("Document", Node)

--
-- Node Name
--
property : nodeName { "#document" ; get='public' ; set='private' }

--
-- Document Element
--
property : documentElement { nil ; get='public' ; set='private' }

--
-- Class Constructor
--
function private:__construct()
    self:__constructparent(9)
end

--
-- Create Element
--
function public:createElement(NAME)
end

-- 
-- Create Attribute
--
function public:createAttribute(NAME)
end

--
-- Create Text Node
--
function public:createTextNode(TEXT)
end

--
-- Create CData Section
--
function public:createCDATASection(TEXT)
end

--
-- Create Comment
--
function public:createComment(TEXT)
end

--
-- Compile Class
--
return upperclass:compile(Document, {ALLOW_INSTANCE = true, ALLOW_STATIC = false, STRICT_TYPES = true})