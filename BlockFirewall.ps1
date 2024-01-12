function Get-WiresharkTraffic {
    Write-Host "Observation du traffic avec Wireshark en cours ..." -ForegroundColor DarkGray
    & "D:\Program Files\Wireshark\tshark" -i 5 -a duration:30 -T fields -e ip.src > ".\Wireshark.txt"
    Write-Host "Observation du traffic avec Wireshark terminé" -ForegroundColor Green
}

function Get-UniqueIPAddress {
    param (
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    if (Test-Path $FilePath) {
        $content = Get-Content -Path $FilePath
        $uniqueIPs = $content | Select-Object -Unique | Where-Object { $_ -match '\S' }
        return $uniqueIPs
    } else {
        Write-Host "Le fichier spécifié n'existe pas : $FilePath" -ForegroundColor Yellow
        }
    
}

function Block-IPAddresses {
    param (
        [Parameter(Mandatory = $true)]
        $IPAddressList
    )

    foreach ($ip in $IPAddressList) {
        try {
            New-NetFirewallRule -DisplayName "Block $ip" -Direction Inbound -RemoteAddress $ip -Action Block -Enabled True -Description "Rule blocking traffic from $ip" -ErrorAction Stop | Out-Null
            Write-Host "Règle créée pour bloquer l'adresse IP : $ip" -ForegroundColor Green
        } catch {
            Write-Host "Une erreur s'est produite lors de la création de la règle pour l'adresse IP : $ip [$($_.Exception.Message)]" -ForegroundColor Yellow
        }
    }
}

function Clear-DuplicateFirewallRules {
    # Récupérer toutes les règles de trafic entrant du pare-feu
    $rules = Get-NetFirewallRule -Direction Inbound

    # Filtrer les règles commençant par "Block" et ayant un doublon
    $rulesToDelete = $rules | Where-Object { $_.DisplayName -like "Block*" } | Group-Object DisplayName | Where-Object { $_.Count -gt 1 }
    
    # Supprimer les doublons, en gardant une seule règle pour chaque nom qui commence par "Block"
    foreach ($ruleGroup in $rulesToDelete) {
        $rulesToRemove = $ruleGroup.Group | Select-Object -Skip 1
        foreach ($rule in $rulesToRemove) {
            Remove-NetFirewallRule -DisplayName $rule.DisplayName -ErrorAction SilentlyContinue
            Write-Host "Règle $($rule.DisplayName) supprimée."  -ForegroundColor Green
            }
    }
    Write-Host "Nettoyage terminé."
}


# --------- MAIN ---------
# Nettoyage écran de la console
Clear-Host

# Observation du traffic : prend les IP qui communiquent avec la connexion Ethernet
Get-WiresharkTraffic 

# Création des règles pare feu pour bloquer ces connexions 
Block-IPAddresses -IPAddressList (Get-UniqueIPAddress -FilePath "D:\Romain\Desktop\Wireshark.txt") 

# Suppression des règles en doublon pour garder un parefeu propre
Clear-DuplicateFirewallRules 