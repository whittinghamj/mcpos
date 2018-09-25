<?php

$config_file = file_get_contents('/mcp/miner_config.php', true);
$config_file = json_decode($config_file, true);

echo "Demo Config File \n";

print_r($config_file, true);