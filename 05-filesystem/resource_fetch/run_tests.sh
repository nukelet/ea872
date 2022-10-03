WEBSERVER_DIR=$(pwd)/tests
while IFS='' read -r testcase; do
    echo "*** running test $testcase ***";
    echo "";
    ./resource_fetch $WEBSERVER_DIR $testcase;
    echo "";
done < tests/test_cases.txt;