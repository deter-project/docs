#!/usr/bin/bash
echo "You are in directory:"
pwd
ls site >/dev/null && echo "The \"site\" directory exists, changing directory" && cd site && pwd
if which podman 
 then
 echo "podman binary is in path, running mkdocs"
 podman run --rm -it --privileged=true -v ./:/mkdocs --name mkdocs docker.io/polinux/mkdocs bash -c "cd /mkdocs && mkdocs build"
 if [[ $? == 0 ]]
  then
  ls -lh
  echo "Copy the new _site to the github docs repo."
 else
  echo "Error building, check issues and try again"
 fi
else
 echo "No podman found, try \'docker run --rm -it --privileged=true -v ./:/mkdocs --name mkdocs docker.io/polinux/mkdocs bash -c \"cd /mkdocs && mkdocs build\"\'"
fi
