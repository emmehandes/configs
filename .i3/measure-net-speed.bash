#!/bin/bash
# Public Domain
# (someone claimed the next lines would be useful for…
#  people. So here goes: © 2012 Stefan Breunig
#  stefan+measure-net-speed@mathphys.fsk.uni-heidelberg.de)


# path to store the old results in
path="/tmp/measure-net-speed"

# grabbing data for each adapter. 
# You can find the paths to your adapters using
#  find /sys/devices -name statistics
# If you have more (or less) than two adapters, simply adjust the script here
# and in the next block. 
eth0="/sys/class/net/eth0/statistics"
wlan0="/sys/class/net/wlan0/statistics"
read eth0_rx < "${eth0}/rx_bytes" || eth0_rx=0
read eth0_tx < "${eth0}/tx_bytes" || eth0_tx=0
read wlan0_rx < "${wlan0}/rx_bytes" || wlan0_rx=0
read wlan0_tx < "${wlan0}/tx_bytes" || wlan0_tx=0

# get time and sum of rx/tx for combined display
time=$(date +%s)
rx=$(( $eth0_rx + $wlan0_rx ))
tx=$(( $eth0_tx + $wlan0_tx ))

# write current data if file does not exist. Do not exit, this will cause
# problems if this file is sourced instead of executed as another process.
if ! [[ -f "${path}" ]]; then
  echo "${time} ${rx} ${tx}" > "${path}"
  chmod 0666 "${path}"
fi

# read previous state and update data storage
read old < "${path}"
echo "${time} ${rx} ${tx}" > "${path}"

# parse old data and calc time passed
old=(${old//;/ })
time_diff=$(( $time - ${old[0]} ))

# sanity check: has a positive amount of time passed
if [[ "${time_diff}" -gt 0 ]]; then
  # calc bytes transferred, and their rate in byte/s
  rx_diff=$(( $rx - ${old[1]} ))
  tx_diff=$(( $tx - ${old[2]} ))
  rx_rate=$(( $rx_diff / $time_diff ))
  tx_rate=$(( $tx_diff / $time_diff ))

  # shift by 10 bytes to get KiB/s. If the value is larger than
  # 1024^2 = 1048576, then display MiB/s instead (simply cut off  
  # the last two digits of KiB/s). Since the values only give an  
  # rough estimate anyway, this improper rounding is negligible.

  # incoming
  rx_kib=$(( $rx_rate >> 10 ))
  if [[ "$rx_rate" -gt 1048576 ]]; then
    echo -n "D: ${rx_kib:0: -3}.${rx_kib: -3} MiB/s"
  else
    echo -n "D: ${rx_kib} KiB/s"
  fi

  echo -n "  "

  # outgoing
  tx_kib=$(( $tx_rate >> 10 ))
  if [[ "$tx_rate" -gt 1048576 ]]; then
    echo -n "U: ${tx_kib:0: -3}.${tx_kib: -3} MiB/s"
  else
    echo -n "U: ${tx_kib} KiB/s"
  fi
else
  echo -n " ? "
fi
