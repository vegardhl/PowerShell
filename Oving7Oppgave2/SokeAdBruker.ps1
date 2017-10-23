function Set-LinjeNummer 
{
	 param (
	  [parameter(mandatory=$true)]
	  [Object[]]$Objekt
	 )		
	
	 # Legger til linjenummer på objektet  
	 $Nummer = 1
		
	 # Gjennomgår hver rad i objekt 
	 $Objekt | ForEach-Object {
	   # Legger til linjenummer som egenskap for hver rad 
	   Add-Member -InputObject $_ -MemberType NoteProperty `
	   -Name Nummer -Value $Nummer
		
	   # Inkrementerer linjenummer
	   $Nummer++
      }
		
	 # Hvert objekt har nå et linjenummer 
	 return $objekt 
}
		
# Skriver ut alle AD brukere i innsendt objekt
Function Write-ADBruker
{
	 param($bruker)
		
	 # Legg til linjenummer 
	 Set-LinjeNummer $bruker 
		
	 Write-Host ($bruker | Format-Table `
	  -Property nummer, `
	@{expression={$_.UserPrincipalName};Label='UserName'}, `
	  name, enabled | out-string) 
	}
		
Function Find-ADBruker
{
     #Legger til verdi til sesjonen. lagt til selv.
    $SesjonADServer = New-PSSession -ComputerName '3badrgr1-psp2' -Credential 'vegard\administrator' 
     
     $Hjelp = 
	 'Søk etter brukere. Velg en eller flere brukere
	 Ved å skrive nummeret etterfulgt av komma. 
	 [f.eks. 2,5].
	 Skriv ut dette ved å skrive ?!
	 Avslutt søk ved å skrive x!
	 Når du er ferdig, skriv f!'
		
	 write $Hjelp
	
	 [object[]]$ValgteBrukere = $null
		
	 do 
	 {
	  $avslutt = $false 
	  [int]$tall = $null                
		
	  # Skriver ut valgte brukere
	  if($ValgteBrukere -notlike $null)
	  {
	   # Fjerner doble forekomster
	   $ValgteBrukere = $ValgteBrukere | 
	    Sort -Property userprincipalname -Unique
		
	   [string]$ut = $ValgteBrukere.userprincipalname
	   $ut = $ut.Replace(' ', ',')
	   Write "Du har valgt: $ut" 
	  }
		
	  $SøkeTekst = Read-Host '>'
		
	  # Sjekker søkeord 
		
	  if($SøkeTekst.Length -eq 2 -and $SøkeTekst -eq 'x!')
	  {
	   # Avslutt søk
	   Write 'Avbryter. . .' 
	   return $null 
	  }
	  elseif($SøkeTekst.Length -eq 2 `
	  -and $SøkeTekst -eq 'f!')
	  {            
		   # Returnerer valgte brukere
        #write "skriver ut valgte brukere: $ValgteBrukere"
	   return $ValgteBrukere
	  }
	  elseif($SøkeTekst.Length -eq 2 `
	  -and $SøkeTekst -eq '?!')
	  {
	   write $Hjelp 
	  }
	  # Tester om brukeren har skrevet inn tall         
	  # Hvis det er valgt kun ett objekt 
	  elseif([int32]::TryParse($SøkeTekst,[ref]$tall))
	  {
	   # Velg objekter
	   Write 'Velger ett objekt'
	   [object[]]$ValgteBrukere += $resultat | 
	    where{$_.nummer -eq $SøkeTekst}      
	  }
	  elseif($SøkeTekst.Contains(','))
	  {
	   $SøkeTekst = $SøkeTekst.Split(',') | %{$_.Trim()}            
	   [object[]]$ValgteBrukere += $resultat | 
	   where{$_.nummer -in $SøkeTekst}            
	  }
	  else
	  {
	   # Hent ut alle brukere
	   $resultat = Invoke-Command -Session $SesjonADServer `
	   -ScriptBlock {
	    Get-ADUser -Filter *
	   } 
		
	   # Finn brukere som matcher søketekst 
	   $resultat = $resultat | 
	    where {$_.userprincipalname -match $SøkeTekst}
	
	   # Skriver ut resultat  
	   if($resultat -notlike $null)
	   {
	    Write-ADBruker $resultat | out-null
	   }
	   else
	   {
	    Write 'Ingen treff i søk'
	   }            
	  }
	 }while($avslutt -eq $false)
}	
