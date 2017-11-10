# docs
DeterLab Documentation Sources

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
