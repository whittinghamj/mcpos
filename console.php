<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('error_reporting', E_ALL); 

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
console_output("System Uptime: " . $system['uptime']);
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

if($task == 'miner_restart')
{
	console_output("Restarting the miner process.");
	exec("sudo php -q /mcp/console.php miner_stop");
	exec("sudo php -q /mcp/console.php miner_start");
}

if($task == 'miner_start')
{
	$existing_miners = exec("ps aux | grep '/mcp/miners' | awk '{print $2}' | wc -l");

	// echo $existing_miners . " processes detected \n";

	if($existing_miners > 2){
		console_output("Miner is already running, existing.");
		die();
	}else{
		// exec("sudo kill $(ps aux | grep 'pause_miner.sh' | awk '{print $2}') > /dev/null 2>&1");

		console_output("Starting miner...");

		console_output("");

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

		console_output("Miner started.");

		// get latest config file reading
		$config_file_raw = file_get_contents('/mcp/miner_config.php');

		$config_file = json_decode($config_file_raw, true);

		console_output('sudo nohup '.$config_file['gpu_miner_cmd'].' > /mcp/logs/miner.log 2>&1 </dev/null & ');
		exec('sudo nohup '.$config_file['gpu_miner_cmd'].' > /mcp/logs/miner.log 2>&1 </dev/null & ');
	}
}

if($task == 'miner_stop')
{
	console_output("Killing all miner processes.");
	exec("sudo kill $(ps aux | grep 'miners' | awk '{print $2}') > /dev/null 2>&1");
	// exec("sudo kill $(ps aux | grep 'start_mining.sh' | awk '{print $2}') > /dev/null 2>&1");
	// exec("sudo kill $(ps aux | grep '.php' | awk '{print $2}') > /dev/null 2>&1");

	console_output("Removing old lock files.");
	exec("rm -rf /mcp/*.loc");

	console_output("Wiping mining log files..");
	exec("echo '' > /mcp/logs/mining.logs 2>&1");

	console_output("Running pause script to stop miner auto starting..");
	exec('sudo nohup sh /mcp/pause_miner.sh &');

	console_output("Done.");
}

if($task == 'miner_hashrate')
{
	$hashrate = exec("sh /mcp/stats.sh");

	if(!empty($hashrate))
	{
		$hashrate_bits = explode(" ", $hashrate);

		$hashrate = $hashrate_bits[0] . ' ' . $hashrate_bits[1];

		console_output("Hashrate: " . $hashrate);
	}else{
		exec("sudo php -q /mcp/console.php miner_stop");
		exec("sudo php -q /mcp/console.php miner_start");
		console_output("ERROR: No hashrate detected, restarting miner process.");
	}
}

if($task == 'miner_sanity')
{
	$hashrate = exec("sh /mcp/stats.sh");

	if(!empty($hashrate))
	{
		console_output("Miner is running as expected.");
	}else{
		exec("sudo php -q /mcp/console.php miner_stop");
		console_output("ERROR: No hashrate detected, restarting miner process.");
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

	console_output($api_url."/api/?key=".$system['api_key']."&c=site_jobs&miner_id=".$system['miner_id']);

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
						exec("sudo reboot");
					}

					if($miner_job['job'] == 'pause_miner')
					{
						console_output('Pausing Miner');

						$data_string = json_encode($miner_job['id']);

						console_output($api_url."/api/?key=".$system['api_key']."&c=site_job_complete");

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

						// killlock
						killlock($lockfile);

						// code for pausing miner
						exec('sudo nohup sh /mcp/pause_miner.sh &');

					}

					if($miner_job['job'] == 'unpause_miner')
					{
						console_output('UN-Pausing Miner');

						// code for restarting miner
						exec("sudo kill $(ps aux | grep 'pause_miner.sh' | awk '{print $2}') > /dev/null 2>&1");

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
					}

					if($miner_job['job'] == 'update_miner_config')
					{
						console_output('Updating Miner Config');
						console_output($api_url."/api/?key=".$system['api_key']."&c=miner_gpu_get_config&miner_id=".$system['miner_id']);

						// code for updating miner config

						$miner_config_raw = file_get_contents($api_url."/api/?key=".$system['api_key']."&c=miner_gpu_get_config&miner_id=".$system['miner_id']);
						$miner_config = json_decode($miner_config_raw, true);

						$config_file = "<?php";
						$config_file .= "\n";
						$config_file .= var_export($miner_config, true);

						// write json array
						file_put_contents('/mcp/miner_config.php', $miner_config_raw, true);

						// write php array
						// file_put_contents('/mcp/miner_config.php', $config_file, true);

						// print_r($miner_config);

						exec("sudo kill $(ps aux | grep 'pause_miner.sh' | awk '{print $2}') > /dev/null 2>&1");

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

						exec("sudo php -q /mcp/console.php miner_restart");

						// print_r($result);
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

	$hashrate = exec("sh /mcp/stats.sh");

	$hashrate_bits = explode(" ", $hashrate);

	$hashrate = $hashrate_bits[0];

	$miner['miner_id']		= $system['miner_id'];
	$miner['site_id']		= $system['site_id'];
	$miner['ip_address']	= $system['ip_address'];
	$miner['type']			= 'gpu';
	$miner['hashrate']		= $hashrate;
	$miner['uptime']		= $system['uptime'];

	$check_for_nvidia = exec('lspci | grep VGA | grep NVIDIA | wc -l');
	$check_for_ati = exec('lspci | grep VGA | grep ATI | wc -l');

	if($check_for_nvidia > 0){
		$miner['hardware'] = 'nvidia_gpu';
	}elseif($check_for_ati > 0){
		$miner['hardware'] = 'ati_gpu';
	}

	foreach(range(0, $system['gpus']['total'], 1) as $gpu_id){

		if($check_for_nvidia > 0){
			// get nvidia card details
			$gpu_name = exec('nvidia-smi -i '.$gpu_id.' --query-gpu=name --format=csv,noheader');
			if($gpu_name == 'No devices were found')
			{
				break;
			}

			$gpu_temp = exec('nvidia-smi -i '.$gpu_id.' --query-gpu=temperature.gpu --format=csv,noheader');

			$gpu_fan_speed = exec('nvidia-smi -q --gpu='.$gpu_id.' |grep Fan|cut -c 38-50|grep -o \'[0-9]*\'');
			
			echo "GPU NAME: " . $gpu_name . "\n";

			$miner['gpu_info'][$gpu_id]['name'] 		= $gpu_name;
			$miner['gpu_info'][$gpu_id]['temp'] 		= $gpu_temp;
			$miner['gpu_info'][$gpu_id]['fan_speed'] 	= $gpu_fan_speed;
		}elseif($check_for_ati){
			// get ati card details
		}else{
			// no cards found
		}
		
	}

	if(empty($hashrate)){
		$miner['miner_status'] = 'not_mining';
	}else{
		$miner['miner_status'] = 'mining';
	}

	$miner['software_version'] = $version;

	print_r($miner);

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

