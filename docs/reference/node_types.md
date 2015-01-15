# Node Types

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