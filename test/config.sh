#!/bin/bash
set -e

testAlias+=(
	[veild:trusty]='veild'
)

imageTests+=(
	[veild]='
		rpcpassword
	'
)
