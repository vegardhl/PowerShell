Function Get-AdBrukerGruppe
{
	 Write-Host "Henter brukere. . ." -ForegroundColor Cyan 
		
	 $Brukere = Invoke-Command -Session $sesjonadserver `
	 -script {
	  Get-ADUser -filter *
	 }
		
	 # Skriv ut brukere 
	 write $brukere 
		
	 do
	 {
	  # Velg bruker 
	  $inndata = Read-Host `
	  -Prompt "Velg en bruker ved å skrive samaccountname"
		
	  # Valider valg 
	  $valg = $brukere | 
	   where {$_.samaccountname -eq $inndata}
	 }until($valg -ne $null)
		
	 # Hent brukerens grupper 
	 $gruppe = Invoke-Command -Session $sesjonadserver `
	 -script {
	  Get-ADPrincipalGroupMembership `
	  -identity $using:valg.samaccountname
	 }
		
	 # Rensk skjerm
	 clear-host 
	
	 # List ut grupper 
	 write $gruppe 
		
	 # Trykk en tast for å gå tilbake
	 pause 
}
