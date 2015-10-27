#!/bin/bash

# usage: ./test-custom-command.sh "all| [distribution]*" "cmd" "repo"

if [[ -n $(git diff-index --name-only HEAD --) ]]; then
  echo "Tests canceled because there are uncommitted changed."
  echo "Calling $0 would reset the Docker scripts to the git HEAD and result in data loss."
  exit 1
fi


SCRIPT=$(readlink -f $0)
SCRIPTPATH=$(dirname $SCRIPT)
DIR=${SCRIPTPATH}/distributions

# Add the custom command to the test.sh scripts
if [[ -n "$2" ]]; then
  CMD=$(echo $2 | sed -e 's/[\/&]/\\&/g')
  find $DIR -name "test.sh" -exec sed -i -e "s/#{{CUSTOMCOMMAND}}/$CMD/" {} \+
fi

# Replace the standard xtreemfs repo path
if [[ -n "$3" ]]; then
  REPO=$3

  PROJECT_FROM="home:xtreemfs:unstable"
  PROJECT_TO=$REPO
  S_PROJECT="s#${PROJECT_FROM}#${PROJECT_TO}#g"

  # Path components are split at the ":"
  PATH_FROM=$(sed 's#:#:/#g' <<< "${PROJECT_FROM}")
  PATH_TO=$(sed 's#:#:/#g' <<< "${PROJECT_TO}")
  S_PATH="s#${PATH_FROM}#${PATH_TO}#g"

  # Substitute in Dockerfiles
  find $DIR -name "Dockerfile" -exec sed -e "${S_PROJECT}" -e "${S_PATH}" -i {} \+
fi

# Run the tests
$SCRIPTPATH/test-distributions.sh $1


# Reset the test.sh scripts
if [[ -n "$CMD" ]]; then
  find $DIR -name "test.sh" -execdir git checkout HEAD -- {} \;
fi

# Reset the standard xtreemfs repo path
if [[ -n "$REPO" ]]; then 
  find $DIR -name "Dockerfile" -execdir git checkout HEAD -- {} \;
fi

