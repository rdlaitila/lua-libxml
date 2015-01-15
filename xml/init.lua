--
-- Obtain our require path. This should the the folder of the loader.lua file
--
LIBXML_REQUIRE_PATH = (...):match("(.-)[^%.]+$")

return {
    -- Our version: Major.Minor.Patch
    version = "0.1.0";
    
    -- Our DOM Objects
    dom = {
        Attribute               = require(LIBXML_REQUIRE_PATH..'dom.attribute'),
        CDATA                   = require(LIBXML_REQUIRE_PATH..'dom.cdata'),
        Comment                 = require(LIBXML_REQUIRE_PATH..'dom.comment'),
        Document                = require(LIBXML_REQUIRE_PATH..'dom.document'),
        DocumentImplimentation  = require(LIBXML_REQUIRE_PATH..'dom.documentimplimentation'),
        DocumentType            = require(LIBXML_REQUIRE_PATH..'dom.documenttype'),
        DOMParser               = require(LIBXML_REQUIRE_PATH..'dom.domparser'),
        Element                 = require(LIBXML_REQUIRE_PATH..'dom.element'),
        NamedNodeMap            = require(LIBXML_REQUIRE_PATH..'dom.namednodemap'),
        Node                    = require(LIBXML_REQUIRE_PATH..'dom.node'),
        NodeList                = require(LIBXML_REQUIRE_PATH..'dom.nodelist'),
        ProcessingInstruction   = require(LIBXML_REQUIRE_PATH..'dom.processinginstruction'),
        Text                    = require(LIBXML_REQUIRE_PATH..'dom.text'),
    };
    
    -- Our Library Objects
    lib = {
        upperclass  = require(LIBXML_REQUIRE_PATH..'lib.upperclass'),
        utils       = require(LIBXML_REQUIRE_PATH..'lib.utils')
    };
}
