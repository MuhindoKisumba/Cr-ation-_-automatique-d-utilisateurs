###############################################################################
# CRÉATION AUTOMATIQUE D'UTILISATEURS LOCAUX
# Auteur      : MUHINDO KISUMBA Abdiel
# Description : Crée automatiquement plusieurs utilisateurs locaux,
#               leur attribue un mot de passe, une description,
#               et les ajoute éventuellement à un groupe local.
# Exécution   : PowerShell lancé en tant qu'Administrateur.
###############################################################################

#-------------------------------
# CONFIGURATION
#-------------------------------

# Nombre d'utilisateurs à créer
$NombreUtilisateurs = 10

# Préfixe du nom des comptes
$Prefixe = "Employe"

# Description commune
$Description = "Compte créé automatiquement par PowerShell"

# Groupe local auquel ajouter les utilisateurs
# Exemples : Users, Administrators, Remote Desktop Users
$GroupeLocal = "Users"

# Mot de passe (à modifier avant utilisation en production)
$MotDePasse = ConvertTo-SecureString "Password123!" -AsPlainText -Force

#-------------------------------
# CRÉATION DES UTILISATEURS
#-------------------------------

for ($i = 1; $i -le $NombreUtilisateurs; $i++)
{
    $NomUtilisateur = "$Prefixe$i"

    # Vérifie si le compte existe déjà
    if (Get-LocalUser -Name $NomUtilisateur -ErrorAction SilentlyContinue)
    {
        Write-Warning "Le compte '$NomUtilisateur' existe déjà."
        continue
    }

    try
    {
        # Création du compte local
        New-LocalUser `
            -Name $NomUtilisateur `
            -FullName "Employé $i" `
            -Description $Description `
            -Password $MotDePasse `
            -PasswordNeverExpires `
            -AccountNeverExpires

        # Ajout au groupe local
        Add-LocalGroupMember `
            -Group $GroupeLocal `
            -Member $NomUtilisateur

        Write-Host "Utilisateur créé : $NomUtilisateur" -ForegroundColor Green
    }
    catch
    {
        Write-Host "Erreur lors de la création de $NomUtilisateur" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}

#-------------------------------
# AFFICHAGE DES UTILISATEURS CRÉÉS
#-------------------------------

Write-Host ""
Write-Host "==============================="
Write-Host "UTILISATEURS LOCAUX DISPONIBLES"
Write-Host "==============================="

Get-LocalUser |
Select-Object Name,
              Enabled,
              LastLogon,
              PasswordExpires,
              Description |
Format-Table -AutoSize

Write-Host ""
Write-Host "Création terminée."
###############################################################################