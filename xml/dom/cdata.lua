--
-- Obtain our path to our lib
--
local RP="";for w in (...):gmatch("(.-)%.") do if w=="xml" then RP=RP.."xml"..".";break else RP=RP..w.."." end end

--
-- Load dependencies
--
local upperclass = require(RP..'lib.upperclass')

--
-- Define class
--
local CharacterData = upperclass:define("CharacterData")

--
-- NodeName
--
property : nodeName { 
    "#CDATASECTION"; 
    get='public'; 
    set='private'
}

--
-- NodeValue
--
public.nodeValue = ""

--
-- Class Constructor
--
function private:__construct(DATA)
    self.nodeValue = DATA
end

--
-- Append Data 
--
function public:appendData(DATA)
    self.nodeValue = self.nodeValue + DATA
end

--
-- Compile Class
--
 return upperclass:compile(CharacterData)