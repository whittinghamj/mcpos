<?php

$config_file = file_get_contents('/mcp/miner_config.php');

echo "JSON Array \n";

print_r($config_file);

echo "\n\n";

$config_file = json_decode($config_file, TRUE);

echo "PHP Array \n";

print_r($config_file, TRUE);