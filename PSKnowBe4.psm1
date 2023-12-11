# nested functions
function ConvertTo-NormalizedObject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [PSObject]
        $InputObject
    )
    process {
        Select-Object -InputObject $InputObject -Property @(
            foreach($Property in $InputObject.PSObject.Properties.Name){
                @{
                    Name = (ConvertTo-TitleCase $Property.ToLower()) -replace '_'
                    Expression = $Property
                }
            }
        )
    }
}
function ConvertTo-TitleCase {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [string]
        $InputObject
    )
    process {
        $TextInfo = [Globalization.CultureInfo]::InvariantCulture.TextInfo
        $TextInfo.ToTitleCase($InputObject)
    }
}

Function Set-KnowBe4Token {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet("EU","US")]
        [String]
        $Region,
        [Parameter(Mandatory=$true)]
        [String]
        $Token
    )
    $env:KnowBe4Region = $Region.ToLower()
    $env:KnowBe4Token = $Token
}
Function Get-KnowBe4Account {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/account" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
Function Get-KnowBe4RiskScoreHistory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/account/risk_score_history?full=true" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
Function Get-KnowBe4Admins {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $gets = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/account" -Headers $headers
    foreach($get in $gets.admins){
        [PSCustomObject]@{
            Id = $get.Id
            Name = $get.first_name + " " + $get.last_name
            FirstName = $get.first_name
            LastName = $get.last_name
            Email = $get.email
        }
    }
}
# users functions
Function Get-KnowBe4Users {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [ValidateSet("Active","Archived")]
        [String]
        $Status
    )
    $query = "status=" + $status.ToLower()
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/users?$query" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
Function Get-KnowBe4User {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $UserID
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/users/$UserId" -Headers $headers
    $get | ConvertTo-NormalizedObject
}

Function Get-KnowBe4GroupMember {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $GroupId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/groups/$GroupId/members" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4UserRiskHistory {
    [CmdletBinding()]   
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $UserID
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/users/$UserId/risk_score_history" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
# Group functions
Function Get-KnowBe4GroupMember {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $GroupId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/groups/$GroupId/members" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
Function Get-KnowBe4Groups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [ValidateSet("Active","Archived")]
        [String]
        $Status

    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/groups/$GroupId/members" -Headers $headers
    $get | ConvertTo-NormalizedObject
}

function Get-KnowBe4UserRiskScoreHistory {
    [CmdletBinding()]   
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $UserID
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/users/$UserId/risk_score_history" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4GroupRiskScoreHistory {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $GroupId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/groups/$GroupId/risk_score_history" -Headers $headers
    $get | ConvertTo-NormalizedObject
    
}
#phishing Functions
function Get-KnowBe4PhishingCampaign {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $CampaignId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/phishing/campaigns/$CampaignId" -Headers $headers
   $get | ConvertTo-NormalizedObject
}
#training Functions
function Get-KnowBe4PhishingTests {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/phishing/security_tests" -Headers $headers
   $get | ConvertTo-NormalizedObject
   
}
function Get-KnowBe4PhishingCampaignTests {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $CampaignId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/phishing/campaigns/$CampaignID/security_tests" -Headers $headers
   $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4PhishTest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $PstId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/phishing/security_tests/$PstId" -Headers $headers
   $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4PhishTestRecepients {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $PstId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/phishing/security_tests/$PstID/recipients" -Headers $headers
   $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4PhishTestRecepientResults {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $PstId,
        [Parameter(Mandatory=$true)]
        [String]
        $RecipientId 
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/phishing/security_tests/$PstID/recipients/$RecipientId " -Headers $headers
   $get | ConvertTo-NormalizedObject
}
#training Functions
function Get-KnowBe4StorePurchases {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/training/store_purchases" -Headers $headers
   $get | ConvertTo-NormalizedObject
   
}
function Get-KnowBe4StorePurchase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $StorePurchaseId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/training/store_purchases/$StorePurchaseId" -Headers $headers
   $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4Policies {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/training/policies" -Headers $headers
   $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4Policy {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $PolicyId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/training/policies/$PolicyId" -Headers $headers
   $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4TrainingCampaigns {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token
    )

    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/training/campaigns" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4TrainingCampaign {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $CampaignId   
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/training/campaigns/$CampaignId" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
Function Get-KnowBe4TrainingEnrollments {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter()]
        [String]
        $StorePurchaseId,
        [Parameter()]
        [String]
        $CampaignId,
        [Parameter()]
        [String]
        $UserId
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
    $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/training/enrollments" -Headers $headers
    $get | ConvertTo-NormalizedObject
}
function Get-KnowBe4TrainingEnrollment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $token = $env:KnowBe4Token,
        [Parameter(Mandatory=$true)]
        [String]
        $EnrollmentId      
    )
    $headers = @{
        "Accept" = "application/json"
        "Authorization" = "Bearer $token"
    }
   $get = Invoke-RestMethod -Uri "https://$ENV:KnowBe4Region.api.knowbe4.com/v1/training/enrollments/$EnrollmentId" -Headers $headers
   $get | ConvertTo-NormalizedObject
}
