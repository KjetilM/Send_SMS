Param
	(
		[Parameter(mandatory = $true)][string]$PhoneNumber,
		[Parameter(mandatory = $true)][string]$Message,
		[Parameter(mandatory = $true)][String]$UserName,
		[Parameter(mandatory = $true)][String]$Password,
		[String]$Sender,
		[String]$Url = 'https://secure.pswin.com/XMLHttpWrapper/process.aspx',
		[int]$REPL
	)
#Example script that 'Dot Sources' the PSW_PowerShell.ps1 script file and uses functions from that script.
#Usage of this script is simple ' SendSingle.ps1 [Username] [Password] [PhoneNumber] [Message]'

. .\PSW_PowerShell.ps1 #You need to have the PSW_PowerShell.ps1 file in the same dir as this script. Or change the path here.
function SendSingle
{
	
	param
	(
		[string]$PhoneNumber,
		[string]$Message,
		[String]$UserName,
		[String]$Password,
		[String]$Sender,
		[String]$Url,
		[int]$REPL
	)
	
	$HT = @{}
	$MSG_OBJ = CreateMessageObjects -Receiver $PhoneNumber.tostring() -Message_text $Message.tostring() -Sender $Sender.tostring() -REPL $REPL
	$HT.add($HT.Count + 1,$MSG_OBJ)
	
	$Message_XML = BuildXML -UserName $UserName -Password $Password -HTBL_RCV_MSG $HT 
	
	sendsms -XMLBLOCK $Message_XML[-1].outerxml.tostring() -Debug $true -Url $Url 
}
Write-host $PhoneNumber
Write-host $Message
Write-host $UserName
Write-host $Password




#[XML]$Response = Sendsingle -PhoneNumber $args[0].tostring() -Message $args[1] -UserName $args[2] -Password $args[3] -Sender $args[4].tostring() -REPL $args[5].tostring()
[XML]$Response = Sendsingle -PhoneNumber $PhoneNumber -Message $Message -UserName $UserName -Password $Password -Sender $Sender -REPL $REPL -Url $Url
Write-Host $Response.InnerXml.ToString() 
