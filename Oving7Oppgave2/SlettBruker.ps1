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
	  write 'Brukerne er nå aktiverte'
	 }
}
