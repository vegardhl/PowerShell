Function Get-PassordUtlopsDato
{
	 $brukere = Invoke-Command -Session $sesjonadserver `
	 -script {
	  $PwMaxDager = 
	  (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
		
	  Get-ADUser -filter `
	  {enabled -eq $true -and 
	  PasswordNeverExpires -eq $false} `
	   -Properties * |
	   Select-Object -Property "samaccountname", 
	    @{name="Utløpsdato"
	    ;Expression={$_.PasswordLastSet.AddDays($PwMaxDager)}}|
	     where {$_.Utløpsdato -ne $null}
	 }
		
	 write ($brukere | 
	 select -prop samaccountname, Utløpsdato)	
}
