<?php

// error_reporting(E_ALL);
// ini_set('display_errors', 1);
// ini_set('error_reporting', E_ALL);

include('/mcp/functions.php');

$user = exec('whoami');

if($user != 'root'){
	console_output("This script MUST be run as the 'root' user.");
	die();
}

// vars
$api_url = 'http://dashboard.miningcontrolpanel.com';
$system['api_key'] 			= file_get_contents('/mcp/site_key.txt');
$system['api_key'] 			= str_replace(array("\r\n", "\r", "\n", " "), '', $system['api_key']);


if($system['api_key'] == '' || $system['api_key'] == '0'){
	console_output("Please edit /mcp/site_key.txt and enter your MCP site API key.");
	die();
}


$system['site']				= @file_get_contents($api_url . '/api/?key='.$system['api_key'].'&c=home');
$system['site']				= json_decode($system['site'], true);		
$system['site_id'] 			= $system['site']['site']['id'];
$system['miner_id'] 		= file_get_contents('/mcp/config.txt');
$system['ip_address']		= exec('sh /mcp/lan_ip.sh');
$system['uptime']			= exec("uptime | awk -F'( |,|:)+' '{print $6,$7",",$8,\'hours,\',$9,\'minutes.\'}'");

$system['miner_id'] 		= str_replace(array("\r\n", "\r", "\n", " "), '', $system['miner_id']);
$system['ip_address'] 		= str_replace(array("\r\n", "\r", "\n", " "), '', $system['ip_address']);

$version = '1.2.2_alpha';

console_output("==============================");
console_output("MCP OS - v".$version);
console_output("==============================");
console_output("");