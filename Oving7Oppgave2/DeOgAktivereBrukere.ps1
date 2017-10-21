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
		
	elseif($Deaktiver -and $brukere -notlike $null)
	{
	  Invoke-Command -Session $SesjonADServer -script {
	    $using:brukere.objectguid | 
		Set-ADUser -Enabled $false
	  }
	  write 'Brukerne er nå deaktiverte'
    }
}
