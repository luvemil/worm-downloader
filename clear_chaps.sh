
# Remove the chapters listed in Book.txt so they can be rebuild

for md_file in $(tail -n +6 files/book/Book.txt)
do
    echo "rm files/book/chapters/$md_file"
    rm files/book/chapters/$md_file
    sleep 0.1
done

