# Node Types

```lua
local libxml = require('libxml.init')

local document = libxml.dom.Document()

local node = libxml.dom.Node()

local element = libxml.dom.Element("mytag")

print(document.nodeName, node.nodeName, element.nodeName)
print(document.nodeType, node.nodeType, element.nodeType)
```

The following table lists the different W3C node types, and which node types they may have as children:

<table class="reference notranslate">
    <tr>
        <th style="width:30%">Node Type</th>
        <th style="width:40%">Description</th>
        <th>Children</th>
    </tr>
    <tr>
        <td>Document</td>
        <td>Represents the entire document (the root-node of the DOM tree)</td>
        <td>Element (max. one), ProcessingInstruction, Comment, DocumentType</td>
    </tr>
    <tr>
        <td>DocumentFragment</td>
        <td>Represents a &quot;lightweight&quot; Document object, which 
        can hold a portion of a document</td>
        <td>Element, ProcessingInstruction, Comment, Text, CDATASection, 
        EntityReference</td>
    </tr>
    <tr>
        <td>DocumentType</td>
        <td>Provides an interface to the entities defined for the 
        document</td>
        <td>None</td>
    </tr>
    <tr>
        <td>ProcessingInstruction</td>
        <td>Represents a processing instruction</td>
        <td>None</td>
    </tr>
    <tr>
        <td>EntityReference</td>
        <td>Represents an entity reference</td>
        <td>Element, ProcessingInstruction, Comment, Text, CDATASection, 
        EntityReference</td>
    </tr>
    <tr>
        <td>Element</td>
        <td>Represents an element</td>
        <td>Element, Text, Comment, ProcessingInstruction, CDATASection, 
        EntityReference</td>
    </tr>
    <tr>
        <td>Attr</td>
        <td>Represents an attribute</td>
        <td>Text, EntityReference</td>
    </tr>
    <tr>
        <td>Text</td>
        <td>Represents textual content in an element 
        or attribute</td>
        <td>None</td>
    </tr>
    <tr>
        <td>CDATASection</td>
        <td>Represents a CDATA section in a document (text that will 
        NOT be parsed by a parser)</td>
        <td>None</td>
    </tr>
    <tr>
        <td>Comment</td>
        <td>Represents a comment</td>
        <td>None</td>
    </tr>
    <tr>
        <td>Entity</td>
        <td>Represents an entity</td>
        <td>Element, ProcessingInstruction, Comment, Text, CDATASection, 
        EntityReference</td>
    </tr>
    <tr>
        <td>Notation</td>
        <td>Represents a notation declared in the DTD</td>
        <td>None</td>
    </tr>
</table>

# Node Types - Return Values

The following table lists what the nodeName and the nodeValue properties will return for each node type:

<table class="reference notranslate">
    <tr>
        <th style="width:30%">Node Type</th>
        <th style="width:40%">nodeName returns</th>
        <th>nodeValue returns</th>
    </tr>
    <tr>
        <td>Document</td>
        <td>#document</td>
        <td>null</td>
    </tr>
    <tr>
        <td>DocumentFragment</td>
        <td>#document fragment</td>
        <td>null</td>
    </tr>
    <tr>
        <td>DocumentType</td>
        <td>doctype name</td>
        <td>null</td>
    </tr>
    <tr>
        <td>EntityReference</td>
        <td>entity reference name</td>
        <td>null</td>
    </tr>
    <tr>
        <td>Element</td>
        <td>element name</td>
        <td>null</td>
    </tr>
    <tr>
        <td>Attr</td>
        <td>attribute name</td>
        <td>attribute value</td>
    </tr>
    <tr>
        <td>ProcessingInstruction</td>
        <td>target</td>
        <td>content of node</td>
    </tr>
    <tr>
        <td>Comment</td>
        <td>#comment</td>
        <td>comment text</td>
    </tr>
    <tr>
        <td>Text</td>
        <td>#text</td>
        <td>content of node</td>
    </tr>
    <tr>
        <td>CDATASection</td>
        <td>#cdata-section</td>
        <td>content of node</td>
    </tr>
    <tr>
        <td>Entity</td>
        <td>entity name</td>
        <td>null</td>
    </tr>
    <tr>
        <td>Notation</td>
        <td>notation name</td>
        <td>null</td>
    </tr>
</table>

# NodeTypes - Named Constants

<table class="reference notranslate">
    <tr>
        <th style="width:15%">NodeType</th>
        <th>Named Constant</th>
    </tr>
    <tr>
        <td>1</td>
        <td>ELEMENT_NODE</td>
    </tr>
    <tr>
        <td>2</td>
        <td>ATTRIBUTE_NODE</td>
    </tr>
    <tr>
        <td>3</td>
        <td>TEXT_NODE</td>
    </tr>
    <tr>
        <td>4</td>
        <td>CDATA_SECTION_NODE</td>
    </tr>
    <tr>
        <td>5</td>
        <td>ENTITY_REFERENCE_NODE</td>
    </tr>
    <tr>
        <td>6</td>
        <td>ENTITY_NODE</td>
    </tr>
    <tr>
        <td>7</td>
        <td>PROCESSING_INSTRUCTION_NODE</td>
    </tr>
    <tr>
        <td>8</td>
        <td>COMMENT_NODE</td>
    </tr>
    <tr>
        <td>9</td>
        <td>DOCUMENT_NODE</td>
    </tr>
    <tr>
        <td>10</td>
        <td>DOCUMENT_TYPE_NODE</td>
    </tr>
    <tr>
        <td>11</td>
        <td>DOCUMENT_FRAGMENT_NODE</td>
    </tr>
    <tr>
        <td>12</td>
        <td>NOTATION_NODE</td>
    </tr>
</table>