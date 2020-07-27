param
(
    [Parameter(Mandatory=$true)]
    [String] $Alias,
    [Parameter(Mandatory=$true)]
    [String] $Title
)

$ErrorActionPreference = "Stop"

$Credential = Get-AutomationPSCredential -Name 'SharePoint Admin'
$AdminUrl = Get-AutomationVariable -Name 'SharePointAdminUrl'

# create connection to SharePoint site
$Connect = Connect-PnPOnline -Url $AdminUrl -Credentials $Credential

# create modern team site
$Site = New-PnPSite -Type TeamSite -TestSite4 $Title -TestSite4 $Alias

# output site url as JSON
@{"Url" = $Site } | ConvertTo-Json -Compress

# unsure if credentials are necessary to create list and libary
# create Lists & Libraries
$Credentials = Get-Credential

# connect to the Site Collection - Enter Site Collection
Connect-PnPOnline -Url https://nonya1..sharepoint.com/sites/TestSite4 -Credentials $Credentials

# create a Contact List
New-PnPList -Title "Risk List" -Template Contacts -OnQuickLaunch

# Add fields ID, Title, Condition, Consequence, Mitigation
Add-PnPField -List "Risk list" -DisplayName "ID"
Add-PnPField -List "Risk list" -DisplayName "Title"
Add-PnPField -List "Risk list" -DisplayName "Condition"
Add-PnPField -List "Risk list" -DisplayName "Consequence"
Add-PnPField -List "Risk list" -DisplayName "Mitigation"
Add-PnPContentTypeToList -List "Risk list" -ContentType "Risk" -DefaultContentType


# Create a Document Library
New-PnPList -Title "Risk Library" -Template DocumentLibrary -OnQuickLaunch


# Optional Create List from CSV
# Create MULTIPLE Lists or Libraries from Csv file
$CsvFile = Import-Csv -Path C:\Users\$env:USERNAME\Desktop\ListsToCreate.csv
foreach ($List in $CsvFile) {
    New-PnPList -Title $List.Title -Template $List.Template -OnQuickLaunch
}