<?php

// error_reporting(E_ALL);
// ini_set('display_errors', 1);
// ini_set('error_reporting', E_ALL); 

$api_url = 'http://dashboard.miningcontrolpanel.com';

$system['id'] 		= file_get_contents('/mcp/config.txt');
$system['mac'] 		= file_get_contents('/mcp/mac.txt');
$system['auth']		= file_get_contents('/mcp/auth.txt');
$system['ip']		= exec('sh /mcp/lan_ip.sh');
$system['cpu_temp']	= exec("cat /sys/class/thermal/thermal_zone0/temp") / 1000;


console_output("System CPU Temp: " . $system['cpu_temp']);
console_output("System ID: " . $system['id']);
console_output("System Auth Code: " . $system['auth']);
console_output("System MAC: " . $system['mac']);
console_output("System IP: " . $system['ip']);

include('/mcp/functions.php');

function killlock(){
    global $lockfile;
	exec("rm -rf $lockfile");
}

$version = '1.2.2_alpha';

console_output("MCP OS Controller - v".$version);

$task = $argv[1];

if($task == "site_jobs")
{
	$lockfile = dirname(__FILE__) . "/console.site_jobs.loc";
	if(file_exists($lockfile)){
		console_output("site_jobs is already running. exiting");
		die();
	}else{
		exec("touch $lockfile");
	}
	
	console_output("Getting site jobs");

	$site_jobs_raw = file_get_contents($api_url."/api/?key=".$config['api_key']."&c=site_jobs");
	$site_jobs = json_decode($site_jobs_raw, true);

	if(isset($site_jobs['jobs']))
	{
		foreach($site_jobs['jobs'] as $site_job){
						
			if($site_job['job'] == 'reboot_miner')
			{
				if($site_job['miner']['hardware'] == 'ebite9plus')
				{
					console_output("Rebooting EBit E9 Plus");
					
					$loginUrl 	= 'http://'.$site_job['miner']['ip_address'].'/user/login/';
					
					$ch = curl_init();
					curl_setopt($ch, CURLOPT_URL, $loginUrl);
					curl_setopt($ch, CURLOPT_POST, 1);
					curl_setopt($ch, CURLOPT_POSTFIELDS, 'username='.$site_job['miner']['username'].'&word='.$site_job['miner']['password']);
					curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookie.txt');
					curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
					$store = curl_exec($ch);

					// get basic stats 
					curl_setopt($ch, CURLOPT_URL, 'http://'.$site_job['miner']['ip_address'].'/update/resetcgminer');
					$content = curl_exec($ch);
					$stats = json_decode($content, TRUE);
				}
				else
				{
					$cmd = 'ssh-keygen -f "/root/.ssh/known_hosts" -R '.$site_job['miner']['ip_address'];
					exec($cmd);

					$cmd = "sshpass -p".$site_job['miner']['password']." ssh -o StrictHostKeyChecking=no ".$site_job['miner']['username']."@".$site_job['miner']['ip_address']." '/sbin/reboot'";
					// console_output($cmd);
					console_output("Rebooting " . $site_job['miner']['ip_address']);
					exec($cmd);
				}
				
				$site_job['status'] = 'complete';
			}

			if($site_job['job'] == 'restart_cgminer')
			{
				$cmd = 'ssh-keygen -f "/root/.ssh/known_hosts" -R '.$site_job['miner']['ip_address'];
				exec($cmd);

				$cmd = "sshpass -p".$site_job['miner']['password']." ssh -o StrictHostKeyChecking=no ".$site_job['miner']['username']."@".$site_job['miner']['ip_address']." '/etc/init.d/cgminer.sh stop'";
				console_output("Restarting CGMiner on " . $site_job['miner']['ip_address']);
				exec($cmd);
				
				$site_job['status'] = 'complete';
			}
			
			if($site_job['job'] == 'network_scan')
			{
				$ip_ranges_raw = file_get_contents($api_url."/api/?key=".$config['api_key']."&c=site_ip_ranges");
				$ip_ranges = json_decode($ip_ranges_raw, true);

				foreach($ip_ranges['ip_ranges'] as $ip_range){
					$subnets[] = $ip_range['ip_range'];
				}

				ini_set('max_execution_time', 500);
				$port = 4028;

				function check_sub($sub, $port, $site_id)
				{
					global $config;

					$rigs = array();
					$count = 0;

					foreach($sub as $ip_range) {

						exec('fping -a -q -g '.$ip_range.'0/24 > active_ip_addresses.txt');
						$active_ip_addresses = file('active_ip_addresses.txt');

						foreach ($active_ip_addresses as $active_ip_address) {
							$active_ip_address 			= str_replace(' ', '', $active_ip_address);
							$active_ip_address 			= trim($active_ip_address, " \t.");
							$active_ip_address 			= trim($active_ip_address, " \n.");
							$active_ip_address 			= trim($active_ip_address, " \r.");

							if(@fsockopen($active_ip_address,$port,$errno,$errstr,1))
							{
								// $miner[$count]['miner_status']	= 'online';
								console_output('IP: ' . $active_ip_address . ' is online and mining.');

								$miner['site_id']		= $site_id;
								$miner['ip_address'] 	= $active_ip_address;

								$data_string = json_encode($miner);

								echo "POSTing to http://dashboard.miningcontrolpanel.com/api/?key=".$config['api_key']."&c=miner_add \n";
								
								$ch = curl_init("http://dashboard.miningcontrolpanel.com/api/?key=".$config['api_key']."&c=miner_add");                                                                      
								curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");                                                                     
								curl_setopt($ch, CURLOPT_POSTFIELDS, $data_string);                                                                  
								curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);                                                                      
								curl_setopt($ch, CURLOPT_HTTPHEADER, array(                                                                          
									'Content-Type: application/json',                                                                                
									'Content-Length: ' . strlen($data_string))                                                                       
								);                                                                                                                   

								$result = curl_exec($ch);
							}else{
								// $miner[$count]['miner_status']	= 'offline';
								console_output('IP: ' . $active_ip_address . ' is online but NOT mining.');
							}
							// $count++;
						}
					} 

					// clean the buffer
					flush();

					return $rigs;
				}

				$rigs = check_sub($subnets, $port, $ip_ranges['site']['id']);
				
				$site_job['status'] = 'complete';
			}

			if($site_job['job'] == 'update_config_file')
			{
				$cmd = 'ssh-keygen -f "/root/.ssh/known_hosts" -R '.$site_job['miner']['ip_address'];
				exec($cmd);

				console_output('Updating Miner: ' . $site_job['miner']['name']);

				if($site_job['miner']['hardware'] == 'ebite9plus')
				{
					$config_file_url = $api_url."/miner_config_files/".$site_job['miner']['id'].".txt";
					$config_file = file_get_contents($config_file_url);
					$config_file = json_decode($config_file, true);

					$miner_raw = file_get_contents($api_url."/api/?key=".$config['api_key']."&c=site_miner&miner_id=".$site_job['miner']['id']);
					$miner = json_decode($miner_raw, true);

					$config_file['pools'][0]['url'] = $config_file['pools'][0]['url'];
					$config_file['pools'][1]['url'] = $config_file['pools'][1]['url'];
					$config_file['pools'][2]['url'] = $config_file['pools'][2]['url'];

					$username 		= $miner['miners'][0]['username'];
					$password 		= $miner['miners'][0]['password'];
					$ip_address		= $miner['miners'][0]['ip_address'];
					$loginUrl 	= 'http://'.$ip_address.'/user/login/';

					$ch = curl_init();
					curl_setopt($ch, CURLOPT_URL, $loginUrl);
					curl_setopt($ch, CURLOPT_POST, 1);
					curl_setopt($ch, CURLOPT_POSTFIELDS, 'username='.$username.'&word='.$password);
					curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookie.txt');
					curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
					$store = curl_exec($ch);
					
					// post pool update
					curl_setopt($ch, CURLOPT_POST, 1);
					curl_setopt($ch, CURLOPT_POSTFIELDS, 'mip1='.$config_file['pools'][0]['url'].'&mwork1='.$config_file['pools'][0]['user'].'&mpassword1='.$config_file['pools'][0]['pass'] . '&mip2='.$config_file['pools'][1]['url'].'&mwork2='.$config_file['pools'][1]['user'].'&mpassword2='.$config_file['pools'][1]['pass'] . '&mip3='.$config_file['pools'][2]['url'].'&mwork3='.$config_file['pools'][2]['user'].'&mpassword3='.$config_file['pools'][2]['pass']);
					curl_setopt($ch, CURLOPT_COOKIEJAR, 'cookie.txt');
					curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
					$store = curl_exec($ch);

					curl_setopt($ch, CURLOPT_URL, 'http://'.$ip_address.'/Cgminer/CgminerConfig');
					$content = curl_exec($ch);
					$stats = json_decode($content, TRUE);

					// restart cgminer
					curl_setopt($ch, CURLOPT_URL, 'http://'.$ip_address.'/update/resetcgminer');
					$content = curl_exec($ch);
					$stats = json_decode($content, TRUE);

				}
				elseif($site_job['miner']['hardware'] == 'antminer-s9'){
					echo "Hardware: Bitmain Antminer S9 \n";
					echo "Downloading: ".$api_url."/miner_config_files/".$site_job['miner']['id'].".conf \n";
					shell_exec("sshpass -p".$site_job['miner']['password']." ssh -o StrictHostKeyChecking=no ".$site_job['miner']['username']."@".$site_job['miner']['ip_address']." 'rm -rf /config/bmminer.conf; wget -O /config/bmminer.conf ".$api_url."/miner_config_files/".$site_job['miner']['id'].".txt; /etc/init.d/bmminer.sh restart >/dev/null 2>&1;'");
				}
				else
				{				
					if($site_job['miner']['hardware'] == 'antminer-s9'){
						shell_exec("sshpass -p".$site_job['miner']['password']." ssh -o StrictHostKeyChecking=no ".$site_job['miner']['username']."@".$site_job['miner']['ip_address']." 'rm -rf /config/bmminer.conf; wget -O /config/bmminer.conf ".$api_url."/miner_config_files/".$site_job['miner']['id'].".txt; /etc/init.d/bmminer.sh restart >/dev/null 2>&1;'");
					}else{
						// update cgminer.conf
						shell_exec("sshpass -p".$site_job['miner']['password']." ssh -o StrictHostKeyChecking=no ".$site_job['miner']['username']."@".$site_job['miner']['ip_address']." 'rm -rf /config/cgminer.conf; wget -O /config/cgminer.conf ".$api_url."/miner_config_files/".$site_job['miner']['id'].".txt; /etc/init.d/cgminer.sh restart >/dev/null 2>&1;'");

						// update network.conf
						// shell_exec("sshpass -p".$site_job['miner']['password']." ssh -o StrictHostKeyChecking=no ".$site_job['miner']['username']."@".$site_job['miner']['ip_address']." 'rm -rf /config/network.conf; wget -O /config/network.conf ".$api_url."/miner_config_files/".$site_job['miner']['id']."_network.txt; /etc/init.d/network.sh'");
					}
				}
				
				$site_job['status'] = 'complete';
			}

			if($site_job['job'] == 'pause_miner')
			{
				$cmd = 'ssh-keygen -f "/root/.ssh/known_hosts" -R '.$site_job['miner']['ip_address'];
				exec($cmd);

				console_output('Pausing Miner: ' . $site_job['miner']['name']);

				if (strpos($site_job['miner']['hardware'], 'antminer') !== false) {
				    shell_exec("sshpass -p".$site_job['miner']['password']." ssh -o StrictHostKeyChecking=no ".$site_job['miner']['username']."@".$site_job['miner']['ip_address']." 'rm -rf /config/pause_antminer.sh; wget -O /config/pause_antminer.sh ".$api_url."/controller/pause_antminer.sh; nohup sh /config/pause_antminer.sh >/dev/null 2>&1;'");
				}
				
				$site_job['status'] = 'complete';
			}

			if($site_job['job'] == 'unpause_miner')
			{
				$cmd = 'ssh-keygen -f "/root/.ssh/known_hosts" -R '.$site_job['miner']['ip_address'];
				exec($cmd);

				console_output('UN-Pausing Miner: ' . $site_job['miner']['name']);

				if (strpos($site_job['miner']['hardware'], 'antminer') !== false) {
				    shell_exec("sshpass -p".$site_job['miner']['password']." ssh -o StrictHostKeyChecking=no ".$site_job['miner']['username']."@".$site_job['miner']['ip_address']." 'kill -9 $(pgrep -f pause)'");
				}
				
				$site_job['status'] = 'complete';
			}

			$job['id']		= $site_job['id'];
			
			if($site_job['status'] == 'complete')
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

				$result = curl_exec($ch);
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
