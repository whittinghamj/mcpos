<?php

include('/mcp/header.php');

$existing_miners = exec("ps aux | grep '/mcp/miners' | awk '{print $2}' | wc -l");

// echo $existing_miners . " processes detected \n";

if($existing_miners > 2){
	console_output("Miner is already running, existing.");
	die();
}else{
	console_output("Setting: DISPLAY:0");
	exec("export DISPLAY=:0");

	console_output("Setting: DISGPU_MAX_ALLOC_PERCENTPLAY:100");
	exec("export GPU_MAX_ALLOC_PERCENT=100");

	console_output("Setting: GPU_USE_SYNC_OBJECTS:1");
	exec("export GPU_USE_SYNC_OBJECTS=1");

	console_output("Setting: GPU_SINGLE_ALLOC_PERCENT:100");
	exec("export GPU_SINGLE_ALLOC_PERCENT=100");

	console_output("Setting: GPU_MAX_HEAP_SIZE:100");
	exec("export GPU_MAX_HEAP_SIZE=100");

	console_output("Setting: GPU_FORCE_64BIT_PTR:1");
	exec("export GPU_FORCE_64BIT_PTR=1");

	console_output("");
	
	console_output("Starting miner.");
	exec('sh /mcp/start_mining.sh');
}