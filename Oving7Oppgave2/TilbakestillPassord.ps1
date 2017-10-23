Function Set-AdBrukerPassord
{

     #Legger til verdi til sesjonen. lagt til selv.
     $sesjonadserver = New-PSSession -ComputerName '3badrgr1-psp2' -Credential 'vegard\administrator'     

	 # Hent brukere 
	 $brukere = Invoke-Command -Session $sesjonadserver `
	 -ScriptBlock {
	  get-aduser -filter *
	 }
		
	 # List ut brukere 
	 write ($brukere | ft -prop samaccountname, name)
		
	 do
	 {
	  # Hent inndata 
	  $inndata = read-host `
	   -Prompt "Velg bruker ved å skrive samaccountname" 
		
	  # Velg bruker 
	  $valg = $brukere | 
	   where {$_.samaccountname -eq $inndata}
	
	  # valider valg 
	 }until($valg -ne $null)
		
	 # Skriv nytt passord
	 Invoke-Command -Session $sesjonadserver -script {
	  Set-ADAccountPassword `
	  -Identity $using:valg.samaccountname -reset
	 } 
		
	 # Hvis alt gikk bra
	 if($?){
	  write-host `
	  "Passord for $($valg.samaccountname) er endret"
	 }else{
	  write-host "Noe gikk galt"
	 }
}
 
