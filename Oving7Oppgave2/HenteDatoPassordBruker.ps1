Function Get-PassordUtlopsDato
{
    
     #Legger til verdi til sesjonen. lagt til selv.
     $sesjonadserver = New-PSSession -ComputerName '3badrgr1-psp2' -Credential 'vegard\administrator'  

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
