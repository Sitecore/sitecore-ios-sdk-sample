Installing Sample Application package
======================================

### Prerequisites:
 * Sitecore CMS 6.6 or later with installed Sitecore Item Web API 1.0 

## Installation

The Mobile Demonstration package consists of components (such as Controls and Renderings) that demonstrate how to utilize the Mobile SDK with a Sitecore instance.    
       
To install the package, use the Sitecore Installation Wizard. You can access the Installation Wizard by navigating as follows:

 * via Sitecore Desktop: Sitecore » Development Tools » Installation Wizard.
 * via Sitecore Control Panel: Administration » Install a Package.

 
 After you install the package, in the web.config file, the <xslExtensions> section, add the following string:

```xml	 
 <extension mode="on" type="Sitecore.XslHelpers.MobileExtensions, Sitecore.Mobile" namespace="http://www.sitecore.net/scmobile" />
```

## WebApi settings

In Sitecore.ItemWebApi.config add “shell” site and set security settings for the sites as following:

```xml
<site name="website">
        <patch:attribute name="itemwebapi.mode">AdvancedSecurity</patch:attribute>
        <patch:attribute name="itemwebapi.access">ReadWrite</patch:attribute>
        <patch:attribute name="itemwebapi.allowanonymousaccess">false</patch:attribute>
</site>
```	
```xml
<site name="shell">
        <patch:attribute name="itemwebapi.mode">AdvancedSecurity</patch:attribute>
        <patch:attribute name="itemwebapi.access">ReadWrite</patch:attribute>
        <patch:attribute name="itemwebapi.allowanonymousaccess">false</patch:attribute>
</site>
```
