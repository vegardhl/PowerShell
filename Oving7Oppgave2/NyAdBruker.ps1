function Format-Brukernavn
{
	 # Skript av Stein Meisingseth v/ NTNU
	 param([String]$brukernavn)
	
	 #sett brukernavn til små bokstaver
	 $brukernavn=$brukernavn.ToLower()
	
	 #Erstatt æøå med eoa
	 $brukernavn=$brukernavn.replace('æ','e')
	 $brukernavn=$brukernavn.replace('ø','o')
	 $brukernavn=$brukernavn.replace('å','a')
		
	 #Returnere det formatere brukernavnet    
	 return $brukernavn
} 

$SesjonADServer = New-PSSession -ComputerName '3badrgr1-psp2' -Credential 'vegard\administrator'
		
Function Set-Brukernavn
{
	 # Skript av Stein Meisingseth v/ NTNU
	 # Modifisert av forfatter
	 param(
	  [string]$Fornavn,
	  [string]$Etternavn
	 )
		
	 # Setter midlertidig variabel til $null 
	 # slik at den ikke inneholder noe fra tidligere 
	 $midlertidigBrukernavn = $null 
	 $sjekk = $true 
		
	 # Hvis fornavn eller etternavn er på to bokstaver blir 
	 # disse to brukt i brukernavnet i stedet for tre 
	 # bokstaver 
	 if($fornavn.length -eq 2)
	 {
	  $brukernavn = $fornavn.substring(0,2) 
	 }else
	 {
	  $brukernavn = $fornavn.substring(0,3)
	 }
		
	 if($etternavn.length -eq 2)
	 {
	  $brukernavn += $etternavn.substring(0,2) 
	 }else
	 {
	  $brukernavn += $etternavn.substring(0,3)
	 }
	
	 # Telleren bli satt til en. Den skal brukes hvis 
	 # brukernavnet allerede er i bruk
	 $teller = 1
	
	 # Bruker Format-Brukernavn
	 $navn = Format-Brukernavn $brukernavn
	 $MidlertidigBrukernavn = $navn
	
	 
	 # Hent ut alle brukere
	 $finnes = Invoke-Command -Session $SesjonADServer -ScriptBlock { Get-ADUser -Filter *}
    #$finnes = Get-ADUser -Filter * #Lagt til selv
		 
	do{
	 $finnes = $finnes | 
	  where {$_.SamAccountName -eq $MidlertidigBrukernavn}
		
	 # Hvis brukernavnet ikke er i bruk 
	 if($finnes -eq $null){
	  $sjekk = $false
	  $navn = $MidlertidigBrukernavn
	 }else{
	  # Hvis det er to like brukernavn vil teller bli lagt 
	  # til slutten av brukernavnet for å skille de.
	  $MidlertidigBrukernavn = $navn + $teller 
	
	  #inkrementerer teller slik at en får et annet 
	  # brukernavn neste gang.
	  $teller +=1
	 }
    }while($sjekk -eq $true)
		
 return $navn
} 
		
# Oppretter en ny AD bruker
Function New-ADBruker
{   
	
	 # Skriv inn fornavn 
	 $fornavn = Read-Host "Skriv inn brukerens fornavn" 
	
	 # Skriv inn etternavn 
	 $etternavn = Read-Host "Skriv inn brukerens etternavn" 
	
	 # Sjekk at fornavn og etternavn ikke er for kort 
	 do
	 {
	  $err = $false
	  if($Fornavn.Length -lt 2)
	  {
	   $Fornavn = Read-Host `
	   -prompt 'Fornavnet må minst være på to bokstaver'
	   $err = $true
	  }
		
	  if($Etternavn.Length -lt 2)
	  {
	   $Etternavn = Read-Host `
	   -Prompt 'Etternavnet må være på minst to bokstaver'
	   $err = $true
	  }
	 }while($err -eq $true)
		
	 # Opprett fullt navn ut fra fornavn og etternavn 
	 $fulltNavn = "$fornavn $etternavn"  
		
	 # Skriv inn e-post 
	 $epost = Read-Host "Skriv inn brukerens e-post" 
		
	 # Sett et unikt brukernavn 
	 $brukernavn = Set-Brukernavn $fornavn $etternavn
		
	 # Ta bort mellomrom ol. 
	 $brukernavn = $brukernavn.Trim() 
		
	 # Les inn og konverter passordet over til sikker tekst 
	 $passord = Read-Host "Skriv inn brukerens passord:" `
	  -AsSecureString
	 $passord = ConvertTo-SecureString $passord `
	  -AsPlainText -Force 
		
	 # Forsøk å opprette AD bruker 
	 Invoke-Command -Session $SesjonADServer -ScriptBlock { #-Session $SesjonADServer
	  try
	  {    
	   New-ADUser  `
	   -SamAccountName $using:brukernavn `
	   -UserPrincipalName $using:brukernavn `
	   -Name $using:fulltNavn `
	   -Surname $using:etternavn `
	   -AccountPassword $using:passord `
	   -ChangePasswordAtLogon $true `
	   -EmailAddress $using:epost `
	   -Enabled $true
		
	   Write-Host "Brukeren $brukernavn er opprettet" `
	   -Foreground Green
	  
	  }catch{
	   Write-Host $_.Exception.Message -Foreground red
	  }
}
} 
