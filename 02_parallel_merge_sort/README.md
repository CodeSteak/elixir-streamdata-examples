# Parallel Merge Sort

This demo shows multiple approaches to testing parallel merge sort. Each 
approach is a separate test file.

This parallel merge sort implementation has a bug that can be triggered, if two
equal values are in specific positions. 


### Running
First StreamData needs to fetched using `mix deps.get`.

Each test file can then be run using:
``` 
mix test test/<filename>
```


## A: Conventional Test

For this example shows normal testing. Four predetermined lists are sorted and 
compared to their sorted counterpart. The test passes, as the bug is not 
triggered.

Although in this example the probability to trigger the the bug manually is 
medium high, in more sophisticated systems creating test cases can be hard. 
(See this Bug in LevelDB: https://github.com/google/leveldb/issues/50 )


## B: Naive Property Based Example

This example shows a naive implementation of a property-based test. For a random
list, two indices are selected at random those elements should be in order.

This test is technically correct, but too many values are disposed. StreamData 
aborts because of this.
```
** (StreamData.FilterTooNarrowError) too many consecutive elements were filtered out.
      To avoid this:
     
       * make sure the generation [...]
```


## C: Property Based Example

In C a random list is created and all neighbors are checked for order. This 
approach works and yields minimal counter examples that trigger the bug.
```
     Failed with generated values (after 10 successful runs):
     
         * Clause:    list <- list_of(integer(), initial_size: 2)
           Generated: [-3, -4, -2, -4]
```

## D: Test Against Different Implementation

In D the result of the parallel merge sort is checked against the implementation
of `Enum.sort`. 

This is especially useful if a more complex implementation with certain 
desirable characteristics is tested against a trivial one. E.g. parallel sorting
against a simpler sequential sorting algorithm.

This also generates a similar failing counter example:
```
     Failed with generated values (after 8 successful runs):
     
         * Clause:    list <- list_of(integer())
           Generated: [-9, -4, -9, 8]
```