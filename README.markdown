#About
A simple inverted index for a rank based search using Redis. Designed so
that tags can be searched and the documents can be returned according
to the frequencey that a given tag appears. 

#Example
    CoveSearch::Index.search("tag", "doda", 3)
Would return the top 3 Documents where doda appeared most. 

#Todo
1. Write a client that can communicate with the server. 
2. Integration with activemodel for automatic indexing
3. **DONE** Ngram search so that we can have partial matches and autocomplete
4. Fuzzy search and sematic search analysis.
