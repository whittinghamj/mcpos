#!/bin/sh

JSON_CONFIG=$(cat /mcp/miner_config.php);
MINER_NAME=`echo "$JSON_CONFIG" | jq -r .gpu_miner_software_folder`

MINER_PATH="/mcp/miners/$MINER_NAME"

CONSOLE=`cat /mcp/logs/miner.log | sed 's/\r/\n/g' | grep -a . | tail -n 15 | aha --no-header`
# replace [space & < > " ' '] with underscore
CONSOLE=`echo "$CONSOLE" | sed 's/&nbsp;/_/g; s/&amp;/_/g; s/&lt;/_/g; s/&gt;/_/g; s/&quot;/_/g; s/&ldquo;/_/g; s/&rdquo;/_/g;'`
# remove amp
CONSOLE=`echo "$CONSOLE" | sed 's/\&//g' | tr '"' "'"`


# preprocessing
# remove BASH colors&codes && \r && empty lines && only last 30 lines
CONSOLE_SHORT_PRE=`cat /mcp/logs/miner.log | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g' | sed 's/\r/\n/g' | grep -a . | tail -n 30`


### bminer
if [ $MINER_NAME = "bminer-zec-nvidia" ]; then
   CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a " Total " | tail -n 1 | sed -e 's/.*Total \(.*\) Accepted.*/\1/'`
   echo $CONSOLE_SHORT | awk '{print $1" "$2}'
fi

### ethminer
if [ $MINER_NAME = "claymore-eth-v11.9" ]; then
   CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a " Total " | tail -n 1 | sed -e 's/.*Total \(.*\) Accepted.*/\1/'`
   echo $CONSOLE_SHORT | awk '{print $5" "$6}' | sed 's/,//g'
fi

# CZY=`echo "$MINER_PATH" | grep -i "bminer" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a " Total " | tail -n 1 | sed -e 's/.*Total \(.*\) Accepted.*/\1/'`

### ccminer-phi-anxmod-216k155
# CZY=`echo "$MINER_PATH" | grep -i "ccminer-phi-anxmod-216k155" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "[YES]" | tail -n 1 | awk '{ for (i=1;i<=NF;i++)if($i~/H\/s/) print $(i-1)" "$i }'`

### ccminer alexis78
# CZY=`echo "$MINER_PATH" | grep -i "ccminer.*alexis78" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "H/s yes!" | tail -n 1 | awk '{ print $7 }'`

### ccminer tpruvot | ccminer nevermore brian | ccminer-skunk-krnlx | suprminer
# CZY=`echo "$MINER_PATH" | grep -i "ccminer.*tpruvot\|nevermore\|ccminer-skunk-krnlx\|suprminer" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "H/s yes!" | tail -n 1 | awk '{ print $(NF-2)" "$(NF-1) }'`

### ccminer KlausT
# CZY=`echo "$MINER_PATH" | grep -i "ccminer.*klaust" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "H/s yay!" | tail -n 1 | awk '{ print $6" "$7 }'`

### ccminer Ravencoin
# CZY=`echo "$MINER_PATH" | grep -i "ravencoin" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "H/s Kraww!" | tail -n 1 | awk '{ print $7" "$8 }'`

### ethminer
# CZY=`echo "$MINER_PATH" | grep -i "ethminer" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a " Speed " | tail -n 1 | awk -F" Speed " '{ print $2 }' | awk '{ print $1" "$2 }'`

#### dstm >=0.6.1
#CZY=`echo "$MINER_PATH" | grep -i "dstm" | wc -l`
#[ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "==============" | grep "Sol" | tail -n 1 | awk '{ print $3" "$4 }'`

#### dstm 0.6.0
#CZY=`echo "$MINER_PATH" | grep -i "dstm-v0.6.0" | wc -l`
#[ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a " ========== Sol" | tail -n 1 | awk '{ print $2" "$3 }'`

### dstm-all
# CZY=`echo "$MINER_PATH" | grep -i "dstm" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a " ==========" | grep "Sol" | tail -n 1 | awk -F"Sol/s: " '{ print $2 }' | awk '{ print $1" Sols/s" }'`

### ewbf
# CZY=`echo "$MINER_PATH" | grep -i "ewbf" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "Total" | tail -n 1 | awk '{ print $4" "$5 }'`

