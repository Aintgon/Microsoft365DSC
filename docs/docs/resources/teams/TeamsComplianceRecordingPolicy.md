﻿# TeamsComplianceRecordingPolicy

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Identity** | Key | String | Unique identifier of the application instance of a policy-based recording application to be retrieved. | |
| **ComplianceRecordingApplications** | Write | StringArray[] | A list of application instances of policy-based recording applications to assign to this policy. The Id of each of these application instances must be the ObjectId of the application instance as obtained by the Get-CsOnlineApplicationInstance cmdlet. | |
| **Description** | Write | String | Enables administrators to provide explanatory text to accompany a Teams recording policy. For example, the Description might include information about the users the policy should be assigned to. | |
| **DisableComplianceRecordingAudioNotificationForCalls** | Write | Boolean | Setting this attribute to true disables recording audio notifications for 1:1 calls that are under compliance recording. | |
| **Enabled** | Write | Boolean | Controls whether this Teams recording policy is active or not. | |
| **WarnUserOnRemoval** | Write | Boolean | This parameter is reserved for future use. | |
| **Ensure** | Write | String | Present ensures the instance exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the workload's Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |


## Description

Creates a new Teams recording policy for governing automatic policy-based recording in your tenant. Automatic policy-based recording is only applicable to Microsoft Teams users.

## Permissions


