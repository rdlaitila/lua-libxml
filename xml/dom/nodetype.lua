--
-- Obtain our path to our lib
--
local RP="";for w in (...):gmatch("(.-)%.") do if w=="xml" then RP=RP.."xml"..".";break else RP=RP..w.."." end end

--
-- Load dependencies
--
local upperclass    = require(RP..'lib.upperclass')

--
-- Define Class
--
local NodeType = upperclass:define("NodeType")

