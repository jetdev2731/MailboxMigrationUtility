
# License & Group Audit

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All"

# Get all licensed users
$users = Get-MgUser -All | Where-Object { $_.AssignedLicenses }

foreach ($user in $users) {
    $groups = Get-MgUserMemberOf -UserId $user.Id
    [PSCustomObject]@{
        DisplayName   = $user.DisplayName
        UserPrincipal = $user.UserPrincipalName
        Licenses      = ($user.AssignedLicenses | ForEach-Object { $_.SkuId }) -join ', '
        Groups        = ($groups | Where-Object { $_.'@odata.type' -eq '#microsoft.graph.group' } | ForEach-Object { $_.DisplayName }) -join ', '
    }
}
