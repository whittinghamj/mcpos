<?php

include('/mcp/header.php');

$user = exec('whoami');

if($user != 'root'){
	console_output("This script MUST be ran as the 'root' user.");
	die();
}

echo 'script running'."\n";