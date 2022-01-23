# Property-Based Testing In Elixir

This demo is based around [`StreamData v0.5.0`](https://github.com/whatyouhide/stream_data), 
an Elixir library for property-based testing and test data generation. Elixir 
version `1.13.0` is used for all examples. 

It's structured in 3 parts. Each provides it's own README for more information.
 * [`01_hello_world`](01_hello_world) shows very basic usage and setup.
 * [`02_parallel_merge_sort`](02_parallel_merge_sort) provides the main examples in the slides of the 
    presentation and compares approaches.
 * [`03_json_parser`](03_json_parser) implements a JSON-Parser as show case. It uses more advanced
    data generation for testing. First serializable data is generated, then it 
    is feed in a tokenizer that produces JSON, then whitespace between tokens is
    added. The generated JSON-string is feed into the parser. It is checked if 
    the parser matches the initial serializable data.


 For creation of this project these resources were mainly used:

 1. StreamData v0.5.0 Documentation. Retrieved January 23, 2022, from https://hexdocs.pm/stream_data/StreamData.html
 2. Hébert Fred. (2019). Property-based testing with proper, Erlang, and elixir: Find bugs before your users do. The Pragmatic Bookshelf. https://propertesting.com/
 3. Leopardi, A. (2017, October 31). Streamdata: Property-based testing and data generation (Blog Post). Retrieved January 23, 2022, from https://elixir-lang.org/blog/2017/10/31/stream-data-property-based-testing-and-data-generation-for-elixir/ 
 4. Claessen, K., &amp; Hughes, J. (2000). QuickCheck. Proceedings of the Fifth ACM SIGPLAN International Conference on Functional Programming  - ICFP '00. https://doi.org/10.1145/351240.351266 
 5. Arts, T., Hughes, J., &amp; Johansson, J. (2006). Testing telecoms software with quviq QuickCheck. Proceedings of the 2006 ACM SIGPLAN  Workshop on Erlang  - ERLANG '06. https://doi.org/10.1145/1159789.1159792 
 
