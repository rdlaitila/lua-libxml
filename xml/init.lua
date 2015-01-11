--
-- Obtain our require path. This should the the folder of the loader.lua file
--
LIBXML_REQUIRE_PATH = (...):match("(.-)[^%.]+$")

return {
    -- Our version: Major.Minor.Patch
    version = "0.1.0";
    
    -- Our DOM Objects
    dom = {
        Document    = require(LIBXML_REQUIRE_PATH..'dom.document'),
        NodeType    = require(LIBXML_REQUIRE_PATH..'dom.nodetype'),
        Node        = require(LIBXML_REQUIRE_PATH..'dom.node')
        --NodeList       = require(REQUIRE_PATH..'dom.nodelist')
        --NamedNodeMap   = require(REQUIRE_PATH..'dom.namednodemap')
    };
    
    -- Our Library Objects
    lib = {
        upperclass  = require(LIBXML_REQUIRE_PATH..'lib.upperclass'),
        utils       = require(LIBXML_REQUIRE_PATH..'lib.utils')
    };
}
