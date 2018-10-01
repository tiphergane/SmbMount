######################################################################
# Script monter les points de montages pour GitHub
# version: 2.1
# Auteur: tiphergane/meoowrwa
# Synopsis: Pour vérifier si le protocol SMBv1 est activé ou non, et modifier la configuration le cas échéant.
# Usage: ajoutez les points de montages un par un dans la foncion MountDir. Il faut utiliser le mode administrateur obligatoirement
# Si vous ne voulez ne plus avoir la question sur l'execution, dans un powershell elevé (en mode admin) tapez: Set-ExecutionPolicy Unrestricted
######################################################################

Import-Module SmbShare

Get-SmbServerConfiguration | findstr /i EnableSMB1protocol | findstr /i false | Out-Null

function ActivateSMB {
        Write-Output "Activation du protocol SMB v1" 	
        Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol
    }

function MountDir {
            Write-Output "Montage du repertoire dir$"
            New-SmbMapping -LocalPath "B:" -RemotePath "\\srv\dir$"
            #Ajoute tes autres points de montage ici
    }


if ($LASTEXITCODE -eq 0)
{
    #Si le test montre que SMBv1 est désactivé
    ActivateSMB
    MountDir
}
else
{
    #Si le test montre que SMBv1 est activé
    MountDir
}