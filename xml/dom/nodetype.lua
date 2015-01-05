local upperclass = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils = require(LIBXML_REQUIRE_PATH..'lib.utils')

--
-- Define Class
--
local NodeType = upperclass:define("NodeType")

--
-- Constructor
--
function private:__construct(NODE_TYPE)
end

--
-- Compile Class
--
return upperclass:compile(NodeType)