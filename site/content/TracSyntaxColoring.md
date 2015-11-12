Trac supports language-specific syntax highlighting of source code within wiki formatted text in [WikiProcessors#CodeHighlightingSupport wiki processors] blocks and in the [TracBrowser repository browser].

To do this, Trac uses external libraries with support for a great number of programming languages.

Currently Trac supports syntax coloring using one or more of the following packages:

* [Pygments](http://pygments.pocoo.org/), by far the preferred system, as it covers a wide range of programming languages and other structured texts and is actively supported
* [GNU Enscript](http://www.codento.com/people/mtr/genscript/), commonly available on Unix but somewhat unsupported on Windows
* [SilverCity](http://silvercity.sourceforge.net/), legacy system, some versions can be [problematic](http://trac.edgewall.org/wiki/TracFaq#why-is-my-css-code-not-being-highlighted-even-though-i-have-silvercity-installed)


To activate syntax coloring, simply install either one (or more) of these packages (see [#ExtraSoftware] section below).
If none of these packages is available, Trac will display the data as plain text. 


## About Pygments

Starting with trac 0.11 [pygments](http://pygments.org/) will be the new default highlighter. It's a highlighting library implemented in pure python, very fast, easy to extend and [well documented](http://pygments.org/docs/).

The Pygments default style can specified in the [TracIni#mimeviewer-section mime-viewer] section of trac.ini. The default style can be overridden by setting a Style preference on the [/prefs/pygments preferences page]. 

It's very likely that the list below is outdated because the list of supported pygments lexers is growing weekly. Just have a look at the page of [supported lexers](http://pygments.org/docs/lexers/) on the pygments webpage.


# Syntax Coloring Support

=== Known MIME Types

[[KnownMimeTypes]]


=== List of Languages Supported, by Highlighter #language-supported

This list is only indicative.

||                 ||||||||
|| Ada             ||                 ||  ✓              ||     ||
|| Asm             ||                 ||  ✓              ||     ||
|| Apache Conf     ||                 ||                 ||  ✓  ||
|| ASP             ||  ✓              ||  ✓              ||     ||
|| C               ||  ✓              ||  ✓              ||  ✓  ||
|| C#              ||                 ||  ✓ ^[#a1 (1)]^  ||  ✓  ||
|| C++             ||  ✓              ||  ✓              ||  ✓  ||
|| Java            ||  ✓ ^[#a2 (2)]^  ||  ✓              ||  ✓  ||
|| Awk             ||                 ||  ✓              ||     ||
|| Boo             ||                 ||                 ||  ✓  ||
|| CSS             ||  ✓              ||                 ||  ✓  ||
|| Python Doctests ||                 ||                 ||  ✓  ||
|| Diff            ||                 ||  ✓              ||  ✓  ||
|| Eiffel          ||                 ||  ✓              ||     ||
|| Elisp           ||                 ||  ✓              ||     ||
|| Fortran         ||                 ||  ✓ ^[#a1 (1)]^  ||  ✓  ||
|| Haskell         ||                 ||  ✓              ||  ✓  ||
|| Genshi          ||                 ||                 ||  ✓  ||
|| HTML            ||  ✓              ||  ✓              ||  ✓  ||
|| IDL             ||                 ||  ✓              ||     ||
|| INI             ||                 ||                 ||  ✓  ||
|| Javascript      ||  ✓              ||  ✓              ||  ✓  ||
|| Lua             ||                 ||                 ||  ✓  ||
|| m4              ||                 ||  ✓              ||     ||
|| Makefile        ||                 ||  ✓              ||  ✓  ||
|| Mako            ||                 ||                 ||  ✓  ||
|| Matlab ^[#a3 (3)]^  ||             ||  ✓              ||  ✓  ||
|| Mygthy          ||                 ||                 ||  ✓  ||
|| Objective-C     ||                 ||  ✓              ||  ✓  ||
|| OCaml           ||                 ||                 ||  ✓  ||
|| Pascal          ||                 ||  ✓              ||  ✓  ||
|| Perl            ||  ✓              ||  ✓              ||  ✓  ||
|| PHP             ||  ✓              ||                 ||  ✓  ||
|| PSP             ||  ✓              ||                 ||     ||
|| Pyrex           ||                 ||  ✓              ||     ||
|| Python          ||  ✓              ||  ✓              ||  ✓  ||
|| Ruby            ||  ✓              ||  ✓ ^[#a1 (1)]^  ||  ✓  ||
|| Scheme          ||                 ||  ✓              ||  ✓  ||
|| Shell           ||                 ||  ✓              ||  ✓  ||
|| Smarty          ||                 ||                 ||  ✓  ||
|| SQL             ||  ✓              ||  ✓              ||  ✓  ||
|| Troff           ||                 ||  ✓              ||  ✓  ||
|| TCL             ||                 ||  ✓              ||     ||
|| Tex             ||                 ||  ✓              ||  ✓  ||
|| Verilog         ||  ✓ ^[#a2 (2)]^  ||  ✓              ||     ||
|| VHDL            ||                 ||  ✓              ||     ||
|| Visual Basic    ||                 ||  ✓              ||  ✓  ||
|| VRML            ||                 ||  ✓              ||     ||
|| XML             ||  ✓              ||                 ||  ✓  ||



''[=#a1 (1)] Not included in the Enscript distribution.  Additional highlighting rules can be obtained for
[Ruby](http://neugierig.org/software/ruby/),
[C#](http://wiki.hasno.info/index.php/Csharp.st),
[Fortran 90x/2003](http://wiki.hasno.info/index.php/F90.st)

''[=#a2 (2)] since Silvercity 0.9.7 released on 2006-11-23

''[=#a3 (3)] By default `.m` files are considered Objective-C files. In order to treat `.m` files as MATLAB files, add "text/matlab:m" to the "mime_map" setting in the [wiki:TracIni#mimeviewer-section "[mimeviewer] section of trac.ini"].

# Extra Software
* GNU Enscript -- http://directory.fsf.org/GNU/enscript.html
* GNU Enscript for Windows -- http://gnuwin32.sourceforge.net/packages/enscript.htm
* SilverCity -- http://silvercity.sf.net/
* Pygments -- http://pygments.org/

----
See also: WikiProcessors, WikiFormatting, TracWiki, TracBrowser
