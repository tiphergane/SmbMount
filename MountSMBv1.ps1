######################################################################
# Script monter les points de montages pour GitHub
# version: 3.0
# Auteur: tiphergane/meoowrwa
# Synopsis: Pour vérifier si le protocol SMBv1 est activé ou non, et modifier la configuration le cas échéant.
# Usage: ajoutez les points de montages un par un dans la foncion MountDir. Il faut utiliser le mode administrateur obligatoirement
# Si vous ne voulez ne plus avoir la question sur l'execution, dans un powershell elevé (en mode admin) tapez: Set-ExecutionPolicy Unrestricted
######################################################################

function ActivateShare {

		Get-Module SmbShare | findstr /i smbshare | Out-Null
		if ($LASTEXITCODE -eq 0)
			{
				Import-Module SmbShare
			}
		else
			{
				#Si le test montre que SMBv1 est activé
				Write-Output "Module déjà chargé, on passe à la suite"
				start-sleep 5
			}
}

function TestSmb {

		Write-Output "Activation du protocol SMB v1, un reboot est nécessaire si le protocol n'est pas chargé" 
		Get-SmbServerConfiguration | findstr /i EnableSMB1protocol | findstr /i false | Out-Null
	
			if ($LASTEXITCODE -eq 0)
			{
				#Si le test montre que SMBv1 est désactivé
				ActivateSMB
				Write-Output "Reboot nécessaire" 
				start-sleep 5
			}
			else
			{
				#Si le test montre que SMBv1 est activé
				MountDir
				start-sleep 5
			}

}

function ActivateSMB {
        Write-Output "Activation du protocol SMB v1" 	
        Enable-WindowsOptionalFeature -Online -FeatureName smb1protocol
}

function MountDir {
            Write-Output "Montage du repertoire SRV1$"
            New-SmbMapping -LocalPath B: -RemotePath \\SRV1\FOLDER$
			start-sleep 5
			Write-Output "Montage du repertoire SRV2"
			New-SmbMapping -LocalPath M: -RemotePath \\SRV2\FOLDER2\FOLDER2.l
            #Ajoute tes autres points de montage ici
}

ActivateShare
TestSmb