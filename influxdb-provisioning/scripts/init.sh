#!/bin/bash
set -e
influx bucket create -n cisco_risport
influx bucket create -n telegraf
