

#Henter inn scriptet SokeAdBruker.ps1 slik at jeg kan nå funksjonen Find-ADBruker
#. C:\Users\vegard\Desktop\PowerShell\Oving7Oppgave2\SokeAdBruker.ps1
. C:\Users\vegard\Desktop\PowerShell\Oving7Oppgave2\SokeAdBruker.ps1

# Aktiver brukere 
Function Aktiver-AdBruker
{
    # Søk etter brukere og hent ut valgte brukere
    $brukere = Find-ADBruker
		
	if($brukere -notlike $null)
	{
	  Invoke-Command -Session $SesjonADServer -script {
        $using:brukere.objectguid | 
	    Set-ADUser -Enabled $true
	  }
	  write 'Brukerne er nå aktiverte'
    }
}
		
# Deaktiver brukere 
Function Deaktiver-AdBruker
{
    # Søk etter brukere og hent ut valgte brukere
	$brukere = Find-ADBruker
    
    write "Brukerne:  $brukere"

    <#
    $SesjonADServer = New-PSSession -ComputerName '3badrgr1-psp2' -Credential 'vegard\administrator' 
    		
	if($brukere -notlike $null) #Fjernet elseif og $Deaktiver -and
	{
	  Invoke-Command -Session $SesjonADServer -script {
	    $using:brukere.objectguid | 
		Set-ADUser -Enabled $false
	  }
	  write 'Brukerne er nå deaktiverte'
    }#>
}
