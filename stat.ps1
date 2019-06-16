$list = New-Object System.Collections.ArrayList($null)

foreach($file in (Dir *.sys)) {
    $subject = (Get-AuthenticodeSignature -FilePath $file).SignerCertificate.Subject
    $signer = ($subject | Select-String -Pattern "CN=([^`",]+|`"[^`"]*`")").Matches[0].Groups[1]
    $hash = Get-FileHash $file -Algorithm SHA256
    $desc = $file.VersionInfo.FileDescription
    $obj = New-Object PSObject
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Name -Value ($file.Name -replace "_[0-9a-f]{64}", "")
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Signer -Value $signer
    Add-Member -InputObject $obj -MemberType NoteProperty -Name Description -Value $desc
    Add-Member -InputObject $obj -MemberType NoteProperty -Name SHA256 -Value $hash.Hash
    $list += $obj
}

$list | out-string -width 4096 