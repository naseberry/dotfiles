#! /bin/bash


## git branch
gitbranch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}


## git commit hash
githash() {
  git rev-parse --short HEAD
}


## git rename branch
gitrenamebranch() {
  echo -e "This will rename your local branch,\ndelete the old remote branch and push the new local branch\n"
  echo "Type the name of the OLD branch"
  read oldBranchName
  echo "Type the name of the NEW branch"
  read newBranchName
  git branch -m $oldBranchName $newBranchName
  git push origin :$oldBranchName $newBranchName
}


# clone all user repos
gitcloneall() {
  echo "Please provide the github username"
  read gituser
  for repo in `curl -s https://api.github.com/users/$gituser/repos?per_page=100 |grep ssh_url |awk '{print $2}'| sed 's/"\(.*\)",/\1/'`;
  do
    git clone $repo;
  done
}


## remove docker containers
dockerremovecontainers() {
  docker stop $(docker ps -a -q)
  docker rm $(docker ps -a -q)
}


## remove docker images
dockerremoveimages() {
  docker rmi $(docker images -q)
}


## haml lint
haml_lint() {
  count=1
  for i in $(git show --pretty="" --name-only $(githash));
  do
    echo $count $i
    code $i
    haml-lint --config ~/haml-lint.yml $i
    ((count++))
  done
}


## VSCode, open file type
codeo() {
  count=1
  echo -e "Please provide the file type extension \nfor example, *.txt"
  read fileType
  for i in $(find $PWD -name "$fileType");
  do
    echo $count $i
    code $i
    ((count++))
  done
}
