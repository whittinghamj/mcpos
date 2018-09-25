<?php

$config_file = file_get_contents('/mcp/miner_config.php');

echo "Demo Config File \n";

print_r($config_file, true);