<?php

include('/mcp/header.php');

// get GPU info
$system['gpus']['total']				= exec('nvidia-smi -L | grep "^GPU " | wc -l');
foreach(range(0, $system['gpus']['total'], 1) as $gpu_id){
	$gpu_name = exec('nvidia-smi -i '.$gpu_id.' --query-gpu=name --format=csv,noheader');
	if($gpu_name == 'No devices were found')
	{
		break;
	}
	$gpu_temp = exec('nvidia-smi -i '.$gpu_id.' --query-gpu=temperature.gpu --format=csv,noheader');
	$gpu_fan_speed = exec('nvidia-smi -q --gpu='.$gpu_id.' |grep Fan|cut -c 38-50|grep -o \'[0-9]*\'');
	
	console_output("GPU ID: " . $gpu_id);
	console_output("GPU Name: " . $gpu_name);
	console_output("GPU Temp: " . $gpu_temp . "C");
	console_output("GPU Fan: " . $gpu_fan_speed . "%");
}

console_output("==============================");

// print some output
console_output("MCP Site ID: " . $system['site']['site']['id']);
console_output("MCP Site Key: " . $system['api_key']);
// console_output("System CPU Temp: " . $system['cpu_temp']);
console_output("Miner ID: " . $system['miner_id']);
console_output("IP Address: " . $system['ip_address']);
console_output("==============================");


function killlock($lockfile)
{
	exec("rm -rf $lockfile");
}


$task = $argv[1];

if($task == 'miner_start')
{
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
}

if($task == "miner_jobs")
{
	$lockfile = dirname(__FILE__) . "/console.miner_jobs.loc";
	if(file_exists($lockfile)){
		console_output("miner_jobs is already running. exiting");
		die();
	}else{
		exec("touch $lockfile");
	}
	
	console_output("Getting miner jobs");

	$miner_jobs_raw = file_get_contents($api_url."/api/?key=".$system['api_key']."&c=site_jobs&miner_id=".$system['miner_id']);
	$miner_jobs = json_decode($miner_jobs_raw, true);

	if(isset($miner_jobs['jobs']))
	{
		foreach($miner_jobs['jobs'] as $miner_job){
			
			if(isset($miner_job['miner']['id']))
			{
				if($miner_job['miner']['id'] == $system['miner_id'])
				{
					if($miner_job['job'] == 'reboot_miner')
					{
						console_output("Rebooting Miner");
						
						$data_string = json_encode($miner_job['id']);

						$ch = curl_init($api_url."/api/?key=".$system['api_key']."&c=site_job_complete");                                                                      
						curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");                                                                     
						curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);                                                                  
						curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);                                                                      
						curl_setopt($ch, CURLOPT_HTTPHEADER, array(                                                                          
							'Content-Type: application/json',                                                                                
							'Content-Length: ' . strlen($data_string))                                                                       
						);                                                                                                                   

						$result = curl_exec($ch);

						// print_r($result);

						sleep(5);

						// code for rebooting miner
						exec("sh /mcp/force_reboot.sh");
					}

					if($miner_job['job'] == 'pause_miner')
					{
						console_output('Pausing Miner');

						// code for pausing miner
					}

					if($miner_job['job'] == 'unpause_miner')
					{
						console_output('UN-Pausing Miner');

						// code for restarting miner				
					}

					$job['id']		= $miner_job['id'];
				}
			}
		}
	}else{
		console_output("No jobs.");
	}
	
	// killlock
	killlock($lockfile);
}

if($task == "miner_checkin")
{
	$lockfile = dirname(__FILE__) . "/console.miner_checkin.loc";
	if(file_exists($lockfile)){
		console_output("miner_checkin is already running. exiting");
		die();
	}else{
		exec("touch $lockfile");
	}
	
	console_output("Running Miner Checkin");

	$miner['miner_id']		= $system['miner_id'];
	$miner['site_id']		= $system['site_id'];
	$miner['ip_address']	= $system['ip_address'];
	$miner['type']			= 'gpu';

	$data_string = json_encode($miner);

	echo "POSTing to http://dashboard.miningcontrolpanel.com/api/?key=".$system['api_key']."&c=miner_add \n";
	
	$ch = curl_init("http://dashboard.miningcontrolpanel.com/api/?key=".$system['api_key']."&c=miner_add");                                                                      
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");                                                                     
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);                                                                  
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);                                                                      
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(                                                                          
		'Content-Type: application/json',                                                                                
		'Content-Length: ' . strlen($data_string))                                                                       
	);                                                                                                                   

	$result = curl_exec($ch);

	$result = json_decode($result, TRUE);

	print_r($result);

	if($system['miner_id'] == ''){
		exec('echo ' . $result['miner_data']['id'] . ' > /mcp/config.txt');
	}

	// $post_url = $api_url."/api/?miner_id=".$system['id']."&miner_auth=".$system['auth']."&c=miner_checkin&ip=".$system['ip']."&mac=".$system['mac']."&cpu_temp=".$system['cpu_temp']."&version=".$version;
	
	// console_output("POST URL: " . $post_url);

	// $post = file_get_contents($post_url);
	
	// killlock
	killlock($lockfile);
}

