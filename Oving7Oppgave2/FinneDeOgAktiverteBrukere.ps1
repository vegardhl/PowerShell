# Skriver ut alle aktive AD brukere
Function Write-AdAktivBruker
{
	$brukere = Invoke-Command -Session $SesjonADServer `
	-ScriptBlock {
	    get-aduser -filter {enabled -eq $true}
	} 
		
	write $brukere        
}
		
# Skriver ut alle deaktiverte AD brukere
Function Write-AdDeaktivertBruker
{
	$brukere = Invoke-Command -Session $SesjonADServer `
	-ScriptBlock {
		get-aduser -filter {enabled -eq $false}
	}
		
	Write $brukere
}
