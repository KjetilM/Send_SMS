#Example script that 'Dot Sources' the PSW_PowerShell.ps1 script file and uses functions from that script.
#Usage of this script is simple ' SendSingle.ps1 [PhoneNumber] [Message]'
Write-Host $PSScriptRoot
. .\PSW_PowerShell.ps1 #You need to have the PSW_PowerShell.ps1 file in the same dir as this script. Or change the path here.
function SendSingle
{
	param
	(
		[string]$PhoneNumber,
		[string]$Message,
		[String]$UserName,
		[String]$Password
	)
	
	$HT = @{}
	$MSG_OBJ = CreateMessageObjects -Receiver $PhoneNumber.tostring() -Message_text $Message.tostring()
	$HT.add($HT.Count + 1,$MSG_OBJ)
	
	$Message_XML = BuildXML -UserName $UserName -Password $Password -HTBL_RCV_MSG $HT
	
	sendsms -XMLBLOCK $Message_XML[-1].outerxml.tostring()
}


if ($args.count -lt 4)
{
	Write-Host 'you need to supply four arguments ( phonenumber, message ,username and password)'
	break
}

if ($args[0].tostring().Length -lt 8)
{
	Write-Host 'Phonenumber is not vallid, remeber to use countryprefix'
	break
}


Sendsingle -PhoneNumber $args[0].tostring() -Message $args[1] -UserName $args[2] -Password $args[3]