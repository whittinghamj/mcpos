<?php

include('/mcp/header.php');

$existing_miners = exec("ps aux | grep '/mcp/miners' | awk '{print $2}' | wc -l");

echo $existing_miners . " processes detected \n";

if($existing_miners > 1){
	console_output("Miner is already running, existing.");
	die();
}else{
	console_output("Starting miner.");
	exec('sh /mcp/start_mining.sh');
}