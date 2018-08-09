Function Get-vCenterInfo{

<#
    .NOTES
    ===========================================================================
     Crée par:    Eric Perromat
     Remerciement : William Lam (source : https://github.com/lamw/vghetto-scripts/blob/master/powershell/VCESXivSANBuildVersion.ps1)

     Organization:  VMware
     Blog:          eperromat.fr
     Twitter: 
     
     Ce script est une adaptation du script VCESXivSANBuildVersion.ps1 de William Lam à mes besoins
           
    ===========================================================================
    .DESCRIPTION
        Extraire des informations depuis un vCenter en particulier la version en fonction du numéro de Build
        Ref : https://kb.vmware.com/kb/2143838 pour le mappage
    .EXAMPLE
        Get-vCenterInfo
#>
    
    # vous devez posséder une connexion vers le vcenter passé en paramètre
    param(
        [Parameter(Mandatory=$false)][VMware.VimAutomation.ViCore.Util10.VersionedObjectImpl]$Server
    )
    
    # cf https://kb.vmware.com/kb/2143838 (Version Vcenter en fonction du numéro de Build)
    $vcenterBuildVersionMappings = @{
        "9214924"="vCenter Server 6.7 Express Patch 2a"
        "8546234"="vCenter Server 6.7.0a"
        "8217866"="vCenter Server 6.7"
        "8815520"="vCenter Server 6.5 U2b"
        "8667236"="vCenter Server 6.5 U2a"
        "8307201"="vCenter Server 6.5 U2"
        "8024368"="vCenter Server 6.5 Update 1g"
        "7515524"="vCenter Server 6.5 Update 1e"
        "7312210"="vCenter Server 6.5 Update 1d"
        "6816762"="vCenter Server 6.5 Update 1b"
        "5973321"="vCenter 6.5 Update 1"
        "5705665"="vCenter 6.5 0e Express Patch 3"
        "5318154"="vCenter 6.5 0d Express Patch 2"
        "5318200"="vCenter 6.0 Update 3b"
        "5183549"="vCenter 6.0 Update 3a"
        "5112527"="vCenter 6.0 Update 3"
        "4541947"="vCenter 6.0 Update 2a"
        "3634793"="vCenter 6.0 Update 2"
        "3339083"="vCenter 6.0 Update 1b"
        "3018524"="vCenter 6.0 Update 1"
        "2776511"="vCenter 6.0.0b"
        "2656760"="vCenter 6.0.0a"
        "2559268"="vCenter 6.0 GA"
        "4180647"="vCenter 5.5 Update 3e"
        "3721164"="vCenter 5.5 Update 3d"
        "3660016"="vCenter 5.5 Update 3c"
        "3252642"="vCenter 5.5 Update 3b"
        "3142196"="vCenter 5.5 Update 3a"
        "3000241"="vCenter 5.5 Update 3"
        "2646482"="vCenter 5.5 Update 2e"
        "2001466"="vCenter 5.5 Update 2"
        "1945274"="vCenter 5.5 Update 1c"
        "1891313"="vCenter 5.5 Update 1b"
        "1750787"="vCenter 5.5 Update 1a"
        "1750596"="vCenter 5.5.0c"
        "1623099"="vCenter 5.5 Update 1"
        "1378903"="vCenter 5.5.0a"
        "1312299"="vCenter 5.5 GA"
        "3900744"="vCenter 5.1 Update 3d"
        "3070521"="vCenter 5.1 Update 3b"
        "2669725"="vCenter 5.1 Update 3a"
        "2207772"="vCenter 5.1 Update 2c"
        "1473063"="vCenter 5.1 Update 2"
        "1364037"="vCenter 5.1 Update 1c"
        "1235232"="vCenter 5.1 Update 1b"
        "1064983"="vCenter 5.1 Update 1"
        "880146"="vCenter 5.1.0a"
        "799731"="vCenter 5.1 GA"
        "3891028"="vCenter 5.0 U3g"
        "3073236"="vCenter 5.0 U3e"
        "2656067"="vCenter 5.0 U3d"
        "1300600"="vCenter 5.0 U3"
        "913577"="vCenter 5.0 U2"
        "755629"="vCenter 5.0 U1a"
        "623373"="vCenter 5.0 U1"
        "5318112"="vCenter 6.5.0c Express Patch 1b"
        "5178943"="vCenter 6.5.0b"
        "4944578"="vCenter 6.5.0a Express Patch 01"
        "4602587"="vCenter 6.5"
        "5326079"="vCenter 6.0 Update 3b"
        "5183552"="vCenter 6.0 Update 3a"
        "5112529"="vCenter 6.0 Update 3"
        "4541948"="vCenter 6.0 Update 2a"
        "4191365"="vCenter 6.0 Update 2m"
        "3634794"="vCenter 6.0 Update 2"
        "3339084"="vCenter 6.0 Update 1b"
        "3018523"="vCenter 6.0 Update 1"
        "2776510"="vCenter 6.0.0b"
        "2656761"="vCenter 6.0.0a"
        "2559267"="vCenter 6.0 GA"
        "4180648"="vCenter 5.5 Update 3e"
        "3730881"="vCenter 5.5 Update 3d"
        "3660015"="vCenter 5.5 Update 3c"
        "3255668"="vCenter 5.5 Update 3b"
        "3154314"="vCenter 5.5 Update 3a"
        "3000347"="vCenter 5.5 Update 3"
        "2646489"="vCenter 5.5 Update 2e"
        "2442329"="vCenter 5.5 Update 2d"
        "2183111"="vCenter 5.5 Update 2b"
        "2063318"="vCenter 5.5 Update 2"
        "1623101"="vCenter 5.5 Update 1"
        "1476327"="vCenter 5.5.0b"
        "1398495"="vCenter 5.5.0a"
        "1312298"="vCenter 5.5 GA"
        "3868380"="vCenter 5.1 Update 3d"
        "3630963"="vCenter 5.1 Update 3c"
        "3072314"="vCenter 5.1 Update 3b"
        "2306353"="vCenter 5.1 Update 3"
        "1882349"="vCenter 5.1 Update 2a"
        "1474364"="vCenter 5.1 Update 2"
        "1364042"="vCenter 5.1 Update 1c"
        "1123961"="vCenter 5.1 Update 1a"
        "1065184"="vCenter 5.1 Update 1"
        "947673"="vCenter 5.1.0b"
        "880472"="vCenter 5.1.0a"
        "799730"="vCenter 5.1 GA"
        "3891027"="vCenter 5.0 U3g"
        "3073237"="vCenter 5.0 U3e"
        "2656066"="vCenter 5.0 U3d"
        "2210222"="vCenter 5.0 U3c"
        "1917469"="vCenter 5.0 U3a"
        "1302764"="vCenter 5.0 U3"
        "920217"="vCenter 5.0 U2"
        "804277"="vCenter 5.0 U1b"
        "759855"="vCenter 5.0 U1a"
        "455964"="vCenter 5.0 GA"
    }

    <# Si il n'y a pas eu de paramètre passé à la fonction alors récupération de la variable $global:DefaultVIServer 
       (dans les 2 cas vous devez posséder une connexion vers le vcenter connect-viserver) #>
    if(-not $Server){
        $Server = $global:DefaultVIServer
    }
    
    #Initialisation du résultat de la fonction
    $retour=@() 

    #Sélection des résultats
    $vcs = "" | select NomVcenter,Build,Version,OS,IP
    
    # Nom du vCenter
    $vcs.NomvCenter = $Server.Name  
    
    # Build du vCenter
    $vcs.Build = $Server.Build  
    
    # Version du vCenter
    if($vcenterBuildVersionMappings.ContainsKey($Server.Build)){
        $vcs.Version= $vcenterBuildVersionMappings[$Server.Build]  #Récupération de la version du vCenter en fonction de la Build
    }
    else{
        $vcs.Version = "Unknown" #Initialisation à Unknown de la version du vCenter si $vcenterBuildVersionMappings n'est pas à jour
    }
    
    # OS du vCenter
    $vcs.OS = $Server.ExtensionData.Content.About.OsType  
    
    # Récupération de l'adresse IP du vCenter
    $vcs.IP = ((Get-View -Id 'OptionManager-VpxSettings').setting| Where-Object { $_.Key -eq "VirtualCenter.AutoManagedIPV4"}).Value

    # On génère le retour ...
    $retour += $vcs

    $retour
}

