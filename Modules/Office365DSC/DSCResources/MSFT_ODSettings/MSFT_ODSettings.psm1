function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.UInt32]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String]
        $DomainGuids,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut", "HardOptIn", "SoftOptIn")]
        $GrooveBlockOption,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    $nullReturn = @{
        CentralAdminUrl                           = $CentralAdminUrl
        BlockMacSync                              = $null
        DisableReportProblemDialog                = $null
        DomainGuids                               = $null
        ExcludedFileExtensions                    = $null
        GrooveBlockOption                         = $null
        OneDriveStorageQuota                      = $null
        OrphanedPersonalSitesRetentionPeriod      = $null
        OneDriveForGuestsEnabled                  = $null
        ODBAccessRequests                         = $null
        ODBMembersCanShare                        = $null
        NotifyOwnersWhenInvitationsAccepted       = $null
        NotificationsInOneDriveForBusinessEnabled = $null
        Ensure                                    = "Absent"
    }

    try
    {
        Write-Verbose -Message "Getting OneDrive quota size for tenant"
        $tenant = Get-SPOTenant

        if (!$tenant)
        {
            Write-Verbose "Failed to get Tenant information"
            return $nullReturn
        }

        Write-Verbose -Message "Getting OneDrive quota size for tenant $($tenant.OneDriveStorageQuota)"
        Write-Verbose -Message "Getting tenant client sync setting"
        $tenantRestrictions = Get-SPOTenantSyncClientRestriction

        if (!$tenantRestrictions)
        {
            Write-Verbose "Failed to get Tenant client synce settings!"
            return $nullReturn
        }

        $GrooveOption = $null

        if (($tenantRestrictions.OptOutOfGrooveBlock -eq $false) -and ($tenantRestrictions.OptOutOfGrooveSoftBlock -eq $false))
        {
            $GrooveOption = "SoftOptIn"
        }

        if (($tenantRestrictions.OptOutOfGrooveBlock -eq $false) -and ($tenantRestrictions.OptOutOfGrooveSoftBlock -eq $true))
        {
            $GrooveOption = "HardOptIn"
        }

        if (($tenantRestrictions.OptOutOfGrooveBlock -eq $true) -and ($tenantRestrictions.OptOutOfGrooveSoftBlock -eq $true))
        {
            $GrooveOption = "OptOut"
        }

        $FixedExcludedFileExtensions = $tenantRestrictions.ExcludedFileExtensions
        if ($FixedExcludedFileExtensions.Count -eq 0 -or
            ($FixedExcludedFileExtensions.Count -eq 1 -and $FixedExcludedFileExtensions[0] -eq ""))
        {
            $FixedExcludedFileExtensions = @()
        }

        $FixedAllowedDomainList = $tenantRestrictions.AllowedDomainList
        if ($FixedAllowedDomainList.Count -eq 0 -or
            ($FixedAllowedDomainList.Count -eq 1 -and $FixedAllowedDomainList[0] -eq ""))
        {
            $FixedAllowedDomainList = @()
        }

        return @{
            CentralAdminUrl                           = $CentralAdminUrl
            BlockMacSync                              = $tenantRestrictions.BlockMacSync
            DisableReportProblemDialog                = $tenantRestrictions.DisableReportProblemDialog
            DomainGuids                               = $FixedAllowedDomainList
            ExcludedFileExtensions                    = $FixedExcludedFileExtensions
            GrooveBlockOption                         = $GrooveOption
            OneDriveStorageQuota                      = $tenant.OneDriveStorageQuota
            OrphanedPersonalSitesRetentionPeriod      = $tenant.OrphanedPersonalSitesRetentionPeriod
            OneDriveForGuestsEnabled                  = $tenant.OneDriveForGuestsEnabled
            ODBAccessRequests                         = $tenant.ODBAccessRequests
            ODBMembersCanShare                        = $tenant.ODBMembersCanShare
            NotifyOwnersWhenInvitationsAccepted       = $tenant.NotifyOwnersWhenInvitationsAccepted
            NotificationsInOneDriveForBusinessEnabled = $tenant.NotificationsInOneDriveForBusinessEnabled
            Ensure                                    = "Present"
        }
    }
    catch
    {
        Write-Verbose "Failed to get Tenant client sync settings !"
        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.UInt32]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String]
        $DomainGuids,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut", "HardOptIn", "SoftOptIn")]
        $GrooveBlockOption,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Test-SPOServiceConnection -SPOCentralAdminUrl $CentralAdminUrl -GlobalAdminAccount $GlobalAdminAccount

    ## Configure OneDrive settings
    ## Parameters below are remove for the Set-SPOTenant cmdlet
    ## they are used in the Set-SPOTenantSyncClientRestriction cmdlet
    $CurrentParameters = $PSBoundParameters
    $CurrentParameters.Remove("CentralAdminUrl")
    $CurrentParameters.Remove("GlobalAdminAccount")

    if ($CurrentParameters.ContainsKey("BlockMacSync"))
    {
        $CurrentParameters.Remove("BlockMacSync")
    }
    if ($CurrentParameters.ContainsKey("DomainGuids"))
    {
        $CurrentParameters.Remove("DomainGuids")
    }
    if ($CurrentParameters.ContainsKey("DisableReportProblemDialog"))
    {
        $CurrentParameters.Remove("DisableReportProblemDialog")
    }
    if ($CurrentParameters.ContainsKey("ExcludedFileExtensions"))
    {
        $CurrentParameters.Remove("ExcludedFileExtensions")
    }
    if ($CurrentParameters.ContainsKey("GrooveBlockOption"))
    {
        $CurrentParameters.Remove("GrooveBlockOption")
    }

    Write-Verbose -Message "Configuring OneDrive settings."
    Set-SPOTenant @CurrentParameters

    $clientSyncParameters =  $PSBoundParameters

    ## Configure Sync Client restrictions
    ## Set-SPOTenantSyncClientRestriction has different parameter sets and they cannot be combined see article:
    ## https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/set-spotenantsyncclientrestriction?view=sharepoint-ps

    if ($clientSyncParameters.ContainsKey("BlockMacSync") -and $clientSyncParameters.ContainsKey("DomainGuids"))
    {
        Set-SPOTenantSyncClientRestriction -BlockMacSync:$BlockMacSync -DomainGuids $DomainGuids -Enable
    }
    elseif ($clientSyncParameters.ContainsKey("DomainGuids") -and (!$clientSyncParameters.ContainsKey("BlockMacSync")))
    {
        Set-SPOTenantSyncClientRestriction -DomainGuids $DomainGuids -Enable
    }

    if ($clientSyncParameters.ContainsKey("ExcludedFileExtensions"))
    {
        $BlockedFileTypes = ""
        foreach ($fileTypes in $ExcludedFileExtensions)
        {
            $BlockedFileTypes += $fileTypes + ';'
        }

        Set-SPOTenantSyncClientRestriction -ExcludedFileExtensions $BlockedFileTypes
    }
    if ($clientSyncParameters.ContainsKey("DisableReportProblemDialog"))
    {
        Set-SPOTenantSyncClientRestriction -DisableReportProblemDialog $DisableReportProblemDialog
    }

    if ($clientSyncParameters.ContainsKey("GrooveBlockOption"))
    {
        Set-SPOTenantSyncClientRestriction -GrooveBlockOption $GrooveBlockOption
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (

        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.UInt32]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        [ValidateSet("On", "Off", "Unspecified")]
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String]
        $DomainGuids,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        [ValidateSet("OptOut", "HardOptIn", "SoftOptIn")]
        $GrooveBlockOption,

        [Parameter()]
        [ValidateSet("Present", "Absent")]
        [System.String]
        $Ensure = "Present",

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose -Message "Testing client tenant sync settings"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-O365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-O365DscHashtableToString -Hashtable $PSBoundParameters)"

    $TestResult = Test-Office365DSCParameterState -CurrentValues $CurrentValues `
                                                  -DesiredValues $PSBoundParameters `
                                                  -ValuesToCheck @("BlockMacSync", `
                                                                   "ExcludedFileExtensions", `
                                                                   "DisableReportProblemDialog", `
                                                                   "GrooveBlockOption", `
                                                                   "DomainGuids", `
                                                                   "OneDriveStorageQuota", `
                                                                   "OrphanedPersonalSitesRetentionPeriod", `
                                                                   "OneDriveForGuestsEnabled", `
                                                                   "ODBAccessRequests", `
                                                                   "ODBMembersCanShare", `
                                                                   "NotifyOwnersWhenInvitationsAccepted", `
                                                                   "NotificationsInOneDriveForBusinessEnabled",
                                                                   "Ensure")

    Write-Verbose "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $CentralAdminUrl,

        [Parameter()]
        [System.UInt32]
        $OneDriveStorageQuota,

        [Parameter()]
        [System.UInt32]
        $OrphanedPersonalSitesRetentionPeriod,

        [Parameter()]
        [System.Boolean]
        $OneDriveForGuestsEnabled,

        [Parameter()]
        [System.Boolean]
        $NotifyOwnersWhenInvitationsAccepted,

        [Parameter()]
        [System.Boolean]
        $NotificationsInOneDriveForBusinessEnabled,

        [Parameter()]
        [System.String]
        $ODBMembersCanShare,

        [Parameter()]
        [System.String]
        $ODBAccessRequests,

        [Parameter()]
        [System.Boolean]
        $BlockMacSync,

        [Parameter()]
        [System.Boolean]
        $DisableReportProblemDialog,

        [Parameter()]
        [System.String]
        $DomainGuids,

        [Parameter()]
        [System.String[]]
        $ExcludedFileExtensions,

        [Parameter()]
        [System.String]
        $GrooveBlockOption,

        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )
    $result = Get-TargetResource @PSBoundParameters
    $result.GlobalAdminAccount = Resolve-Credentials -UserName "globaladmin"
    $content = "        ODSettings " + (New-GUID).ToString() + "`r`n"
    $content += "        {`r`n"
    $currentDSCBlock = Get-DSCBlock -Params $result -ModulePath $PSScriptRoot
    $content += Convert-DSCStringParamToVariable -DSCBlock $currentDSCBlock -ParameterName "GlobalAdminAccount"
    $content += "        }`r`n"
    return $content
}

Export-ModuleMember -Function *-TargetResource