### sgminer-gm-aceneun | sgminer-brian112358 | sgminer-msvc2015-djm34
# CZY=`echo "$MINER_PATH" | grep -i "sgminer-gm-aceneun\|sgminer-brian112358" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | sed 's/\r/\n/g' | grep -a "(avg)" | tail -n 1 | awk '{ print $2 }' | sed 's/(avg)://g'`

### tdxminer
# CZY=`echo "$MINER_PATH" | grep -i "tdxminer" | wc -l`
# if [ "$CZY" == "1" ]; then
  # CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | sed 's/\r/\n/g' | grep -a "Stats Total" | tail -n 1 | awk '{ print $7 }' | sed 's/^[ \t]*//;s/[ \t]*$//'`
  # if [ "$CONSOLE_SHORT" == "" ]; then
    # brak sekcji Total, ktora wystepuje tylko dla count(GPU)>1
    # CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | sed 's/\r/\n/g' | grep -a "Stats GPU" | tail -n 1 | awk '{ print $8 }'`
  # fi
# fi

### t-rex
# CZY=`echo "$MINER_PATH" | grep -i "t-rex-" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "\[ OK \]" | tail -n 1 | awk -F "\[ OK \]" '{ print $2 }' | awk '{ print $3" "$4 }'`

### lolminer
# CZY=`echo "$MINER_PATH" | grep -i "lolminer" | wc -l`
# if [ "$CZY" == "1" ]; then
  # CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | sed 's/\r/\n/g' | grep -a "^Average speed" | tail -n 1 | awk -F"Total: " '{ print $2 }' | sed 's/^[ \t]*//;s/[ \t]*$//'`
  # if [ "$CONSOLE_SHORT" == "" ]; then
    # brak sekcji Total, ktora wystepuje tylko dla count(GPU)>1
    # CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | sed 's/\r/\n/g' | grep -a "^Average speed" | tail -n 1 | awk '{ print $4" "$5 }'`
  # fi
# fi

### xmr
# CZY=`echo "$MINER_PATH" | grep -i "xmr-stak" | wc -l`
# if [ "$CZY" == "1" ]; then
  # screen -S miner -X stuff "h" 1>/dev/null 2>/dev/null; sleep 1
  # CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "Totals (ALL)" | tail -n 1 | awk '{ print $3" "$6 }'`
# fi

### xmrig
# CZY=`echo "$MINER_PATH" | grep -i "xmrig" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "speed" | tail -n 1 | awk '{ print $5" "$8 }'`

### z-enemy-v1.0.9a|1.10
# CZY=`echo "$MINER_PATH" | grep -i "z-enemy" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "Shares" | grep -a "H/s" | tail -n 1 | awk '{ print $10 }' | tr -d ","`

### z-enemy-1.0.8
# CZY=`echo "$MINER_PATH" | grep -i "z-enemy-v1.08" | wc -l`
# [ "$CZY" == "1" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | grep -a "H/s - OK" | tail -n 1 | awk '{ print $10 }'`



# if empty, get last line
# [ "$CONSOLE_SHORT" == "" ] && CONSOLE_SHORT=`echo "$CONSOLE_SHORT_PRE" | tail -n 2 | sed 's/\&//g'`


# find errors:
# CUDA9.1 error
# z-enemy: Unable to query number of CUDA devices!
# ?
# ?

# xmr-stak: wrong vendor driver
# CZY=`echo "$CONSOLE" | grep -ai "Unable to query number of CUDA devices\|does not support CUDA\|driver version is insufficient\|wrong vendor driver" | wc -l`
# if [ "$CZY" -ge 1 ]; then
  # CONSOLE_SHORT="See console"
  # CONSOLE=$CONSOLE"\n<span style='color:red;'><b>!!! Please download newest SimpleMiningOS image in order to use this miner !!!</b></span>"
# fi


# filter out special characters
CONSOLE=`echo "$CONSOLE" | tr -d '\001'-'\011''\013''\014''\016'-'\037''\200'-'\377'`
CONSOLE_SHORT=`echo "$CONSOLE_SHORT" | tr -d '\001'-'\011''\013''\014''\016'-'\037''\200'-'\377'`
# make sure lines are not too long
#CONSOLE_SHORT=`echo "$CONSOLE_SHORT" | head -c 30`
CONSOLE_SHORT=`echo "$CONSOLE_SHORT" | awk '{ print substr($0, 1, 30) }'`


# echo $CONSOLE_SHORT