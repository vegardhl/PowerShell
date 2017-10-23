#Henter inn scriptet SokeAdBruker.ps1 slik at jeg kan nå funksjonen Find-ADBruker
. C:\Users\vegard\Desktop\PowerShell\Oving7Oppgave2\SokeAdBruker.ps1

Function Remove-AdBruker
{
	 # Søk etter brukere og hent ut valgte brukere
	 $brukere = Find-ADBruker
		
	 if($brukere -notlike $null)
	 {
	  Invoke-Command -Session $SesjonADServer -ScriptBlock {
	   $using:brukere.objectguid | 
	    Remove-ADUser
	  }
	  write 'Brukerne er nå slettet'
	 }
}
