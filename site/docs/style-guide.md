Style guide
===========

The following style guide should be followed when writing documentation for this site. When writing documentation for Wolf CMS, we highly appreciate people following this guide as it allows us to more easily incorporate contributed documentation. If the guide is lacking or faulty somehow, please do bring that to our attention.

Thank you.

Document title
--------------

Every document is starts with its own title and it is written as follows:

```
    Document title
    ==============
```

Sub headings
------------

The various levels of sub headings should be written as:

```
    Level two heading
    -----------------

    ### Level three heading

    #### Level four heading

    ##### Level five heading

    ###### Level six heading
```

Notes
-----

Various types of notes can and should be used throughout the documentation to inform people of special cases, danger areas, give tips, etc. However, notes should not be used overly much. The various note types are:

!!! note
    The informational note, written as:

        !!! note
            Some extra piece of information.

!!! tip
    A note that gives a tip, written as:

        !!! tip
            A handy tip!

!!! warning
    A note that gives a warning, written as:

        !!! warning
            Please make sure you backup your system before...

!!! danger
    A note that warns of dangerous actions or settins, written as:

        !!! danger
            If you do this you will likely screw up your system!

Code
----

When applicable, you should enhance your explanations using code examples. Settings, file names and code in general should either be written as short, inline entries using single backticks ( ` ) surrounding the code or as so called code blocks:

```
    ```
        This is a code block.
    ```
```

Inline markup
-------------

* one asterisk: `*text*` for *emphasis*;
* two asterisks: `**text**` for **strong emphasis**;

Lists
-----

List markup is natural: just place an asterisk at the start of a paragraph and indent properly. The same goes for numbered lists.

```
* This is a bulleted list.
* It has two items, the second

  item uses several lines which are all indented.

1. This is a numbered list.
2. It has two items too.
```

Nested lists can be achieved by simply indenting them.

!!! note
    When adding code blocks or similar structures to a list, make sure they are all indented, including any empty lines.

Hyperlinks
----------

When additional information is needed or when referencing other parts of the documentation, a link is required. You can link in several different ways depending on the requirements of the situation:

* Basic raw links
    `<http://www.example.com/>`
* Link using descriptive text
    `[Link text](http://www.example.com/)`
* Link to other pages within the documentation
    `[Link text](path/to/doc.md)`
* Link to an anchor within a page
    `[Link text](yourpage.md#anchorname)`
* Link to an same-page anchor
    `[Link text](#anchorname)`

Please note that all headings are automatically anchors.

!!! warning
    Due to a bug in the current MkDocs implementation, same-page anchor links should be written as `[Link text](samepage.md#anchor)` instead of the correct `[Link text](#anchor)`.

Images
------

Images can be inserted either using markdown syntax or as basic HTML code when alignment or special styling is required. Whenever possible, stick to the markdown syntax.

```
    ![Alternate text](images/example-image.png)
    ![Alternate text](images/example-image.png "Optional title")
    <p align="center"><img src="docs/images/example-image.png" alt="Alternate text"></p>
```

Before you do this, you need to prepare image (crop, resize, mark...) and put it in the `docs/images` folder.
