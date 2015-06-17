
The code in run_analysis.R combines data from the 'test' and 'train' sets and combines them into a single data frame. Loading the data is done using the LaF library. This is so that the the data be filtered for the words 'mean' and 'std' in the variable labels using grep as the data is loading, saving processing time.

The code then creates a new data set from the averages of of all the variables, split and organized by activity and subject.