./scripts/clrit.sh -p "config|newton|error|fail|warn|running|some|normal" ./test.log

cat ./test.log | ./scripts/clrit.sh -p "config|newton|error|fail|warn|running|some|normal"