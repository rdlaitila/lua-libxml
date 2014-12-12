-- Obtain our path to our lib
local RP="";for w in (...):gmatch("(.-)%.") do if w=="xml" then RP=RP.."xml"..".";break else RP=RP..w.."." end end

-- Load dependencies
local upperclass    = require(RP..'lib.upperclass')
local Node          = require(RP..'dom.node')

-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

local Element = upperclass:define("Element", Node)

--
-- Node Name
--
property : nodeName { nil ; get='public' ; set='private' }

--
-- Tag Name
--
property : tagName { nil ; get='public' ; set='private' }

--
-- Is Self Closing
--
public.isSelfClosing = false

--
-- Class Constructor
--
function private:__construct(TAG_NAME)
    self:__constructparent(1)
    self.nodeName = TAG_NAME:upper()
    self.tagName = utils:trim(TAG_NAME)    
end

--
-- Compile Class
--
return upperclass:compile(Element, {ALLOW_INSTANCE = true, ALLOW_STATIC = false, STRICT_TYPES = true})