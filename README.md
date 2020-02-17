# Kabanero Developer Experience - Getting Started

Kabanero is an open source project focused on bringing together key foundational open source technologies into a framework for developing and deploying modern cloud-native applications.  The Kabanero developer experience leverages the Appsody and Eclipse Codewind open source projects enabling developers to use project 'templates' to rapidly create new cloud-native applications, develop and build them in a curated container 'stack' environment and deploy them to Knative/Kubernetes all without the need for container or Kubernetes skills.

This tutorial will give you an introduction to the Kabanero developer experience. You'll create and deploy a Java MicroProfile based cloud-native application on Open Liberty, however, Kabanero provides a number of stacks, including Node.js and Spring Boot and is extensible so others can easily be added. For more information, see [Appsody.dev](https://appsody.dev/).

At the end of this tutorial, you should have a good understanding of the Kabanero developer experience through the use of Appsody and Eclipse Codewind.  You'll know how to create a new application, develop and deploy it to Knative and have an appreciation for how Kabanero does all the heavy-lifting helping you focus on the task of writing the code.


## Table of Contents
- [Kabanero Developer Experience - Getting Started](#kabanero-developer-experience---getting-started)
  - [Table of Contents](#table-of-contents)
  - [Before You Begin](#before-you-begin)
    - [Pre-requisites](#pre-requisites)
    - [Enable Kubernetes](#enable-kubernetes)
    - [Visual Studio Code Kabanero Setup](#visual-studio-code-kabanero-setup)
      - [Installing the Codewind Extension for Visual Studio Code](#installing-the-codewind-extension-for-visual-studio-code)
    - [Installing the Appsody CLI](#installing-the-appsody-cli)
      - [Sharing the Appsody Configuration between the CLI and Visual Studio Code - Optional](#sharing-the-appsody-configuration-between-the-cli-and-visual-studio-code---optional)
    - [Pre-requisite checks](#pre-requisite-checks)
  - [Developing Cloud-native applications - Appsody](#developing-cloud-native-applications---appsody)
    - [Getting to know Appsody](#getting-to-know-appsody)
    - [Creating a new Project with Appsody](#creating-a-new-project-with-appsody)
    - [Live coding with Appsody](#live-coding-with-appsody)
    - [Deploying to Kubernetes](#deploying-to-kubernetes)
  - [Developing Cloud-native applications - Codewind](#developing-cloud-native-applications---codewind)
    - [Creating a new Codewind Project](#creating-a-new-codewind-project)
    - [Looking Inside the Container](#looking-inside-the-container)
    <!-- The Open Liberty stack currently does not support codewind metrics
    - [Viewing Application Metrics](#viewing-application-metrics)
    - [Running Load Tests](#running-load-tests)
    -->
    - [Deploy the Project to Knative or Kubernetes via the CLI](#deploy-the-project-to-knative-or-kubernetes-via-the-cli)
  - [Working with Appsody Collections](#working-with-appsody-collections)
    - [Stacks](#stacks)
      - [Collection Scenario 1: Clone the Java Open Liberty Stack](#collection-scenario-1-clone-the-java-open-liberty-stack)
      - [Collection Scenario 2: Custom application templates](#collection-scenario-2-custom-application-template)
    - [Build/CD](#buildcd)
      - [Collection Scenario 3: Add static code verification to build process](#collection-scenario-3-add-static-code-verification-to-build-process)
      - [Collection Scenario 4: Stack versioning](#collection-scenario-4-stack-versioning)
      - [Further reading: Development versus production behaviour](#further-reading-development-versus-production-behaviour)
## Before You Begin
Before you get started, there are a number of pre-reqs you'll need to install.  These are the pre-reqs for developing an Open Liberty application using Kabanero.  Different pre-reqs will be required for other application stacks.

### Pre-requisites

For all users, you need to install the following pre-requisites to complete this tutorial:

* [A Java 8 JDK Installation](https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=openj9)
* [Apache Maven](https://maven.apache.org/)
* Docker Desktop
  * [Windows Docker Installation](https://docs.docker.com/docker-for-windows/)
  * [MacOS Docker Installation](https://docs.docker.com/docker-for-mac/)
* [Visual Studio Code](https://code.visualstudio.com/)


For **Windows users** only:
* Due to the Docker Desktop dependency, this workshop **requires** Windows users to have either a **Windows 10 Professional** or **Windows 10 Enterprise** installation.
* Make sure to read and **execute the instructions** in the [Special notes about Docker Desktop on Windows 10](docker-windows-aad.md) to ensure your Docker installation can successfully write content to volumes mounted into containers.
* Install [Cygwin](https://www.cygwin.com/). Make sure to also include the non-default "python3" (this workshop was tested with version 3.6.8) and "python36-setup" packages, then issue `easy_install-3.6 pip` to get `pip` installed. These dependencies are related to the scenarios for Kabanero solution architects and not required for regular application development ([github issue #54](https://github.com/appsody/appsody/issues/45) will soon remove the dependencies on cygwin and python packages).
* Ensure your Cygwin home directory **matches your Windows home directory**, as described in [this blog entry](https://ryanharrison.co.uk/2015/12/01/cygwin-change-home-directory.html).


### Enable Kubernetes

You will need to enable Kubernetes as this is disabled by default in Docker Desktop. This can be done by going to **Preferences** on MacOS or **Settings** on Windows, navigating to the **Kubernetes** tab, and checking **Enable Kubernetes**.

### Visual Studio Code Kabanero Setup

#### Installing the Codewind Extension for Visual Studio Code
Eclipse Codewind provides a set of extensions to IDEs for doing cloud-native application development.  They enable a full developer/debug cycle with an incremental build where all the code is built and run inside a container.  This means that the likelihood of issues due to different development, build and production environments is vastly reduced.

Although Codewind is an Eclipse project, it's not limited to the Eclipse IDE and in this tutorial, you will use Codewind inside Visual Studio Code.

Codewind requires Docker, so before you begin, ensure your Docker install is complete and running.

To install the **Codewind Extension** for **Visual Studio Code**, you have two options.

1. Install using the **Install** button on [this page](https://marketplace.visualstudio.com/items?itemName=IBM.codewind).

2. Manually launch Visual Studio Code, navigate to the **Extensions** view, search for **Codewind**, and install the extension from here.

### Installing the Appsody CLI
Depending on your operating system, the installation process for the **Appsody CLI** will differ. To correctly install **Appsody** for your operating system, view the following [link](https://appsody.dev/docs/getting-started/installation).

Verify that the CLI tool is installed correctly by executing the following into your terminal:

```
$ appsody list
```

#### Sharing the Appsody Configuration between the CLI and Visual Studio Code - Optional
While this is optional, it is recommended. Rather than having **Appsody CLI** projects stored separately to those you may create in an editor such as **Visual Studio Code** or **Eclipse**, updating the **Appsody** configuration file will enable you to work on your projects across both the CLI and editor.

To share the Appsody configuration, follow the instructions at [this repository](https://github.com/eclipse/codewind-appsody-extension#optional-using-the-same-appsody-configuration-between-local-cli-and-codewind).



### Pre-requisite checks

This step will ensure your environment has all the prerequisites installed and running.

(Windows users should execute it from a Cygwin shell) :

```
curl -sL https://github.com/gcharters/kabanero-dev-getting-started/releases/download/0.0.6/workshop-setup.sh | bash -s -- -p -l java
```

## Developing Cloud-native applications - Appsody

### Getting to know Appsody

We're going to start by trying out the developer experience Appsody provides and then we'll move on to use Eclipse Codewind.

Let's take a look at what Appsody provides in terms of capabilities.  In a command prompt, type:

```
appsody
```

You should see output similar to the following:

```
charters@Grahams-MBP-2 ~ $ appsody
The Appsody command-line tool (CLI) enables the rapid development of cloud native applications.

Complete documentation is available at https://appsody.dev

Usage:
  appsody [command]

Available Commands:
  build       Locally build a docker image of your appsody project
  completion  Generates bash tab completions
  debug       Run the local Appsody environment in debug mode
  deploy      Build and deploy your Appsody project to your Kubernetes cluster
  extract     Extract the stack and your Appsody project to a local directory
  help        Help about any command
  init        Initialize an Appsody project with a stack and template app
  list        List the Appsody stacks available to init
  operator    Install or uninstall the Appsody operator from your Kubernetes cluster.
  repo        Manage your Appsody repositories
  run         Run the local Appsody environment for your project
  stop        Stops the local Appsody docker container for your project
  test        Test your project in the local Appsody environment
  version     Show Appsody CLI version

Flags:
      --config string   config file (default is $HOME/.appsody/.appsody.yaml)
      --dryrun          Turns on dry run mode
  -h, --help            help for appsody
  -v, --verbose         Turns on debug output and logging to a file in $HOME/.appsody/logs

Use "appsody [command] --help" for more information about a command.
```

The Appsody CLI has a number of **Commands**.  The majority of these commands are for working  with stacks: build, debug, run stop, test, and extract, list.

Let's take a look at what stacks we have available by entering:

```
appsody list
```

This command lists the available stacks and you should see something like:

```
charters@Grahams-MBP-2 ~ $ appsody list

REPO          ID                        VERSION  	TEMPLATES         DESCRIPTION                                              
*incubator  	java-openliberty         	0.2.0    	*default         	Open Liberty & OpenJ9 using Maven                        
*incubator  	java-spring-boot2        	0.3.24   	*default, kotlin 	Spring Boot using OpenJ9 and Maven                       
*incubator  	kitura                   	0.2.4    	*default         	Runtime for Kitura applications                          
*incubator  	node-red                 	0.1.1    	*simple          	Node-RED runtime for running flows                       
*incubator  	nodejs                   	0.3.3    	*simple          	Runtime for Node.js applications  
```

You'll see that with the stacks available, we can develop new cloud-native applications using Java, Node or Swift, with a number of different, popular frameworks.

These are the default stacks that Appsody provides; however, anybody can write a stack or customize a stack for use by others. Maybe you want to add support for another language or framework, or perhaps your company has additional governance requirements that you want to add into an existing stack.  We'll go into more details on stack development later, but for now, we're going to use the default java-openliberty stack.   

### Creating a new Project with Appsody

Make a directory to contain your project:

Linux users:
```
mkdir -p ~/workspace/kabanero-workshop/java-example
cd ~/workspace/kabanero-workshop/java-example
```

Windows users:
```
mkdir %USERPROFILE%\workspace\kabanero-workshop\java-example
cd %USERPROFILE%\workspace\kabanero-workshop\java-example
```

Create the new project.  This project will using the Java MicroProfile APIs defined at Eclipse and will run on the open source Open Liberty runtime running on Eclipse Open J9.

```
appsody init java-openliberty
```

When the build completes, you should see something like:

```
...
[InitScript] [INFO] ------------------------------------------------------------------------
[InitScript] [INFO] BUILD SUCCESS
[InitScript] [INFO] ------------------------------------------------------------------------
[InitScript] [INFO] Total time: 0.800 s
[InitScript] [INFO] Finished at: 2019-09-02T15:52:41+01:00
[InitScript] [INFO] ------------------------------------------------------------------------
Successfully initialized Appsody project
```

Open up the project in VS Code.  

```
code .
```

Note, we're not using Codewind at this point.  If you prefer, you can use other IDEs. To experience the incremental update during development you will need an IDE that automatically compiles Java source files each time they are saved.  VS Code (with the Red Hat `Language Support for Java`), Eclipse and IntelliJ IDEA are all known to work.

Expand the project `src` and you should see a structure and code like this:

<img src="images/new-appsody-project.png" width="40%" height="40%">

This is intentionally a 'bare-bones' project so as to avoid the need to delete unnecessary files.  It contains a JAX-RS Application class called `StarterApplication.java`, a JAX-RS Resource class called `StarterResource.java`, a Liberty server configuration consisting of a `server.xml` and `quick-start-security.xml`, a static `index.html` file, and the project build file, `pom.xml`.

### Live coding with Appsody

Let's start the new application ready to make some edits.  Enter the following command:

```
appsody run
```

The run command for this stack has been set up to ensure the compiled code is up to date and then launch the Open Liberty server with the application deploy in `dev mode`.  Dev mode is Open Liberty's support for hot application update during development.

After a while you should see output similar to the following:

```
[Container] [INFO] [AUDIT   ] CWWKE0001I: The server defaultServer has been launched.
[Container] [INFO] [AUDIT   ] CWWKG0093A: Processing configuration drop-ins resource: /opt/ol/wlp/usr/servers/defaultServer/configDropins/defaults/quick-start-security.xml
[Container] [INFO] [AUDIT   ] CWWKZ0058I: Monitoring dropins for applications.
[Container] [INFO] [AUDIT   ] CWPKI0820A: The default keystore has been created using the 'keystore_password' environment variable.
[Container] [INFO] [AUDIT   ] CWWKS4104A: LTPA keys created in 0.908 seconds. LTPA key file: /opt/ol/wlp/usr/servers/defaultServer/resources/security/ltpa.keys
[Container] [INFO] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://4af620caeae9:9080/openapi/ui/
[Container] [INFO] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://4af620caeae9:9080/metrics/
[Container] [INFO] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://4af620caeae9:9080/health/
[Container] [INFO] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://4af620caeae9:9080/ibm/api/
[Container] [INFO] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://4af620caeae9:9080/jwt/
[Container] [INFO] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://4af620caeae9:9080/openapi/
[Container] [INFO] [AUDIT   ] CWPKI0803A: SSL certificate created in 3.961 seconds. SSL key file: /opt/ol/wlp/usr/servers/defaultServer/resources/security/key.p12
[Container] [INFO] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://4af620caeae9:9080/
[Container] [INFO] [AUDIT   ] CWWKZ0001I: Application starter-app started in 3.393 seconds.
[Container] [INFO] [AUDIT   ] CWWKF0012I: The server installed the following features: [appSecurity-2.0, cdi-2.0, concurrent-1.0, distributedMap-1.0, jaxrs-2.1, jaxrsClient-2.1, jndi-1.0, json-1.0, jsonb-1.0, jsonp-1.1, jwt-1.0, microProfile-3.2, mpConfig-1.3, mpFaultTolerance-2.0, mpHealth-2.1, mpJwt-1.1, mpMetrics-2.2, mpOpenAPI-1.1, mpOpenTracing-1.3, mpRestClient-1.3, opentracing-1.3, servlet-4.0, ssl-1.0].
[Container] [INFO] [AUDIT   ] CWWKF0011I: The defaultServer server is ready to run a smarter planet. The defaultServer server started in 14.015 seconds.
[Container] [INFO] CWWKM2015I: Match number: 1 is [2/17/20 16:27:14:725 UTC] 0000002a com.ibm.ws.kernel.feature.internal.FeatureManager            A CWWKF0011I: The defaultServer server is ready to run a smarter planet. The defaultServer server started in 14.015 seconds..
[Container] [INFO] Tests will run automatically when changes are detected.

```

The generated project has maven coordinates (`groupId`, `artifactId`, and `version`) that are the same for each project generated.  To avoid clashes we should change them.  Edit the `pom.xml` file and change:

```
    <groupId>dev.appsody.starter.java-openliberty</groupId>
```

To:

```
    <groupId>kabanero-workshop</groupId>
```

Save the file.   

Let's now make a code change.  The Java OpenLiberty stack we're using takes advantage of `liberty:dev` mode to dynamically update the running application without needing a lengthy maven rebuild.

First, navigate to the JAX-RS application resource endpoint to confirm that the default JAX-RS resource is available.  Open the following link in your browser:

http://localhost:9080/starter/resource

You should see the response `StarterResource response`

Navigate to the `src/main/java/dev/appsody/starter` directory, and open the file called `StarterResource.java` - this is our JAX-RS resource.

```Java
package dev.appsody.starter;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Path("/resource")
public class StarterResource {

    @GET
    public String getRequest() {
        return "StarterResource response";
    }
}
```
Try changing the message in `StarterResource.java`. You should see that upon saving the file the source is compiled and the application updated:

```
[Container] [INFO] Source compilation was successful.
[Container] [INFO] [AUDIT   ] CWWKT0017I: Web application removed (default_host): http://a904f464a04b:9080/
[Container] [INFO] [AUDIT   ] CWWKZ0009I: The application starter-app has stopped successfully.
[Container] [INFO] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://a904f464a04b:9080/
[Container] [INFO] [AUDIT   ] CWWKZ0003I: The application starter-app updated in 1.447 seconds.
```

Refresh your browser page to see the updated message.

When you're done, type `Ctrl-C` to end the appsody run.


### Deploying to Kubernetes

You've finished writing your code and want to deploy to Kubernetes.  The Kabanero project integrates Tekton as a CI/CD pipeline for deploying to Kubernetes (including Knative and Istio).  This enables you to commit your changes to a git repo and have a Tekton pipeline build and potentially deploy the project.

A full Kabanero set-up was considered too much for this workshop, so here we're going to make use of a nice little feature from Appsody, `appsody deploy`.  In the terminal in the root of your project, type:

```
appsody deploy
```

At the end of the deploy, you should see an output like this:

```
Built docker image kabanero-workshop
Using applicationImage of: kabanero-workshop
Attempting to apply resource in Kubernetes ...
Running command: kubectl[apply -f temp-app-deploy.yaml --namespace default]
Deployment succeeded.
Running command: kubectl[get rt kabanero-workshop -o jsonpath="{.status.url}" --namespace default]
Attempting to get resource from Kubernetes ...
Running command: kubectl[get route kabanero-workshop -o jsonpath={.status.ingress[0].host} --namespace default]
Attempting to get resource from Kubernetes ...
Running command: kubectl[get svc kabanero-workshop -o jsonpath=http://{.status.loadBalancer.ingress[0].hostname}:{.spec.ports[0].nodePort} --namespace default]
Deployed project running at http://localhost:30059
```

The very last line tells you where the application is available.  Let's call the resource by opening this endpoint in the browser:

http://localhost:30059/starter/resource

You should now see the response from your JAX-RS resource.

Let's take a look at the deployment.  Enter:

```
kubectl get all
```

You should see an output similar to this:

```
charters@grahams-mbp-2 kabanero-workshop $ kubectl get all
NAME                                    READY   STATUS    RESTARTS   AGE
pod/appsody-operator-5bbbc784b7-rwrf4   1/1     Running   1          6d4h
pod/kabanero-workshop-cc674d6df-npr7c   1/1     Running   0          106m

NAME                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/appsody-operator    ClusterIP   10.106.28.94    <none>        8383/TCP         6d4h
service/kabanero-workshop   NodePort    10.111.44.163   <none>        9080:30059/TCP   106m
service/kubernetes          ClusterIP   10.96.0.1       <none>        443/TCP          6d5h

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/appsody-operator    1/1     1            1           6d4h
deployment.apps/kabanero-workshop   1/1     1            1           106m

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/appsody-operator-5bbbc784b7   1         1         1       6d4h
replicaset.apps/kabanero-workshop-cc674d6df   1         1         1       106m
```

The entries with `kabanero-workshop` are your applications.  The `appsody-operator` are those used by Appsody to perform the deployment.

It's worth noting at this point that this deployment was achieved without us having to write, or understand, a Dockerfile or Kubernetes deployment yaml.  

Now list the files in your project directory.  You should see something like this:

```
-rw-r--r--   1 charters  staff   614  3 Sep 15:02 app-deploy.yaml
-rwxr-xr-x   1 charters  staff  7289  3 Sep 11:18 pom.xml
drwxr-xr-x   4 charters  staff   128  2 Sep 18:05 src
drwxr-xr-x  16 charters  staff   512  2 Sep 18:06 target
```

The `app-deploy.yaml` is generated from the stack and used to deploy to Kubernetes.  If you look inside the file, you'll see entries for `liveness` and `readiness` probes, metrics, and the service port.

Check out the `liveness` and `readiness` endpoints by pointing your browser at:

http://localhost:30059/health/live
http://localhost:30059/health/ready

You should see something like:

```json
// 20190903170443
// http://localhost:30059/health/ready

{
  "checks": [
    {
      "data": {

      },
      "name": "StarterReadinessCheck",
      "status": "UP"
    }
  ],
  "status": "UP"
}
```

These endpoints are provided by the MicroProfile health checks generated by the project starter.

Finally, let's undeploy the application by entering:

```
appsody deploy delete
```

You should see an output something like this:

```
charters@grahams-mbp-2 kabanero-workshop $ appsody deploy delete
Deleting deployment using deployment manifest app-deploy.yaml
Attempting to delete resource from Kubernetes...
Running command: kubectl[delete -f app-deploy.yaml --namespace default]
Deployment deleted
```

Check that everything was undeployed using:


```
kubectl get all
```

You should see output similar to this:

```
charters@grahams-mbp-2 kabanero-workshop $ kubectl get all --namespace default
NAME                                    READY   STATUS    RESTARTS   AGE
pod/appsody-operator-5bbbc784b7-rwrf4   1/1     Running   1          6d21h

NAME                       TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
service/appsody-operator   ClusterIP   10.106.28.94   <none>        8383/TCP   6d21h
service/kubernetes         ClusterIP   10.96.0.1      <none>        443/TCP    6d22h

NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/appsody-operator   1/1     1            1           6d21h

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/appsody-operator-5bbbc784b7   1         1         1       6d21h
```

What if you decide you want to see the Container and Kubernetes configuration that Appsody is using, or you want to take your project elsewhere?  You can do this as follows. Enter:

```
appsody extract --target-dir tmp-extract
```

You should see output similar to:

```
charters@Grahams-MBP-2 kabanero-workshop $ appsody extract --target-dir tmp-extract
Extracting project from development environment
Pulling docker image docker.io/appsody/java-openliberty:0.2
Running command: docker pull docker.io/appsody/java-openliberty:0.2
0.2: Pulling from appsody/java-openliberty
Digest: sha256:335d2d1255c54bc1b999f0b29958af9f2fe184703f2108657312f671002b91bc
Status: Image is up to date for appsody/java-openliberty:0.2
docker.io/appsody/java-openliberty:0.2
[Warning] The stack image does not contain APPSODY_PROJECT_DIR. Using /project
Running command: docker create --name java-example-extract -v /Users/charters/.m2/repository:/mvn/repository -v /Users/charters/workspace/kabanero-workshop/java-example/.:/project/user-app docker.io/appsody/java-openliberty:0.2
Running command: docker cp java-example-extract:/project /Users/charters/.appsody/extract/java-example
Project extracted to /Users/charters/workspace/kabanero-workshop/java-example/tmp-extract
```

Let's take a look at the extracted project:

Linux users:
```
cd ~/workspace/kabanero-workshop/java-example/tmp-extract
ls -al
```

Windows users:
```
cd %USERPROFILE%\workspace\kabanero-workshop\java-example\tmp-extract
dir
```

You should see output similar to the following:

```
charters@Grahams-MBP-2 kabanero-workshop $ ls -al
total 128
drwxr-xr-x  16 charters  staff    512 Feb 14 08:50 .
drwxr-xr-x  12 charters  staff    384 Feb 17 15:49 ..
-rwxrwxr-x   1 charters  staff    188 Feb 14 08:49 .appsody-init.bat
-rwxrwxr-x   1 charters  staff    682 Feb 14 08:49 .appsody-init.sh
-rw-rw-r--   1 charters  staff     42 Feb 14 08:49 .dockerignore
-rw-rw-r--   1 charters  staff   3359 Feb 14 08:49 Dockerfile
-rw-rw-r--   1 charters  staff  10723 Feb 14 08:49 pom.xml
-rw-rw-r--   1 charters  staff   5359 Feb 14 08:49 preload-m2-pom.xml
-rwxrwxr-x   1 charters  staff   1692 Feb 14 08:49 run-stack.sh
drwxr-xr-x  11 charters  staff    352 Feb 17 15:30 user-app
drwxrwxr-x   6 charters  staff    192 Feb 14 08:49 util
-rwxrwxr-x   1 charters  staff   3949 Feb 14 08:49 validate.sh
```

These are the files for the project, including those provided by the stack.  For example, the `pom.xml` is the parent pom for your application, and the `Dockerfile` is the one used to build and package the application.  The `user-app` is the maven project for your application.

That's it for the Appsody part of the workshop.  You've seen how Appsody `stacks` and `templates` make it easy to get started with a new project with a curated and consistent dev and production environment. You've also seen how Appsody makes it really easy to build production-ready containers and deploy them to a Kubernetes environment.  Let's now take a look at Codewind.

## Developing Cloud-native applications - Codewind

### Creating a new Codewind Project

We've seen how the Appsody CLI helps create, build and deploy projects based on stacks and templates.  Let's now see how Codewind augments the Appsody experience with tools for cloud-native development.

We're going to start by creating a new Open Liberty project. These first steps are the same for all the supported project types.

To get started with writing the project, hover over the **Projects** entry underneath **Codewind** in **Visual Studio Code** and press the **+** icon to create a new project.

<img src="images/new-project.png" width="40%" height="40%">

You should see a list of project types you can create including the Appsody project type, `Appsody Open Liberty template`.

<img src="images/new-mpdm-proj.png" width="40%" height="40%">

Select the `Appsody Java Open Liberty template` and in the next field give the project a name, e.g `kabanero-mp-project`

<img src="images/new-mpdm-proj2.png" width="40%" height="40%">

Press `Enter` to create the project.

The project has been generated and will now be building.  To see the progress, expand `Codewind` -> `Projects` and right click the menu options `Show all logs`:

<img src="images/show-all-logs.png" width="40%" height="40%">

After a little while you should see the follow log message:

```
[Container] [INFO] [AUDIT   ] CWWKF0011I: The defaultServer server is ready to run a smarter planet. The defaultServer server started in 18.312 seconds.
```

And the state for the project should change to `Running`:

<img src="images/running.png" width="50%" height="50%">

The generated project contains all the boiler-plate code to get started with developing a Java application with Open Liberty.  This is the exact same code we saw generated for the new Appsody project.

To access the application endpoint in a browser, select the **Open App** icon <img src="images/open-app.png" width="3%" height="3%"> next to the project's name, or right-click on the project and select the `Open App` menu option. This opens up the application in the running container showing the `Welcome to your Appsody Microservice` page.

Let's take a look at the code.  In the **VS Code EXPLORER** you should see a `CODEWIND-WORKSPACE` entry with your project name.  If you don't find it, right-click on the project and choose `Add Folder to Workspace`.  In the workspace view, expand the project and the sub-folders to show all the files created from the Appsody template (Note, the template is not intended to be a sample as most people would end up having to delete the code each time, it aims to provide the starter code, server configuration and build to which you can add your code).

<img src="images/template-code.png" width="50%" height="50%">

The main Java files are **StarterLivenessCheck**, **StarterReadinessCheck**, **StarterApplication** and **StarterResource**.  The first two provide the outlines for `liveness` and `readiness` checks that can be hooked up to `Kubernetes` liveness and readiness probes.  These are implemented using MicroProflie Health.  The third file is a JAX-RS application, which provides the `Application Path` for your REST API. The fourth file is a JAX-RS resource, which provides the `Resource Path` for your REST API.

Point your browser at the new resource (note, `<port>` is the port number you saw when you first opened the application):

```
http://127.0.0.1:<port>/starter/resource
```

You should see the following response:

```
StarterResource response
```

Any changes you make to your code will automatically be built and re-deployed by **Codewind**, and viewed in your browser.

If you have the logs `OUTPUT` tab open you will see that, when changed, the code is compiled and the application restarted. You should see messages like:

```
[Container] [[1;34mINFO[m] Source compilation was successful.
[Container] [[1;34mINFO[m] [AUDIT   ] CWWKT0017I: Web application removed (default_host): http://04013dbc9c11:9080/
[Container] [[1;34mINFO[m] [AUDIT   ] CWWKZ0009I: The application starter-app has stopped successfully.
[Container] [[1;34mINFO[m] [WARNING ] CWMH0053W: The readiness health check reported a DOWN overall status because the following applications have not started yet: [starter-app]
[Container] [[1;34mINFO[m] [AUDIT   ] CWWKT0016I: Web application available (default_host): http://04013dbc9c11:9080/
```

### Looking Inside the Container

During development you may need to look inside the container to see what's deployed and configured.  Codwind makes this easy.  Select the `Open Container Shell` option:

<img src="images/container-shell.png" width="50%" height="50%">

The following shows the files and location where the shell opens inside the container.  This is the root of your project.

<img src="images/shell.png" width="50%" height="50%">

You can navigate around the `src` directory to see the code on disk. The Liberty server and built application deployment is located in the `/opt/ol/wlp/usr/servers/defaultServer` directory.

<!-- The Open Liberty stack currently does not support codewind metrics
### Viewing Application Metrics

Let's take a look at the application metrics built in to Codewind.  Right-click on the application and select `Open Application Monitor`:

<img src="images/start-metrics.png" width="50%" height="50%">

This should open a page in your browser showing the java metrics dashboard with CPU, HTTP, Heap and GC data.  To make it more interesting, hit the REST endpoint a few times to see the effects.  You should end up with a dashboard looking something like:

<img src="images/metrics.png" width="50%" height="50%">

The dashboard helps you understand the runtime characteristics of your service.  Keep the dashboard open for now.

### Running Load Tests

Let's now take a look at the load testing support of Codewind.  Right-click on the application and select `Open Performance Dashboard`:

<img src="images/start-perf.png" width="50%" height="50%">

In a browser tab you should see the Codewind performance dashboard.  Click on `Edit load run settings` and change the path to point to the REST service endpoint `/starter/resource` and click `Save` to save the settings.  Click `Run Load Test`, in the dialog, give the test a name `Test 1` and choose `Run`:

<img src="images/performance-dash.png" width="50%" height="50%">

When the tests are complete you should see results similar to the following (you may need to click refresh in the browser).  Click the check-boxes for `Response`, `Hits`, `CPU` and `Memory`.

<img src="images/test1.png" width="50%" height="50%">

To see the effect of the load test on the service, take a look at the metrics dashboard you opened earlier.  You should see spikes in the various measures.

<img src="images/metrics-dash-test1.png" width="50%" height="50%">

Let's do some development and degrade the performance of the services.  Open the **StarterResource** class and update the `GET` method with the following. Save the file, and as before, the application will be automatically updated:

```Java
    @GET
    public String getRequest() {
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return "StarterResource response";
    }
  ```

In the performance dashboard, click `Run Load Test`, give the test another name, e.g. `Test 2`, and click `Run`.  When the tests complete, you should see results similar to the following:

<img src="images/performance-test2.png" width="50%" height="50%">

We can see clearly from the chart that the response time has increased.  Revisit the metrics dashboard and we can also see the response time increase:

<img src="images/metrics-test2.png" width="50%" height="50%">

-->
### Deploy the Project to Knative or Kubernetes via the CLI

The project you created is a normal Appsody project and so can be worked with using the Appsody CLI. As per the Appsody part of this workshop, deploy the application to Kubernetes using:

Linux users:
```
cd ~/codewind-workspace/kabanero-mp-project
appsody deploy
```

Windows users:
```
cd c:\codewind-workspace\kabanero-mp-project
appsody deploy
```

If this was successful, the output of this command should be:
```
Deployed project running at http://localhost:<port>
```

Test the endpoint by opening:

```
http://127.0.0.1:<port>/starter/resource
```

You should see the following response:

```
StarterResource response
```

Undeploy the application using:

```
appsody deploy delete
```

Locate the deployment which hosts your application through the following command:

```
$ kubectl get all
```

Copy the deployment's URL into a browser. Congratulations! Your application is now accessible through Knative/Kubernetes.


## Working with Appsody Collections

A collection includes everything you need to create a microservice in a single container image, along with an enterprise-grade deployment & integrated continuous delivery choice. Collections are developed by application architects to match their organizational and product requirements and work as the basis for applications created by application developers.

A collection is defined by a combination of a stack (container images and application templates), build/CD conventions, and deployment best-practices.

The workshop will cover various aspects of the customization of an existing collection, which will better prepare you for eventually creating an entirely new collection after the workshop. The entire process for creating a new collection is described in the ["Creating a Stack"](https://appsody.dev/docs/stacks/create) section of the Appsody website.


### Stacks ###

A [stack](https://appsody.dev/docs/stacks/stacks-overview) contains at least one pre-built container image, with the resulting runtime being tailored to the target runtime. An application architect may specify different tuning parameters for a single image, such as dynamic code reloading for development environments, or provide distinct images for different purposes, such as an image stripped out of shell support for production environments.

You can study the internal file structure of a stack in more detail [here](https://appsody.dev/docs/stacks/stack-structure).


#### Collection Scenario 1: Clone the Java Open Liberty Stack ####

The first part of the workshop used the default "incubator/java-openliberty" stack. In this scenario, you, as the application architect, want to create a custom Open Liberty stack.

Navigate to the **kabanero-workshop** directory

Linux users:
```
workshop_dir=$(echo ~)"/workspace/kabanero-workshop"
cd ${workshop_dir}
```

Windows users:
```
set workshop_dir="%USERPROFILE%\workspace\kabanero-workshop"
cd %workshop_dir%
```

Clone the default java-openliberty stack.

```
git clone https://github.com/appsody/stacks.git
```

Open up the project in VS Code.  

Linux users:
```
cd ${workshop_dir}/stacks/incubator/java-openliberty
code .
```

Windows users:
```
cd %workshop_dir%\stacks\incubator\java-openliberty
code .
```

Open the ***stack.yaml*** file, and increment the micro version the stack.

For example, at the time this was written, the stack version was:

```stack.yaml
version: 0.2.1
```

You can change the version to:

```stack.yaml
version: 0.2.2
```

Now we can build our new custom stack by running the following:

Linux users:
```
cd ${workshop_dir}/stacks/incubator/java-openliberty
appsody stack package
```

Windows users:
```
cd %workshop_dir%\stacks\incubator\java-openliberty
appsody stack package
```

When the build finishes, you can verify that your new stack is available to use by entering:

```
appsody list
```

The list of available stacks should now include a new "java-openliberty" stack under the
"dev.local" repository. This repository is used by Appsody for all stacks that have been built locally.
Also note that the version of our new stack is now "0.2.2."

```
REPO        	ID                       	VERSION  	TEMPLATES        	DESCRIPTION                                              
dev.local   	java-openliberty         	0.2.2    	*default         	Open Liberty & OpenJ9 using Maven       
```

We can now start using the new custom stack from the perspective of an application developer.

First, lets create a directory for a new appsody project using the custom stack.

Linux users:
```
mkdir -p ${workshop_dir}/java-example2
cd ${workshop_dir}/java-example2
```

Windows users:
```
mkdir %workshop_dir%\java-example2
cd %workshop_dir%\kabanero-workshop\java-example2
```

Create a new Appsody project like we did before but this time using the local stack:

```
appsody init dev.local/java-openliberty
```

You should see the new version of the stack parent pom being built.

```
[InitScript] [INFO] Scanning for projects...
[InitScript] [INFO]
[InitScript] [INFO] --------------------< dev.appsody:java-openliberty >--------------------
[InitScript] [INFO] Building java-openliberty 0.2.2
[InitScript] [INFO] --------------------------------[ pom ]---------------------------------
[InitScript] [INFO]
[InitScript] [INFO] --- maven-enforcer-plugin:3.0.0-M3:enforce (default-cli) @ java-openliberty ---
[InitScript] [INFO] Skipping Rule Enforcement.
[InitScript] [INFO]
[InitScript] [INFO] --- maven-install-plugin:2.4:install (default-install) @ java-openliberty ---
[InitScript] [INFO] Installing /Users/awisniew/workspace/kabanero-workshop/java-example2/.appsody_init/pom.xml to /Users/awisniew/.m2/repository/dev/appsody/java-openliberty/0.2.2/java-openliberty-0.2.2.pom
[InitScript] [INFO] ------------------------------------------------------------------------
[InitScript] [INFO] BUILD SUCCESS
[InitScript] [INFO] ------------------------------------------------------------------------
[InitScript] [INFO] Total time:  0.829 s
[InitScript] [INFO] Finished at: 2020-02-20T09:42:03-05:00
[InitScript] [INFO] ------------------------------------------------------------------------
```

Start the new application by entering:

```
appsody run
```

As we did previously in this guide, navigate to the JAX-RS application resource endpoint to confirm that the default JAX-RS resource is available.

http://localhost:9080/starter/resource

You should see the response `StarterResource response`


End the application with `Ctrl+C`.


#### Collection Scenario 2: Custom application template ####

A stack contains at least one application template, which is the set of application files placed in the application directory during the initial creation of a project. Templates named "default" are used by `appsody init` when the user does not specify a template name. An application architect can create new templates to reflect different starting points for application developers, such as a default template for a simple stateless application or a more complex template with starter code for connecting to a remote database.

In this scenario, we will inspect an alternative template with a postgresql database connection endpoint, then create and test an application starter using that template.

awisniew todo before merge: change links below

We first need to create the new template. We can copy [this template](https://github.com/awisniew90/kabanero-dev-getting-started/trunk/templates/psqldb) my entering the following.

Note: The following commands use SVN to copy the remote directory to our local workspace. Windows users should enter the commands from Cygwin with SVN installed. As an alternative, you can simply download [the repository](https://github.com/awisniew90/kabanero-dev-getting-started) and copy the "templates/psqldb" direcotory to "~/workspace/kabanero-workshop/stacks/incubator/java-openliberty/templates".

```
cd ${workshop_dir}/stacks/incubator/java-openliberty/templates
svn checkout https://github.com/awisniew090/kabanero-dev-getting-started/trunk/templates/psqldb
```

The new template structure should look something like this:

<img src="images/stack-psqldb-template.png" width="60%" height="60%">

DatabaseResource.java implements a "/database" JAX-RS path under the root context for the application, it relies on PaasProperties.java to read the connection parameters. Those parameters are hardcoded for this workshop, but a template meant for actual production environments should read that information from a secret mounted to the pod or container.

You will also notice the addition of the postgresql JDBC driver to the pom.xml file in the template.

We need to rebuild our stack to pick up the newly added template. This rebuild will be much quicker due to layering and caching of the stack image.

Linux users:
```
cd ${workshop_dir}/stacks/incubator/java-openliberty
appsody stack package
```

Windows users:
```
cd %workshop_dir%\stacks\incubator\java-openliberty
appsody stack package
```

Our second step is to instantiate a local PostgreSQL database. We will use a custom docker network for both the PostgreSQL database container and the application container, which makes it easier for the application container to locate the database container by hostname instead of IP address.

```
docker network create workshop_nw

docker run --rm -it --name workshop-postgres --hostname psqldb --network workshop_nw -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```

Ensure the database container is running:

```
docker ps

b66c53a3be0f        postgres                                                  "docker-entrypoint.s…"   22 seconds ago      Up 21 seconds       5432/tcp                    workshop-postgres
```


Now we can create a new application, using the template containing the database resource:

Linux users:
```
mkdir -p "${workshop_dir}/stacktest-db"
cd "${workshop_dir}/stacktest-db"
```

Windows users:
```
mkdir -p "%workshop_dir%\stacktest-db"
cd "%workshop_dir%\stacktest-db"
```

All users:
```
appsody init dev.local/java-openliberty psqldb

appsody run --network workshop_nw
```

Wait for the application to complete its startup cycle and verify that the new endpoint is available, by opening the http://localhost:9080/starter/database/  URL in a web browser, where you should shee output like this:

```
{"client.info.ApplicationName":"PostgreSQL JDBC Driver","db.product.name":"PostgreSQL","db.product.version":"11.5 (Debian 11.5-1.pgdg90+1)","db.major.version":11,"db.minor.version":5,"db.driver.version":"42.2.6","db.jdbc.major.version":4,"db.jdbc.minor.version":2}
```

End the application with `Ctrl+C`, stop the workshop-postgres container, and delete the custom network:

```
docker stop workshop-postgres
docker network rm workshop_nw
```


### Build/CD ###

A collection also specifies how applications should be built and packaged, encoding conventions about compilation aspects, packaging tooling, unit test enforcement, static code analysis, and many others. A full Kabanero toolchain is implemented as a sequence of steps that happen both inside and outside the container boundaries, and this workshop covers the steps that happen within the container boundaries, such as compilation and packaging of binaries.

This portion of the instructions is executed directly when the developer invokes `appsody build` or implicitly, when the developer invokes `appsody deploy` and there are outstanding code changes since the last build.

#### Collection Scenario 3: Add static code verification to build process ####

 In this scenario, the entire team discussed ways of making code reviews more efficient and agreed on ensuring minimal coding guidelines for all applications based on that stack.

After considering multiple tools, the team agreed on using [Checkstyle](https://maven.apache.org/plugins/maven-checkstyle-plugin/usage.html) , and the application architect can make that modification to the stack image itself.

For simplicity we will use the default checkstyle rules, so that we just need to add the ` checkstyle:check` goal to the `mvn` invocation in the application Dockerfile, located under:

```
${workshop_dir}/stacks/incubator/java-openliberty/image/project/Dockerfile
```

Change the following line from:
```
mvn -Pappsody-build -B liberty:create package
```

to

```
mvn -Pappsody-build -B liberty:create checkstyle:checkstyle package -Dcheckstyle.consoleOutput=true
```

With the change in place, we can rebuild the stack again:

Linux users:
```
cd ${workshop_dir}/stacks/incubator/java-openliberty
appsody stack package
```

Windows users:
```
cd %workshop_dir%\stacks\incubator\java-openliberty
appsody stack package
```

And we can verify that the new code verification step is executed when an application developer executes `appsody build`:

```
cd "${workshop_dir}/java-example2"
appsody build

...

[Docker] Step 14/62 : RUN cd /project/user-app &&     rm -f src/main/liberty/config/configDropins/defaults/quick-start-security.xml &&     mvn -Pappsody-build -B liberty:create checkstyle:checkstyle package -Dcheckstyle.consoleOutput=true
[Docker]  ---> Running in d0d20fdd436c
...
[Docker] [INFO] Starting audit...
[Docker] [ERROR] /project/user-app/src/main/java/dev/appsody/starter/health/StarterReadinessCheck.java:1: Missing package-info.java file. [JavadocPackage]
...
[Docker] [ERROR] /project/user-app/src/main/java/dev/appsody/starter/StarterApplication.java:6: Missing a Javadoc comment. [JavadocType]
[Docker] Audit done.
[Docker] [INFO] There are 14 errors reported by Checkstyle 8.29 with sun_checks.xml ruleset.
...
```

#### Collection Scenario 4: Stack versioning  ####

Appsody supports [semantic versioning](https://semver.org/) during development of stacks and applications. Notice how the checkstyle modification from the previous scenario does not fail the build process, but instead prints a summary of errors for the developer.

This decision was done by design, as an application architect may want to give some time for the whole team to address the errors without suddenly disrupting their workflow.

In this scenario, we want to show how the application architect could release a new version of the stack that will not automatically get picked up by developers immediately after release, so we need to understand how Appsody tags stack images.

We previously incremented the version of our custom stack to 0.2.2, which is listed in the output of `appsody list`. During compilation of the stack, you will notice how Appsody creates 4 docker images:

```
> docker images dev.local/appsody/java-openliberty
REPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
dev.local/appsody/java-openliberty           0                   ad81b68a6079        2 hours ago         1.33GB
dev.local/appsody/java-openliberty           0.2                 ad81b68a6079        2 hours ago         1.33GB
dev.local/appsody/java-openliberty           0.2.2               ad81b68a6079        2 hours ago         1.33GB
dev.local/appsody/java-openliberty           latest              ad81b68a6079        2 hours ago         1.33GB
```

`appsody init` will always configure the application to use the version with two digits, which is "0.2" in this case:

```
cd "${workshop_dir}/java-example2"
cat .appsody-config.yaml

stack: dev.local/java-openliberty:0.2
```

That means application developers will see their next call to `appsody run` to automatically pick up new images tagged 0.2 when the application architect releases any stack with a tag name starting with "0.2.", such as "0.2.3".

For this scenario, we want to modify the stack to actually break the build in case of problems with the static code analysis and tag the release as 0.3.2. To do this, we need to modify the version variable in stack.yaml.

As we did before, open the ***stack.yaml*** file and increment the minor version of the stack.

For example, change this:

```stack.yaml
version: 0.2.2
```

to this:

```stack.yaml
version: 0.3.2
```

Since this is an update to the minor version of the stack version, we also need to update the parentpomrange template variable. This is a custom variable used to indicate an acceptable range for the parent pom version. As you can see, when a major or minor version is changed, this range needs to be updated.

```stack.yaml
templating-data:
    libertyversion: '19.0.0.12'
    parentpomrange: '[0.2, 0.3)'
```

Change the "parentpomrange" value from "[0.2, 0.3)" to "[0.3, 0.4)".

We can now replace the `checkstyle:checkstyle` goal in the `mvn` invocation with `checkstyle:check`, which will fail the build in case of violations of coding guidelines.

Once again, we are modifying the application Dockerfile, located under:

```
${workshop_dir}/stacks/incubator/java-openliberty/image/project/Dockerfile
```

Change the following line from:
```
mvn -Pappsody-build -B liberty:create checkstyle:checkstyle package -Dcheckstyle.consoleOutput=true
```

to

```
mvn -Pappsody-build -B liberty:create checkstyle:check package -Dcheckstyle.consoleOutput=true
```

With the stack version and checkstyle goal updated, we can build the stack one last time.

Linux users:
```
cd ${workshop_dir}/stacks/incubator/java-openliberty
appsody stack package
```

Windows users:
```
cd %workshop_dir%\stacks\incubator\java-openliberty
appsody stack package
```

Now you will notice the new stack images and how 0.2 and 0.2.2 were left untouched.

```
docker images dev.local/appsody/java-openliberty

REPOSITORY                                   TAG                 IMAGE ID            CREATED              SIZE
dev.local/appsody/java-openliberty           0                   37738c47f510        About a minute ago   1.33GB
dev.local/appsody/java-openliberty           0.3                 37738c47f510        About a minute ago   1.33GB
dev.local/appsody/java-openliberty           0.3.2               37738c47f510        About a minute ago   1.33GB
dev.local/appsody/java-openliberty           latest              37738c47f510        About a minute ago   1.33GB
dev.local/appsody/java-openliberty           0.2                 ad81b68a6079        3 hours ago          1.33GB
dev.local/appsody/java-openliberty           0.2.2               ad81b68a6079        3 hours ago          1.33GB
```

With the new stack generated, the application architect will notify developers who are ready to make the switch to the new version about the stack availability, at which point the application developers can modify the appsody configuration in their application directory:

Modify the stack version in "${workshop_dir}/java-example2/.appsody-config.yaml" from:

```
stack: dev.local/appsody/java-openliberty:0.2
```

to

```
stack: dev.local/appsody/java-openliberty:0.3
```

Now modify the parent version in "${workshop_dir}/java-example2/pom.xml" from [0.2, 0.3) to [0.3, 0.4)

With the new changes in place, and with the application updated to use the latest version of the stack, requests to `appsody build` will fail in case of static analysis errors:

```
> appsody build

...
[Docker] Step 14/62 : RUN cd /project/user-app &&     rm -f src/main/liberty/config/configDropins/defaults/quick-start-security.xml &&     mvn -Pappsody-build -B liberty:create checkstyle:checkstyle package -Dcheckstyle.consoleOutput=true
...
[Docker] [ERROR] src/main/java/dev/appsody/starter/StarterApplication.java:[6] (javadoc) JavadocType: Missing a Javadoc comment.
[Docker] [INFO] ------------------------------------------------------------------------
[Docker] [INFO] BUILD FAILURE
[Docker] [INFO] ------------------------------------------------------------------------
[Docker] [INFO] Total time:  5.727 s
[Docker] [INFO] Finished at: 2019-09-06T22:37:46Z
[Docker] [INFO] ------------------------------------------------------------------------
[Docker] [ERROR] Failed to execute goal org.apache.maven.plugins:maven-checkstyle-plugin:3.1.0:check (default-cli) on project starter-app: You have 84 Checkstyle violations. -> [Help 1]
...
[Docker] [ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoFailureException
[Docker] The command '/bin/sh -c cd /project/user-app &&     rm -f src/main/liberty/config/configDropins/defaults/quick-start-security.xml &&     mvn -Pappsody-build -B liberty:create checkstyle:check package -Dcheckstyle.consoleOutput=true' returned a non-zero code: 1

```

#### Further reading: Development versus production behaviour ####

The previous scenario showed a simple change, but Kabanero collections can accommodate more sophisticated behaviours, where the container image is setup with additional debugging capabilities during development and stripped out of those capabilities during production. This [Git pull request](https://github.com/appsody/stacks/pull/56) shows how that type of different behaviour can be achieved, by exploring the usage of [different modes of a stack](https://appsody.dev/docs/stacks/stack-structure): 'initialization', 'rapid local development', and 'build and deploy'.
