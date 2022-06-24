# How to Leverage the SAP Event Mesh from SAP BTP, ABAP Environment
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/cloud-abap-event-mesh-api)](https://api.reuse.software/info/github.com/SAP-samples/cloud-abap-event-mesh-api)

## Description

This sample code shows ABAP developers how they can leverage the SAP Event Mesh when working in the SAP BTP, ABAP Environment(aka Steampunk). For more information, check out the blog post [here](https://blogs.sap.com/2021/05/06/how-to-leverage-the-sap-event-mesh-from-sap-btp-abap-environment/).

## Requirements
Make sure to fulfill the following requirements:
* You have access to an SAP BTP, ABAP Environment instance (see [here](https://blogs.sap.com/2018/09/04/sap-cloud-platform-abap-environment) for additional information).
* You have downloaded and installed ABAP Development Tools (ADT). Make sure to use the most recent version as indicated on the [installation page](https://tools.hana.ondemand.com/#abap). 
* You have created an ABAP Cloud Project in ADT that allows you to access your SAP BTP ABAP Environment instance (see [here](https://help.sap.com/viewer/5371047f1273405bb46725a417f95433/Cloud/en-US/99cc54393e4c4e77a5b7f05567d4d14c.html) for additional information). Your log-on language is English.
* You have installed the [abapGit](https://github.com/abapGit/eclipse.abapgit.org) plug-in for ADT from the update site `http://eclipse.abapgit.org/updatesite/`.

## Download and Installation
Use the abapGit plug-in to install the ABAP File Uploader Examples by executing the following steps:
1. In your ABAP cloud project, create an ABAP package for the demo content to be downloaded (leave the suggested values unchanged when following the steps in the package creation wizard).
2. To add the <em>abapGit Repositories</em> view to the <em>ABAP</em> perspective, click `Window` > `Show View` > `Other...` from the menu bar and choose `abapGit Repositories`.
3. In the <em>abapGit Repositories</em> view, click the `+` icon to clone an abapGit repository.
4. Enter the following URL of this repository: `https://github.com/SAP-samples/cloud-abap-event-mesh-api` and choose <em>Next</em>.
5. Create a new transport request that you only use for this demo content installation (recommendation) and choose <em>Finish</em> to link the Git repository to your ABAP cloud project. The repository appears in the abapGit Repositories View with status <em>Linked</em>.
6. Right-click on the new ABAP repository and choose `pull` to start the cloning of the repository contents. Note that this procedure may take a few minutes. 
8. Once the cloning has finished, the status is set to `Pulled Successfully`. Then refresh your project tree. 

As a result of the installation procedure above, the ABAP system creates an inactive version of all artifacts from the demo content

To activate all development objects from this sample: 
1. Click the mass-activation icon (<em>Activate Inactive ABAP Development Objects</em>) in the toolbar.  
2. In the dialog that appears, select all development objects in the transport request (that you created for the demo content installation) and choose <em>Activate</em>.

## Known Issues

## How to obtain support

[Create an issue](https://github.com/SAP-samples/cloud-abap-event-mesh-api/issues) in this repository if you find a bug or have questions about the content.
 
For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html).

## Contributing

## License
Copyright (c) 2021 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSES/Apache-2.0.txt) file.
