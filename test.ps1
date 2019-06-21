$s = get-service wuauserv
$s | Stop-Service -WhatIf