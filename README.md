# docs
DeterLab Documentation Sources

# Install proper mkdoc version in a virtual environment

Note that you should install `mkdocs` via pip and not your native package manager, lest you
get an outdated version of `mkdocs`. Create a virtual python enviroment and install mkdocs there.

```shell
virtualenv docs_env
source docs_env/bin/activate
pip install mkdocs
```

When you are done editing the site, clear the environment with ```deactivate```.

## Building
```
cd site
mkdocs build
```
This will build the site in site/site/

## Deploying 

Here is a sketch of how to deploy.

### 1 build the docs
```shell
git clone git@github.com:deter-project/docs.git
cd docs/site
mkdocs build
cd ../..
```

### 2 publish the docs
```shell
git clone git@github.com:deter-project/deter-project.github.io.git
cd deter-project.github.io
rm -rf *
cp -r ../docs/site/site/* .
git add .
git commit -am 'update docs'
git push -u origin master
```
