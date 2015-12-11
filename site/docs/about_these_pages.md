## Note about porting
This information should be adjusted for the ported docs and turned into a readme file (ie, not publicly viewable)

## Software Used
These pages are created with [mkdocs](http://www.mkdocs.org/) version 0.14.0, a static documentation site generator. 

## Site Location and Directory Layout
This site is kept in the **deter-project** repository, under the directory `docs`. The pages are generated from markdown files in `site/docs/`.

## Updating a Page

To update a page, edit the file in docs/. Run the command `mkdocs serve` in the `site/` directory. This will start a local web browser which you can use to preview your changes. If you are making multiple changes, it is convenient to keep this preview server running, because it will automatically pick up, render, and display changes as you make them.

Once you are happy with your changes, commit them and then push them to the live server (see [below](#pushing-changes-to-the-live-server)).

## Creating a New Page

To create a new page, create a file in docs/ and then add a corresponding line in the `pages` section of `sysadmin.deterlab.net/mkdocs.yml`. This configuration file is of the format:

```yaml
site_name: DETERLab Docs
site_description: User documentation for the DETERLab testbed
theme: readthedocs
theme_dir: 'readthedocs_custom'
site_favicon: favicon.ico

pages:
- Welcome to the DETERLab Documentation: index.md
#- About These Pages: about_these_pages.md
#- Style Guide: style-guide.md
- Glossary: glossary.md
- DETERLab Core:
    - Core Quickstart: core/core-quickstart.md
```

In the `pages` section, the left half of the line is the page's human-readable name, while the right half is the name of the file in docs/. You can change the order of the page listing in the sidebar by changing the order of the items in the .yml file.

Once you are happy with your changes, add your new file and the mkdocs.yml to the git repository, commit them, and then push the changes to the live server (see [below](#pushing-changes-to-the-live-server)).

## Renaming a Page

This would simply be a matter of renaming the file in docs/, and making corresponding changes in mkdocs.yml, as well as in any other files in docs/ which reference the original name. Note that if you rename a page, you may want to run `mkdocs build --clean` instead of `mkdocs build` when you [regenerate the site](#pushing-changes-to-the-live-server).

## Customizing Docs

If you are customizing these docs for your own organization, here are some general guidelines for making them your own. Changing the logo and colors requires a small amount of HTML and CSS knowledge:

* In general, you can do a find/replace in the `site/docs` directory replacing 'DETERLab' with your own organization name.
* The `base.html` file in the `readthedocs_custom' directory includes customizations to the layout and is where the doc-logo.png is included. Replace the png with your own using a PNG file around 24px by 24px. 
* Colors are controlled in the docs/css/extra.css file.

## Pushing Changes to the Live Server

This site is hosted on [tardis.deterlab.net](virtual_machines.md#tardisdeterlabnet), in the directory /var/www-sysadmin/.

Authentication is provided by apache Basic Auth, configured in `/etc/apache2/sites-enabled/sysadmin.deterlab.net`, with an htpasswd file at `/var/www-sysadmin/.htpasswd`. You can add user accounts to this, or change their password, by running `htpasswd /var/www-sysadmin/.htpasswd USERNAME` (where you replace USERNAME with the username you want) with root privileges on tardis.

Once you are satisfied with your changes and have committed them, build a new static HTML version of the site by running `mkdocs build` in the `sysadmin.deterlab.net` directory. You may see some python errors about unicode literals. These can safely be ignored.

The `mkdocs build` command populates the directory `sysadmin.deterlab.net/site/` with a new version of the site. Now all you have to do is copy the files over to tardis:

```
~/operations/sysadmin.deterlab.net$ scp -r site/* tardis.deterlab.net:/var/www-sysadmin/
jross@tardis.deterlab.net's password: 

index.html                                    100%   13KB  12.6KB/s   00:00    
index.html                                    100%   10KB  10.1KB/s   00:00    
index.html                                    100%   15KB  14.9KB/s   00:00    
index.html                                    100% 9774     9.5KB/s   00:00    
index.html                                    100%   12KB  11.8KB/s   00:00    
index.html                                    100%   10KB  10.3KB/s   00:00    
theme.css                                     100%   87KB  86.9KB/s   00:00    
highlight.css                                 100% 1682     1.6KB/s   00:00    
theme_extra.css                               100% 2310     2.3KB/s   00:00    
index.html                                    100%   11KB  11.2KB/s   00:00    
index.html                                    100%   18KB  17.9KB/s   00:00    
index.html                                    100%   11KB  10.7KB/s   00:00    
fontawesome-webfont.woff                      100%   43KB  42.6KB/s   00:00    
fontawesome-webfont.ttf                       100%   77KB  77.2KB/s   00:00    
fontawesome-webfont.eot                       100%   37KB  36.5KB/s   00:00    
fontawesome-webfont.svg                       100%  193KB 193.2KB/s   00:00    
index.html                                    100%   11KB  10.7KB/s   00:00    
index.html                                    100%   10KB   9.9KB/s   00:00    
index.html                                    100%   10KB  10.0KB/s   00:00    
index.html                                    100% 9993     9.8KB/s   00:00    
index.html                                    100%   10KB  10.1KB/s   00:00    
index.html                                    100%   10KB  10.5KB/s   00:00    
invoice.png                                   100%  151KB 151.3KB/s   00:00    
invoice_2.png                                 100%  152KB 151.9KB/s   00:00    
firefox_proxy_config.png                      100%   57KB  57.3KB/s   00:00    
invoice_3.png                                 100%  150KB 150.1KB/s   00:00    
favicon.ico                                   100% 1150     1.1KB/s   00:00    
index.html                                    100%   12KB  12.1KB/s   00:00    
index.html                                    100%   11KB  10.7KB/s   00:00    
index.html                                    100%   10KB  10.1KB/s   00:00    
modernizr-2.8.3.min.js                        100%   11KB  10.8KB/s   00:00    
jquery-2.1.1.min.js                           100%   82KB  82.3KB/s   00:00    
highlight.pack.js                             100%  294KB 293.7KB/s   00:00    
theme.js                                      100% 1751     1.7KB/s   00:00    
LICENSE                                       100% 1498     1.5KB/s   00:00    
index.html                                    100%   11KB  11.0KB/s   00:00    
search.js                                     100% 2593     2.5KB/s   00:00    
text.js                                       100%   15KB  15.3KB/s   00:00    
lunr-0.5.7.min.js                             100%   14KB  14.2KB/s   00:00    
mustache.min.js                               100% 8835     8.6KB/s   00:00    
search-results-template.mustache              100%   90     0.1KB/s   00:00    
require.js                                    100%   15KB  14.9KB/s   00:00    
search_index.json                             100%   99KB  99.3KB/s   00:00    
index.html                                    100%   10KB  10.1KB/s   00:00    
index.html                                    100%   11KB  11.0KB/s   00:00    
index.html                                    100%   10KB  10.3KB/s   00:00    
index.html                                    100%   11KB  10.5KB/s   00:00    
index.html                                    100%   10KB   9.8KB/s   00:00    
index.html                                    100% 9906     9.7KB/s   00:00    
index.html                                    100% 9754     9.5KB/s   00:00    
index.html                                    100% 9547     9.3KB/s   00:00    
index.html                                    100% 9830     9.6KB/s   00:00    
index.html                                    100%   11KB  10.6KB/s   00:00    
index.html                                    100%   15KB  15.0KB/s   00:00    
search.html                                   100% 9121     8.9KB/s   00:00    
index.html                                    100%   17KB  17.4KB/s   00:00    
sitemap.xml                                   100% 5732     5.6KB/s   00:00    
index.html                                    100%   13KB  12.7KB/s   00:00    
index.html                                    100%   11KB  11.0KB/s   00:00    
index.html                                    100%   10KB  10.0KB/s   00:00    
index.html                                    100%   10KB  10.1KB/s   00:00    
index.html                                    100%   14KB  14.3KB/s   00:00    
index.html                                    100%   12KB  12.1KB/s   00:00    
index.html                                    100%   10KB   9.9KB/s   00:00    
index.html                                    100%   13KB  13.1KB/s   00:00    
index.html                                    100%   11KB  10.9KB/s   00:00    
index.html                                    100%   10KB  10.2KB/s   00:00    
index.html                                    100%   10KB  10.3KB/s   00:00    

```
