#Henter inn scriptet NyAdBruker slik at jeg kan nå funksjonen set-Brukernavn
. .\Desktop\PowerShell\Oving7Oppgave2\NyAdBruker.ps1

Function New-ADBrukerCSV 
{
		#Legger til verdi til sesjonen. lagt til selv.
      $SesjonADServer = New-PSSession -ComputerName '3badrgr1-psp2' -Credential 'vegard\administrator' 
 do {
	  # Dialogboks for å åpne CSV-fil 
	  $csvFil = New-Object System.Windows.Forms.OpenFileDialog
	  $csvFil.Filter = 
	  "csv files (*.csv)|*.csv|txt files (*.txt)|"+
	  "*.txt|All files (*.*)|*.*"
	  $csvFil.Title = 
	  "Åpne opp CSV fil som inneholder brukere"
	  $csvFil.ShowDialog()
 }until ($csvFil.FileName -ne "")
		
	 # Importer brukere fra CSV
	 $brukere = Import-Csv $csvFil.FileName -Delimiter ";"
	 write 'csv importert'
		
 # Gå igjennom alle brukere 
 foreach ($bruker in $brukere) {
		
	  # Konvert passord over til sikker tekst 
	  $passord = ConvertTo-SecureString $bruker.Passord `
	   -AsPlainText -Force 
	  # Hent ut etternavn 
	  $etternavn = $bruker.Etternavn 
	  # Hent ut fornavn 
	  $fornavn = $bruker.Fornavn 
	  # Hent ut epost 
	  $epost = $bruker.Epost 
	  # Hent ut OU-sti 
	  $OU = $bruker.OU 
		
	  # Sett et unikt brukernavn 
	  $brukernavn = Set-Brukernavn $fornavn $etternavn 
	  # Ta bort mellomrom ol. 
	  $brukernavn = $brukernavn.Trim() 
	  # Opprett fullt navn ut fra fornavn og etternavn 
	  $fulltNavn = "$fornavn $etternavn"
        
        		
	  # Opprett bruker 
	  Invoke-Command -Session $SesjonADServer -ScriptBlock {
	   Try {
		  New-ADUser `
		  -SamAccountName $using:brukernavn `
		  -UserPrincipalName $using:brukernavn `
		  -Name $using:fulltNavn `
		  -Surname $using:etternavn `
		  -AccountPassword $using:passord `
		  -ChangePasswordAtLogon $using:true `
		  -EmailAddress $using:epost `
		  -Enabled $true
		
		  Write "Brukeren $using:brukernavn er opprettet" `
		  -Foreground Green
		   }catch{
		    Write-Host $_.Exception.Message 
		   }
	    }
 }
}
