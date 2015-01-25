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
    
    -- Our DTD Objects
    dtd = {
        DTDParser  = require(LIBXML_REQUIRE_PATH..'dtd.dtdparser'),
        schemas    = {
            {name = "-//W3C//DTD HTML 4.01//EN",                text = require(LIBXML_REQUIRE_PATH..'dtd.schemas.html_401_strict')},
            {name = "-//W3C//DTD HTML 4.01 Transitional//EN",   text = require(LIBXML_REQUIRE_PATH..'dtd.schemas.html_401_transitional')},
            {name = "-//W3C//DTD HTML 4.01 Frameset//EN",       text = require(LIBXML_REQUIRE_PATH..'dtd.schemas.html_401_frameset')},
            {name = "-//W3C//DTD XHTML 1.0 Strict//EN",         text = require(LIBXML_REQUIRE_PATH..'dtd.schemas.xhtml_10_strict')},
            {name = "-//W3C//DTD XHTML 1.0 Transitional//EN",   text = require(LIBXML_REQUIRE_PATH..'dtd.schemas.xhtml_10_transitional')},
            {name = "-//W3C//DTD XHTML 1.0 Frameset//EN",       text = require(LIBXML_REQUIRE_PATH..'dtd.schemas.xhtml_10_frameset')},
            {name = "-//W3C//DTD XHTML 1.1//EN",                text = require(LIBXML_REQUIRE_PATH..'dtd.schemas.xhtml_11')},                        
            {name = "-//W3C//DTD MathML 2.0//EN",               text = require(LIBXML_REQUIRE_PATH..'dtd.schemas.mathml_20')},            
        }
    };
    
    -- Our Library Objects
    lib = {
        upperclass  = require(LIBXML_REQUIRE_PATH..'lib.upperclass'),
        utils       = require(LIBXML_REQUIRE_PATH..'lib.utils')
    };
}