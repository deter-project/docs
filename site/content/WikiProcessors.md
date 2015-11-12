Processors are WikiMacros designed to provide alternative markup formats for the [TracWiki Wiki engine]. Processors can be thought of as _macro functions to process user-edited text_. 

Wiki processors can be used in any Wiki text throughout Trac,
for various different purposes, like:
 - [#CodeHighlightingSupport syntax highlighting] or for rendering text verbatim,
 - rendering [#HTMLrelated Wiki markup inside a context], 
   like inside <div> blocks or <span> or within <td> or <th> table cells,
 - using an alternative markup syntax, like [wiki:WikiHtml raw HTML] and
   [wiki:WikiRestructuredText Restructured Text],
   or [textile](http://www.textism.com/tools/textile/)


# Using Processors

To use a processor on a block of text, first delimit the lines using
a Wiki _code block_:
	
	
	The lines
	that should be processed...
	
}}}

Immediately after the `	` or on the line just below, 
	add `#!` followed by the _processor name_.
	
	
	
	#!processorname
	The lines
	that should be processed...
	
}}}

This is the "shebang" notation, familiar to most UNIX users.

Besides their content, some Wiki processors can also accept _parameters_,
which are then given as `key=value` pairs after the processor name, 
on the same line. If `value` has to contain space, as it's often the case for
the style parameter, a quoted string can be used (`key="value with space"`).

As some processors are meant to process Wiki markup, it's quite possible to
_nest_ processor blocks.
You may want to indent the content of nested blocks for increased clarity,
this extra indentation will be ignored when processing the content.


# Examples

||||||
	#!td colspan=2 align=center style="border: none"
	
	                __Example 1__: Inserting raw HTML
	
|-----------------------------------------------------------------
	#!td style="border: none"
	
	
	<h1 style="color: grey">This is raw HTML</h1>
	
}}}
}}}
	#!td valign=top style="border: none; padding-left: 2em"
	
	#!html
	<h1 style="color: grey">This is raw HTML</h1>
	
}}}
|-----------------------------------------------------------------
	#!td colspan=2 align=center style="border: none"
	
	     __Example 2__: Highlighted Python code in a <div> block with custom style
	
|-----------------------------------------------------------------
	#!td style="border: none"
	  
	  #!div style="background: #ffd; border: 3px ridge"
	
	  This is an example of embedded "code" block:
	
	    
	    #!python
	    def hello():
	        return "world"
	    

  }}}
  }}}
}}}
	#!td valign=top style="border: none; padding: 1em"
	  #!div style="background: #ffd; border: 3px ridge"
	
	  This is an example of embedded "code" block:
	
	    
	    #!python
	    def hello():
	        return "world"
	    

  }}}
}}}
|-----------------------------------------------------------------
	#!td colspan=2 align=center style="border: none"
	
	     __Example 3__: Searching tickets from a wiki page, by keywords.
	
|-----------------------------------------------------------------
	#!td style="border: none"
	  
	  
	  #!html
	  <form action="/query" method="get"><div>
	  <input type="text" name="keywords" value="~" size="30"/>
	  <input type="submit" value="Search by Keywords"/>
	  <!-- To control what fields show up use hidden fields
	  <input type="hidden" name="col" value="id"/>
	  <input type="hidden" name="col" value="summary"/>
	  <input type="hidden" name="col" value="status"/>
	  <input type="hidden" name="col" value="milestone"/>
	  <input type="hidden" name="col" value="version"/>
	  <input type="hidden" name="col" value="owner"/>
	  <input type="hidden" name="col" value="priority"/>
	  <input type="hidden" name="col" value="component"/>
	  -->
	  </div></form>
	  
  }}}
}}}
	#!td valign=top style="border: none; padding: 1em"
	  
	  #!html
	  <form action="/query" method="get"><div>
	  <input type="text" name="keywords" value="~" size="30"/>
	  <input type="submit" value="Search by Keywords"/>
	  <!-- To control what fields show up use hidden fields
	  <input type="hidden" name="col" value="id"/>
	  <input type="hidden" name="col" value="summary"/>
	  <input type="hidden" name="col" value="status"/>
	  <input type="hidden" name="col" value="milestone"/>
	  <input type="hidden" name="col" value="version"/>
	  <input type="hidden" name="col" value="owner"/>
	  <input type="hidden" name="col" value="priority"/>
	  <input type="hidden" name="col" value="component"/>
	  -->
	  </div></form>
	  
}}}
# Available Processors

The following processors are included in the Trac distribution:

 `#!default` :: Present the text verbatim in a preformatted text block. 
                This is the same as specifying _no_ processor name
                (and no `#!`)
 `#!comment` :: Do not process the text in this section (i.e. contents exist
                only in the plain text - not in the rendered page).

## HTML related

 `#!html`        :: Insert custom HTML in a wiki page.
 `#!htmlcomment` :: Insert an HTML comment in a wiki page (_since 0.12_).

Note that `#!html` blocks have to be _self-contained_,
i.e. you can't start an HTML element in one block and close it later in a second block. Use the following processors for achieving a similar effect. 

  `#!div` :: Wrap an arbitrary Wiki content inside a <div> element
             (_since 0.11_).
 `#!span` :: Wrap an arbitrary Wiki content inside a <span> element 
             (_since 0.11_). 

 `#!td` :: Wrap an arbitrary Wiki content inside a <td> element (_since 0.12_)
 `#!th` :: Wrap an arbitrary Wiki content inside a <th> element (_since 0.12_) 
 `#!tr` :: Can optionally be used for wrapping `#!td` and `#!th` blocks,
       either for specifying row attributes of better visual grouping
       (_since 0.12_)

See WikiHtml for example usage and more details about these processors.

## Other Markups

     `#!rst` :: Trac support for Restructured Text. See WikiRestructuredText.
 `#!textile` :: Supported if [Textile](http://cheeseshop.python.org/pypi/textile) 
                is installed. 
                See [a Textile reference](http://www.textism.com/tools/textile/).


## Code Highlighting Support

Trac includes processors to provide inline syntax highlighting:
 `#!c` (C), `#!cpp` (C++), `#!python` (Python), `#!perl` (Perl), 
 `#!ruby` (Ruby), `#!php` (PHP), `#!asp` (ASP), `#!java` (Java), 
 `#!js` (Javascript), `#!sql (SQL)`, `#!xml` (XML or HTML),
 `#!sh` (!Bourne/Bash shell), etc.

Trac relies on external software packages for syntax coloring,
like [Pygments](http://pygments.org). 

See TracSyntaxColoring for information about which languages
are supported and how to enable support for more languages.

Note also that by using the MIME type as processor, it is possible to syntax-highlight the same languages that are supported when browsing source code. For example, you can write:
	
	
	#!text/html
	<h1>text</h1>
	
}}}

The result will be syntax highlighted HTML code:
	
	#!text/html
	<h1>text</h1>
	

The same is valid for all other [TracSyntaxColoring#SyntaxColoringSupport mime types supported].


For more processor macros developed and/or contributed by users, visit: 
* [trac:ProcessorBazaar]
* [trac:MacroBazaar]
* [th:WikiStart Trac Hacks] community site

Developing processors is no different from Wiki macros. 
In fact they work the same way, only the usage syntax differs. 
See WikiMacros#DevelopingCustomMacros for more information.


----
See also: WikiMacros, WikiHtml, WikiRestructuredText, TracSyntaxColoring, WikiFormatting, TracGuide
