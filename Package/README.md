Installing Sample Application package
======================================

### Prerequisites:
 * Sitecore CMS 6.5 or later with installed Sitecore Item Web API 1.0 

## Installation

The Mobile Demonstration package consists of components (such as Controls and Renderings) that demonstrate how to utilize the Mobile SDK with a Sitecore instance.    
       
To install the package, use the Sitecore Installation Wizard. You can access the Installation Wizard by navigating as follows:

 * via Sitecore Desktop: Sitecore » Development Tools » Installation Wizard.
 * via Sitecore Control Panel: Administration » Install a Package.

 
 After you install the package, in the web.config file, the <xslExtensions> section, add the following string:
	 
 \<extension mode="on" type="Sitecore.XslHelpers.MobileExtensions, Sitecore.Mobile" namespace="http://www.sitecore.net/scmobile" />
