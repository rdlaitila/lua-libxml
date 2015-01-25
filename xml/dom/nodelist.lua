local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')

--
-- Define class
--
local NodeList = upperclass:define("NodeList")

--
-- Holds a list of nodes for this NodeList
--
protected.nodes = nil

--
-- Class constructor
--
function private:__construct()
    -- generate a new nodes table
    self.nodes = {}
end

--
-- __index metamethod
--
function private:__index(KEY) 
    if type(KEY) == 'number' then
        return self:item(KEY)
    elseif KEY == 'length' then
        return #self.nodes
    end
    
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

--
-- Returns the node at the specified index in a node list
--
function public:item(INDEX)
    return self.nodes[INDEX] or nil
end

--
-- Adds a node to the node list
--
function public:add(NODE)
    table.insert(self.nodes, NODE)    
end

--
-- Compile Class
--
return upperclass:compile(NodeList)
