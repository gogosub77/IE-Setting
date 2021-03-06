#OSチェック ～Windows 7より前は処理を停止
$os = [environment]::OSVersion.Version
if($os.Major -lt 6){
	Write-Output 'Windows 7以上でお使いください。'
	exit
}

#変数
$path = "HKCU:\Software\Microsoft\Internet Explorer\New Windows"
$path2 = "${path}\Allow"
$addUrl = "http://10.31.1.35"   #許可したいサイトを登録する。

#ポップアップ・ブロックをチェック、有効の場合はURLを追加
$PopupMgr = $(Get-ItemProperty -Path $Path -Name 'PopupMgr').PopupMgr
if($PopupMgr -eq 'yes' -or $PopupMgr -eq 0x00000001){
#レジストリの修正
#Set-ItemProperty -Path $path -Name 'PopupMgr' -Value 0x00000001

#許可サイトがなければ、サイトを追加
if($(Get-ItemProperty -Path $path2 -Name $addUrl).$addUrl -ne 0){
    New-ItemProperty -Path $path2 -Name $addUrl -Value 0x00000000, 0x00000000 -PropertyType binary
    }
    else{
        Write-Output "${addUrl}はすでに存在しています。"
    }
}

#信頼済みサイトに追加
