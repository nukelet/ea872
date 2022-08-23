#!/bin/sh
echo "process: $0"
echo "pid: $$"
echo "associated process: $(ps -ax | grep $$ | awk '{print $5}')"
echo "ps: $(ps -ax | grep $$)"
