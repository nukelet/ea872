for file in $(ls tests); do
    echo "*** $file ***";
    ./command_parser < tests/$file;
    echo "";
done;
