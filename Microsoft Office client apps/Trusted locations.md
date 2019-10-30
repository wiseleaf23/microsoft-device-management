# Configure trusted locations for the Business versions of the Office client apps

> Do not use the Office.admx file for this, I could not get this to work in the Business versions.

## Allow trusted locations on the network
If you want to mark for example SharePoint as a trusted location, you need to enable this.

Name: `Word allow trusted locations on the network`
OMA-URI: `./User/Vendor/MSFT/Policy/Config/Office16~Policy~L_MicrosoftOfficeWord~L_WordOptions~L_Security~L_TrustCenter~L_TrustedLocations/L_AllowTrustedLocationsOnTheNetwork`
Value (string): `<enabled/>`

Name: `PowerPoint allow trusted locations on the network`
OMA-URI: `./User/Vendor/MSFT/Policy/Config/Office16~Policy~L_MicrosoftOfficePowerPoint~L_PowerPointOptions~L_Security~L_TrustCenter~L_TrustedLocations/L_AllowTrustedLocationsOnTheNetwork`
Value (string): `<enabled/>`

Name: `Excel allow trusted locations on the network`
OMA-URI: `./User/Vendor/MSFT/Policy/Config/Office16~Policy~L_MicrosoftOfficeExcel~L_ExcelOptions~L_Security~L_TrustCenter~L_TrustedLocations/L_AllowTrustedLocationsOnTheNetwork`
Value (string): `<enabled/>`

## Set trusted locations
The value for all these is the same, for example:
```
<enabled/>
<data id="L_Pathcolon" value="https://contoso.sharepoint.com/"/>
<data id="L_Datecolon" value="2019-08-12"/>
<data id="L_Descriptioncolon" value="Contoso SharePoint"/>
<data id="L_Allowsubfolders" value="true"/>
```

Name: `Word trusted location 01`
OMA-URI: `./User/Vendor/MSFT/Policy/Config/Office16~Policy~L_MicrosoftOfficeWord~L_WordOptions~L_Security~L_TrustCenter~L_TrustedLocations/L_TrustedLoc01`

Name: `PowerPoint trusted location 01`
OMA-URI: `./User/Vendor/MSFT/Policy/Config/Office16~Policy~L_MicrosoftOfficePowerPoint~L_PowerPointOptions~L_Security~L_TrustCenter~L_TrustedLocations/L_TrustedLoc01`

Name: `Excel  trusted location 01`
OMA-URI: `./User/Vendor/MSFT/Policy/Config/Office16~Policy~L_MicrosoftOfficeExcel~L_ExcelOptions~L_Security~L_TrustCenter~L_TrustedLocations/L_TrustedLoc01`
