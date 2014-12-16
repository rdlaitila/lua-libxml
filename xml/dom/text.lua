--
-- Obtain our path to our lib
--
local RP="";for w in (...):gmatch("(.-)%.") do if w=="xml" then RP=RP.."xml"..".";break else RP=RP..w.."." end end

--
-- Load dependencies
--
local upperclass    = require(RP..'lib.upperclass')
local CharacterData = require(RP..'dom.cdata')

--
-- Define class
--
local Text = upperclass:define("Text", CharacterData)

--
-- Holds the nodeName
--
property : nodeName { "#text" ; get='public' ; set='private' }

--
-- NodeType
--
property : nodeType { 3 ; get='public' ; set='private' }

--
-- NodeDescription
--
property : nodeDescription { "" ; get='public' ; set='private' }

-- 
-- Compile Class
--
return upperclass:compile(Text, {ALLOW_STATIC = false, ALLOW_INSTANCE = true, STRICT_TYPES = true})