for file in $(ls tests); do
    echo "*** $file ***";
    ./checker < tests/$file;
    echo "";
done;
