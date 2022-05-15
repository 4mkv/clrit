#! /bin/bash

./scripts/clrit.sh -p "config|newton|error|fail|warn|running|some|normal" ./test.log

cat ./test.log | ./scripts/clrit.sh -p "config|newton|error|fail|warn|running|some|normal"


. ./scripts/shell_utils.sh
msg "no color used"
msg "BPurple color used" "$BPurple"
msg "no color used"
echo ""
msgln "no color used"
msglnbox "red color used" "$Red"
msgln "no color used"

boxedmessagetest
_set_box_chr '-'
boxedmessagetest
_set_box_chr '_'
boxedmessagetest
_set_box_chr '*'
boxedmessagetest
_set_box_chr '~'
boxedmessagetest
_set_box_chr '─'
boxedmessagetest
