<#

    .SYNOPSIS
    A script that retrieves a user from AD and displays all of their phone numbers

    .DESCRIPTION
    Prompts the user for an account name to search for, retrieves it from Active Directory, and then displays all of their phone numbers. 
    The search allows for partial matches and will prompt the user to select the result they are looking for. 

#>

#--------------------------------- Define functions ------------------------------------#

function Get-YesNoResponse {
 
    <#
    
    .SYNOPSIS
    Prompts a user to answer yes or no to a given prompt  
    
    .DESCRIPTION
    Provides a yes/no question to the user and requests a response. Returns true if the response is yes, returns false if the answer is no.

    .INPUTS
    Reads a string input from the console

    .OUTPUTS
    Returns a boolean value
        
    #>


    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory)]
        [String]$Prompt
    
    )

    $acceptedResponses = "y", "yes", "n", "no"
    $invalidResponseMsg = "`nInvalid Entry. Please enter 'y' or 'n'."
    $responseOptions = "(y/n)"

    while($true){
            
        $adUserResponse = Read-Host "`n$Prompt $responseOptions"  

        if ($adUserResponse -notin $acceptedResponses){

            Write-Host $invalidResponseMsg -ForegroundColor Red                                     
                            
        } 
                       
        else{   
                            
            if($adUserResponse -in ("y", "yes")){

                return $true

            }

                return $false

        }           
    }
}

function Show-ADUserData {

    <#
    
    .SYNOPSIS
    Displays the results of searching for a user in AD   
    
    .DESCRIPTION
    Accepts an AD user object and an array of properties as inputs. Displays that user's properties to the console

    .INPUTS
    Accepts two mandatory parameters - an AD user object, and an array of properties
        
    .OUTPUTS
    Outputs a table to the console

    #>


    [CmdletBinding()]
    param (
        
        [Parameter(Mandatory)]
        [Microsoft.ActiveDirectory.Management.ADUser]$User,
        [Parameter(Mandatory)]
        [array]$PropertiesToShow
    
    )

    Clear-Host
    Write-Host "Results for $($User.Name):"    
    $User | Format-Table $PropertiesToShow 

}


#--------------------------- Start Main Program ----------------------------#


$runSearch = $true
$colSpacing = 15
$desiredProperties = @{l="Office Number"; e={$_.IPPHone}; a="left"; w=$colSpacing}, @{l="Direct Line"; e={$_.TelephoneNumber}; a="left"; w=$colSpacing}, 
                     @{l="Mobile"; e={$_.MobilePhone}; a="left"; w=$colSpacing}, 
                     @{l="Extension"; e={$_.Pager}; a="left"; w=$colSpacing}, "Fax"


while($runSearch){
    
    Clear-Host
    $searchResults = [ordered]@{}
    $viewSearchResults = $true
    $idNumber = 0

    #get the name to search from the user. 
    #Strip extra white space and replace '.' so that the search can work with SamAccountName or display name

    $adUser = (Read-Host "`nEnter a user's name").Trim() -Replace "[.\s]+", " "  
    
    # Try to find the user in AD, and add any matches to an ordered hashtable using $idNumber as the keys
    Get-ADUser -Filter "Name -like '*$adUser*'" -Properties * | ForEach-Object {$searchResults.Add($idNumber, $_); $idNumber++ }

     if($searchResults.Keys.Count -eq 0){

        Write-Host "`nNo results found for '$($adUser)'."

    }
    
    else {

        # If there were multiple matches, display them all and allow the user to choose one to display
        if($searchResults.Keys.Count -gt 1) {

            Clear-Host
            Write-Host "`nThere were $($searchResults.Keys.Count) results found for '$($adUser)':"

            while($viewSearchResults){

                # Output a table of all the names found 
                $searchResults.Keys | Select-Object @{l="ID"; e={$_}}, @{label="Name"; expression={($searchResults.$_).Name}} | Out-Host

                # Ask for an ID number to retrieve and display the full search results for that specific user
                [int32]$adUserSelection = Read-Host "Enter a user's ID to display the results for that user" 
                
                Show-ADUserData -User $searchResults[$adUserSelection] -PropertiesToShow $desiredProperties

                # Ask the user if they want to see the search results again
                $viewSearchResults = Get-YesNoResponse -Prompt "View the search results again?"
            }
        }

        # If there is only one result, simply display the first object in the hashtable
        else {
            
            Show-ADUserData -User $searchResults[0] -PropertiesToShow $desiredProperties
        }
    }
             
    $runSearch = Get-YesNoResponse -Prompt "Search again?"   


} # close main while loop

