#Example script that 'Dot Sources' the SMS_SendMulitiple.ps1 script file and uses functions from that script.
#Supply your username password and path to file. ( SendFromfile.ps1 Username Password .\Messages.csv)
#The file should be a CSV with Phonenumber,Message header then a list of Number,Message pairs.

.{.\SMS_SendMulitiple.ps1} #You need to have the SMS_SendMulitiple.ps1 file in the same dir as this script. Or change the path here.

$username = $args[0]
$passord = $args[1]
$CSVFile = $args[2]

$Array_Messages = Import-Csv $CSVFile
$MSG_List = @{}
foreach($item in $Array_Messages)
{
	$MSG_OBJ = CreateMessageObjects -Receiver $item.Phonenumber.ToString() -Message_text $item.Message.ToString()
	$MSG_List.add($MSG_List.Count + 1,$MSG_OBJ)
}

$Message_XML = BuildXML -UserName $username -Password $passord -HTBL_RCV_MSG $MSG_LIST
sendSMS -XMLBLOCK $Message_XML[-1].outerxml.tostring()
