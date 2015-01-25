local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMNode       = require(LIBXML_REQUIRE_PATH..'dom.node')

--
-- Define class
--
local Characterdata = upperclass:define("DOMCDATA", DOMNode)

--
-- Sets or returns the text of this node
--
property : data {
    nil;
    get='public';
    set='public';
    type='string';
}

-- 
-- Class constructor
--
function private:__construct(DATA)
    self:__constructparent(4)
    self.nodeName = "#cdata-section"
    self.data = DATA        
end

--
-- __index metamethod
--
function private:__index(KEY)
    if KEY == 'length' then
        return self.data:len()
    elseif KEY == 'nodeValue' then
        return self.data
    end
    
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

--
-- Appends data to the node
--
function public:appendData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Deletes data from the node
--
function public:deleteData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Inserts data into the node
--
function public:insertData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Replaces data in the node
--
function public:replaceData()
    error("Method Not Yet Implimented")
end

--
-- Splits the CDATA node into two nodes
--
function public:splitText()
    error("Method Not Yet Implimented")
end

--
-- Extracts data from the node
--
function public:substringData()
    error("Method Not Yet Implimented")
end

--
-- Compile class
--
return upperclass:compile(Characterdata)