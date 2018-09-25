<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('error_reporting', E_ALL); 

$config_file_raw = file_get_contents('/mcp/miner_config.php');

echo "JSON Array \n";

print_r($config_file_raw);

echo "\n\n";

$config_file = json_decode($config_file_raw, true);

echo "PHP Array \n";

print_r($config_file);