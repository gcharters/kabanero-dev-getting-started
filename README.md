# Kabanero Developer Experience - Getting Started

Kabanero is an open source project focused on bringing together foundational open source technologies into a framework for developing and deploying modern cloud-native applications.  The Kabanero developer experience leverages the Appsody and Eclipse Codewind open source projects enabling developers to use project 'templates' to rapidly create new cloud-native applications, develop and build them in a curated container 'stack' environment and deploy them to Knative/Kubernetes all without the need for container or Kubernetes skills.

This tutorial will give you an introduction to the Kabanerio developer experience. You'll create and deploy a Java MicroProfile based cloud-native application, however, Kabanero provides a number of stacks, including Node.js and Spring Boot and is extensible so others can easily be added. For more information, see [Appsody.dev](https://appsody.dev/).

At the end of this tutorial, you should have a good understanding of the Kabanerio developer experience through the use of Appsody and Eclipse Codewind.  You know how to create a new applications, develop and deploy it to Knative and have an appreciation for how Kabanero does all the heavy-lifting helping you focus on the task of developing the code.


## Table of Contents
- [Kabanero Developer Experience - Getting Started](#kabanero-developer-experience---getting-started)
  - [Table of Contents](#table-of-contents)
  - [Before You Begin](#before-you-begin)
    - [Pre-requisites](#pre-requisites)
    - [Enable Kubernetes](#enable-kubernetes)
    - [Visual Studio Code Kabanero Setup](#visual-studio-code-kabanero-setup)
      - [Installing the Codewind Extension for Visual Studio Code](#installing-the-codewind-extension-for-visual-studio-code)
    - [Installing the Appsody Extension for Codewind](#installing-the-appsody-extension-for-codewind)
    - [CLI Kabanero Setup](#cli-kabanero-setup)
      - [Installing the Appsody CLI](#installing-the-appsody-cli)
      - [Sharing the Appsody Configuration between the CLI and Visual Studio Code - Optional](#sharing-the-appsody-configuration-between-the-cli-and-visual-studio-code---optional)
  - [Creating a new Codewind Project](#creating-a-new-codewind-project)
    - [Create an Appsody Project via the CLI](#create-an-appsody-project-via-the-cli)
    - [Writing the Code](#writing-the-code)
    - [Deploy the Project to Knative or Kubernetes via the CLI](#deploy-the-project-to-knative-or-kubernetes-via-the-cli)

## Before You Begin
Before you get started, there are a number of pre-reqs you'll need to install.  These are the pre-reqs for developing a Java MicroProfile application using Kabanero.  Different pre-reqs will be required for other application stacks.

### Pre-requisites

You need to install the following pre-requisites to complete this tutorial.

* [A Java 8 JDK Installation](https://adoptopenjdk.net/?variant=openjdk8&jvmVariant=openj9)
* [Apache Maven](https://maven.apache.org/)
* Docker
  * [Windows Docker Installation](https://docs.docker.com/docker-for-windows/)
  * [MacOS Docker Installation](https://docs.docker.com/docker-for-mac/)
* [Visual Studio Code](https://code.visualstudio.com/)

### Enable Kubernetes

You will need to enable Kubernetes as this is disabled by default in Docker Desktop. This can be done by going to **Preferences**, navigating to the **Kubernetes** tab, and checking **Enable Kubernetes**.

### Visual Studio Code Kabanero Setup

#### Installing the Codewind Extension for Visual Studio Code
Eclipse Codewind provides a set of extension to IDEs for doing cloud-native application development.  The enable a full developer/debug cycle with incremental build where all the code is built and run inside a container.  This means that the likelihood of issues due to different development, build and production environments is vastly reduced.

Although Codewind is an Eclipse project, it's not limited to the Eclipse IDE and in this tutorial you will use Codewin inside Visual Studio Code.

Codewind requires Docker, so before you begin, ensure your Docker install is complete and running.

To install the **Codewind Extension** for **Visual Studio Code**, you have two options.

1. Install using the **Install** button on [this page](https://marketplace.visualstudio.com/items?itemName=IBM.codewind).

2. Manually launch Visual Studio Code, navigate to the **Extensions** view, search for **Codewind**, and install the extension from here.

### Installing the Appsody Extension for Codewind

Codewind comes with a set of pre-defined `templates` for various project types, but the Kabanero recommendation is to use those provided by Appsody.  To do this requires an Appsody extension to Codewind.

To install **Appsody** for **Codewind**, follow the instructions from the **Appsody Codewind Extension** [repository](https://github.com/kabanero-io/appsodyExtension#installing-the-appsody-extension-on-codewind)

### CLI Kabanero Setup

#### Installing the Appsody CLI
Depending on your operating system, the installation process for the **Appsody CLI** will differ. To correctly install **Appsody** for your operating system, view the following [link](https://appsody.dev/docs/getting-started/installation).

Verify that the CLI tool is installed correctly by executing the following into your terminal:

```
$ appsody
```

#### Sharing the Appsody Configuration between the CLI and Visual Studio Code - Optional
While this is optional, it is recommended. Rather than having **Appsody CLI** projects stored separately to those you may create in an editor such as **Visual Studio Code** or **Eclipse**, updating the **Appsody** configuration file will enable you to work on your projects across both the CLI and editor.

To share the Appsody configuration, follow the instructions at [this repository](https://github.com/kabanero-io/appsodyExtension#optional-using-the-same-appsody-configuration-between-local-cli-and-codewind).

## Creating a new Codewind Project

We're going to start by creating a new MicroProfile project in Codewind. These first steps are the same for all the supported project types.  As we said before, we're going to use the templates and stacks provided by Appsody.

To get started with writing the project, hover over the **Projects** entry underneath **Codewind** in **Visual Studio Code** and press the **+** icon to create a new project.

![Create New Project](/images/new-project.png)

From the list which appears, select the **Appsody Java MicroProfile Template**, and give the project a name. This project contains all the boiler-plate code to get started with developing Java MicroProfile projects with **Appsody** and **Codewind**.

The project will then be imported and deployed via Docker - to observe this, **right click** on the project, and select **Show all logs**.

To view the application in your browser, select the **Open App** icon next to the project's name.

Any changes you make to your code will automatically be built and deployed by **Codewind** and **Appsody**, and can be observed in your browser.

To illustrate this, we will create a basic JAX-RS resource with a GET method, which will return a print statement when the endpoint is called. First, to get a better development view, right click on the project in the **Explorer** in **Visual Studio Code**, and press **Open Folder as Workspace**. The project and its directories will now appear in the **Explorer**.

Navigate to the `src/main/java/dev/appsody/starter` directory, and create a file called `StarterResource.java` - this will be our JAX-RS resource. Populate the file with the following code:

```
package dev.appsody.starter;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Path("/resource")
public class StarterResource {

    @GET
    public void getRequest() {
        System.out.println("Your endpoint is working!");
    }

}
```

As stated previously, any changes to your project will be picked up and built automatically. Therefore, if you click the **Open App** icon, and append `/starter/resource` to URL and hit this endpoint, you should see the following output in the **Visual Studio Code** logs:

```
Your endpoint is working!
```

Congratulations! You have learnt how to develop an  application with **Codewind** and **Appsody**, without worrying about the containerisation and packaging of the application. If you already have **Appsody** installed via the **CLI**, we recommend that you [share the Appsody configuration between the CLI and Visual Studio Code](#), to keep all your **Appsody** projects together.


### Create an Appsody Project via the CLI
Now that the CLI tool is correctly installed, we can now begin to create **Appsody** projects via the command line. To view the list of supported project stacks, enter the following command into your terminal:
```
$ appsody list
```

As of August 2019, the following stacks are supported:
```
ID               	VERSION	DESCRIPTION                                
java-spring-boot2	0.3.2  	Spring Boot using OpenJ9 and Maven         
nodejs-express   	0.2.2  	Express web framework for Node.js          
nodejs           	0.2.2  	Runtime for Node.js applications           
swift            	0.1.0  	Runtime for Swift applications             
java-microprofile	0.2.4  	Eclipse MicroProfile using OpenJ9 and Maven
```

To view the most current list of supported stacks, scroll down to the [Application Stacks](https://appsody.dev/) section on the **Appsody** homepage.

For this tutorial, we will create a **Java MicroProfile** project, by executing the following commands:
```
$ mkdir my-java-project
$ cd my-java-project
$ appsody init java-microprofile
```

The project and its dependencies will then be retrieved.

### Writing the Code
To begin editing the code, open the project in your preferred editor.

If you shared the **Appsody** Configuration between the CLI and **Visual Studio Code**, installed the **Appsody Extension** for the **Visual Studio Code Codewind Extension** as mentioned previously, and created the project in your **codewind-workspace** directory you can chose to import the CLI generated **Appsody** project into your editor's workspace as a **Codewind** project.

For example, with **Visual Studio Code**, import the project by hovering over the **Codewind** section in the **Explorer** view, and press the **Add Existing Project** icon. Enabling the application here will enable you to deploy and develop your application in real-time, viewing the changes as you make them.

Else, if you do not want to use the **Visual Studio Code Codewind Extension**, execute following command to start a development container, and view your changes in real-time:

```
$ appsody run
```

Applications built from the Java MicroProfile template will be served up at ` http://localhost:9080/`. Projects using different stacks, such as the **Node.js** template, will be hosted on different ports. See [the documentation](https://github.com/appsody/stacks/tree/master/incubator) for more information.

Any changes you make to your code will automatically be built and deployed, and can be observed in your browser.

To illustrate this, we will create a basic JAX-RS resource with a GET method, which will return a print statement when the endpoint is called.

Open the project in your editor of choice and navigate to the `src/main/java/dev/appsody/starter` directory. Create a file called `StarterResource.java` - this will be our JAX-RS resource. Populate the file with the following code:

```
package dev.appsody.starter;

import javax.ws.rs.GET;
import javax.ws.rs.Path;

@Path("/resource")
public class StarterResource {

    @GET
    public void getRequest() {
        System.out.println("Your endpoint is working!");
    }

}
```

As stated previously, any changes to your project will be picked up and built automatically. Therefore, if you hit the `localhost:9080/starter/resource` URL in a browser, you should see the following output in the terminal where the `appsody run` command was executed:

```
Your endpoint is working!
```

Congratulations, you have learnt how to develop an application with **Kabanero** using the **CLI**!


### Deploy the Project to Knative or Kubernetes via the CLI
To deploy the project using these technologies, navigate to the project's folder via the command line, and execute the following command:

```
 $ appsody deploy
```

If this was successful, the output of this command should be:
```
Deployment succeeded - check the Kubernetes pods for progress.
```

Locate the deployment which hosts your application through the following command:

```
$ kubectl get all
```

Copy the deployment's URL into a browser. Congratulations! Your application is now accessible through Knative/Kubernetes.
