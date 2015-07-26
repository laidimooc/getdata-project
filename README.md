This script provides two function : `clean_data()` and `tidy_data()`

`clean_data()` downloads the cvs file (after a verification of its existence) make  some R magic tricks and returns a data.frame with the asked columns.

`tidy_data(v)` (v is the data.frame previously produced) write the file tidy_mean.csv which should be the searched output file and returns the "good" data.frame.

A codebook.md file is provided to do like datascientists.

The author of the files doesn't speak very well english ;-) Good Luck