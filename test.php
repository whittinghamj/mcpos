<?php

$config_file = exec('cat /mcp/miner_config.php');

echo "Demo Config File \n";

print_r($config_file, true);