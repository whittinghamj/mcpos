<?php

// error_reporting(E_ALL);
// ini_set('display_errors', 1);
// ini_set('error_reporting', E_ALL);

include('/mcp/functions.php');

// vars
$api_url = 'http://dashboard.miningcontrolpanel.com';

$system['id'] 		= file_get_contents('/mcp/config.txt');
$system['mac'] 		= file_get_contents('/mcp/mac.txt');
$system['auth']		= file_get_contents('/mcp/auth.txt');
$system['ip']		= exec('sh /mcp/lan_ip.sh');
$system['cpu_temp']	= exec("cat /sys/class/thermal/thermal_zone0/temp") / 1000;


// sanity checks
$system['id'] 		= str_replace(array("\r\n", "\r", "\n", " "), '', $system['id']);
$system['mac'] 		= str_replace(array("\r\n", "\r", "\n", " "), '', $system['mac']);
$system['auth'] 	= str_replace(array("\r\n", "\r", "\n", " "), '', $system['auth']);
$system['ip'] 		= str_replace(array("\r\n", "\r", "\n", " "), '', $system['ip']);
$system['cpu_temp'] = str_replace(array("\r\n", "\r", "\n", " "), '', $system['cpu_temp']);


// print some output
console_output("System CPU Temp: " . $system['cpu_temp']);
console_output("System ID: " . $system['id']);
console_output("System Auth Code: " . $system['auth']);
console_output("System MAC: " . $system['mac']);
console_output("System IP: " . $system['ip']);


function killlock()
{
    global $lockfile;
	exec("rm -rf $lockfile");
}

$version = '1.2.2_alpha';

console_output("MCP OS Controller - v".$version);

$task = $argv[1];

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

	$miner_jobs_raw = file_get_contents($api_url."/mcpos_api/?miner_id=".$system['id']."&miner_auth=".$system['auth']."&c=miner_jobs");
	$miner_jobs = json_decode($miner_jobs_raw, true);

	if(isset($miner_jobs['jobs']))
	{
		foreach($miner_jobs['jobs'] as $miner_job){
						
			if($miner_job['job'] == 'reboot_miner')
			{
				console_output("Rebooting Miner");
				
				// code for rebooting miner
				
				$miner_job['status'] = 'complete';
			}

			if($miner_job['job'] == 'pause_miner')
			{
				console_output('Pausing Miner');

				// code for pausing miner
				
				$miner_job['status'] = 'complete';
			}

			if($miner_job['job'] == 'unpause_miner')
			{
				console_output('UN-Pausing Miner');

				// code for restarting miner
				
				$miner_job['status'] = 'complete';
			}

			$job['id']		= $miner_job['id'];
			
			if($miner_job['status'] == 'complete')
			{
				$data_string = json_encode($job);

				$ch = curl_init($api_url."/api/?key=".$config['api_key']."&c=site_job_complete");                                                                      
				curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");                                                                     
				curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);                                                                  
				curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);                                                                      
				curl_setopt($ch, CURLOPT_HTTPHEADER, array(                                                                          
					'Content-Type: application/json',                                                                                
					'Content-Length: ' . strlen($data_string))                                                                       
				);                                                                                                                   

				// $result = curl_exec($ch);
			}
		}
	}else{
		console_output("No jobs.");
	}
	
	// killlock
	killlock();
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

	// console_output('IP Address: ' . $system['ip']);
	// console_output('MAC Address: ' . $system['mac']);
	// console_output('CPU Temp: ' . $cpu_temp);

	$post_url = $api_url."/mcpos_api/?miner_id=".$system['id']."&miner_auth=".$system['auth']."&c=miner_checkin&ip=".$system['ip']."&mac=".$system['mac']."&cpu_temp=".$system['cpu_temp']."&version=".$version;
	
	console_output("POST URL: " . $post_url);

	$post = file_get_contents($post_url);
	
	// killlock
	killlock();
}
