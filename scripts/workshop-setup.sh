#!/bin/sh

original_dir=$PWD

set -e

#
# Execution parameters
#

appsody_repo=workshop-prep
app_name=java-example

workshop_dir=$(echo ~)"/workspace/kabanero-workshop"
# workshop_dir=`mktemp /tmp/wk.XXXXXX` || exit 1
app_dir=${workshop_dir}/${app_name}

#
# Executes the first workshop steps once to trigger caching of docker images and other 
# dependencies.
#
function cacheStacks {
    echo
    echo "INFO: Workshop preparation starting..."
    echo

    mkdir -p ${workshop_dir}
    cd ${workshop_dir}
    stacks_dir=${workshop_dir}/stacks
    git clone https://github.com/gcharters/stacks.git

    echo
    echo "INFO: Caching docker images"
    echo
    mkdir -p ~/.m2
    cd ${stacks_dir}
    ./ci/build.sh . experimental/java-microprofile-dev-mode

    [[ $(appsody list | grep ${appsody_repo}) ]] && appsody repo remove ${appsody_repo}
    appsody repo add ${appsody_repo} file://${workshop_dir}/stacks/ci/assets/experimental-index-local.yaml

    echo
    echo "INFO: Prime cache for build and run"
    echo        
    rm -rf ${app_dir}
    mkdir -p ${app_dir}
    cd ${app_dir}
    appsody init ${appsody_repo}/java-microprofile-dev-mode
    appsody build
    (appsody run --name workshop_prep_container) & sleep 180 ; kill -9 $!
    appsody stop --name workshop_prep_container


    echo "INFO: Clearing all temporary content"
    appsody repo remove ${appsody_repo}
    docker rmi ${app_name}:latest

    rm -rf ${app_dir}

    cd ${original_dir}
}


#
# Ensures that all required prerequisites for the workshop are installed and running.
#
function checksPrereqs {
    local prereqFailed=0

    echo
    echo "INFO: Starting prerequisite checking..."
    echo

    appsodyPrereqFailed=0
    which appsody &> /dev/null || appsodyPrereqFailed=1
    if [ ${appsodyPrereqFailed} -eq 1 ]; then
        echo "ERROR: appsody CLI cannot be found in the PATH environment variable. Refer to https://appsody.dev/docs/getting-started/installation for instructions"
        prereqFailed=1
    else
        echo "INFO: appsody CLI installed: $(appsody version)"
    fi

    gitPrereqFailed=0
    which git &> /dev/null || gitPrereqFailed=1
    if [ ${gitPrereqFailed} -eq 1 ]; then
        echo "ERROR: appsody CLI cannot be found."
        prereqFailed=1
    else
        echo "INFO: git CLI installed: $(git version)"
    fi

    dockerPrereqFailed=0
    which docker &> /dev/null || dockerPrereqFailed=1
    if [ ${dockerPrereqFailed} -eq 1 ]; then
        if [ "$(uname)" == "Darwin" ]; then 
            echo "ERROR: docker CLI cannot be found in the PATH environment variable. Refer to https://docs.docker.com/docker-for-mac/ for installation instructions"
        else
            echo "ERROR: docker CLI cannot be found. Refer to https://docs.docker.com/install/overview/ for installation instructions"
        fi
        prereqFailed=1
    else
        echo "INFO: docker CLI installed" 
    fi

    dockerRunningPrereqFailed=0
    docker ps &> /dev/null || dockerRunningPrereqFailed=1
    if [ ${dockerRunningPrereqFailed} -eq 1 ]; then
        echo "ERROR: docker daemon is not running."
        prereqFailed=1
    else
        echo "INFO: docker daemon is running"
    fi

    docker_major_version=$(docker -v | cut -d " " -f 3 | cut -d "." -f 1)
    if [[ "${docker_major_version}" <  "19" ]]; then
        echo "ERROR: docker version [$(docker -v)] does not support built-in kubernetes. Minimum is version 18.06."
        prereqFailed=1
    else
        echo "INFO: docker version [$(docker -v | cut -d ' ' -f 3 | cut -d ',' -f 1)] meets minimum requirements."
    fi

    kubectlPrereqFailed=0
    which kubectl &> /dev/null || kubectlPrereqFailed=1
    if [ ${kubectlPrereqFailed} -eq 1 ]; then
        echo "ERROR: kubectl CLI cannot be found in the PATH environment variable."
        prereqFailed=1
    else
        echo "INFO: kubectl CLI installed: $(kubectl version --short=true 2> /dev/null | tr -s '\n' ' ')"
    fi

    kubectlContextPrereqFailed=0
    kubectl_current_context=$(kubectl config current-context)
    if [ ! "${kubectl_current_context}" == "docker-desktop" ] &&
       [ ! "${kubectl_current_context}" == "docker-for-desktop" ]; then
        echo "ERROR: kubectl CLI context is not set to \"docker-destop\""
        echo "ERROR: This workshop has been tested with the Kubernetes cluster built into docker-destop."
        echo "ERROR: Set kubectl to the \"docker-desktop\" context by running: \"kubectl config set-context docker-desktop\""
        prereqFailed=1
    else
        echo "INFO: kubectl context for workshop is correct: ${kubectl_current_context}"
    fi

    local kubectlRunningClusterPrereqFailed=0
    kubectl cluster-info &> /dev/null || kubectlRunningClusterPrereqFailed=1
    if [ ${kubectlRunningClusterPrereqFailed} -eq 1 ]; then
        echo "ERROR: kubernetes cluster information is not available. Please check whether the cluster is running with \"kubectl cluster-info\"."
        prereqFailed=1
    else
        echo "INFO: kubernetes cluster is available."
        kubectl cluster-info | grep -i running
    fi

    kubectl_client_version=$(kubectl version --short=true | grep Client | cut -d ' ' -f 3 | cut -d "." -f 1-2)
    if [[ "${kubectl_client_version}" <  "v1.15" ]]; then
        echo "ERROR: kubectl client version [$(kubectl version --short=true | grep Client | cut -d ' ' -f 3)] does not support Appsody. Minimum is 1.15"
        prereqFailed=1
    else
        echo "INFO: kubectl client version [$(kubectl version --short=true | grep Client | cut -d ' ' -f 3)] meets minimum requirements."
    fi

    if [ ${prereqFailed} -eq 0 ]; then
        echo "INFO: All prerequisites verified."
    else
        echo "ERROR: Workshop prerequisites are not met, please review earlier messages."
    fi

    return ${prereqFailed}
}


# 
# Prime cache for stacks
#
if [ ! -e "${workshop_dir}" ]; then
    cacheStacks
    result=$?
fi

checksPrereqs
result=$?


#
# Environment settings
#
export CODEWIND_INDEX=true


echo
echo "INFO: Workshop preparation ready at ${workshop_dir}"
echo

exit ${result}
