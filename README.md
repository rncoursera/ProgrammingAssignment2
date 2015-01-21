### Introduction

This file implements 2 functions that provide caching functionality 
of inverse matrice.
To test the code you need the following:

1.   Create an invertible matrix
2.   make the matrix cachable using `makeCacheMatrix`
3.   calling `cacheSove` which return inverse matrix.

To create an invertible 9x9  matrix type the following in R console:

-   m <- matrix(sample.int(15, size = 9*9, replace = TRUE), nrow = 9, ncol = 9)

To make the newly created 9x9 matrix cachable type the following:

-   m1 <- makeCacheMatrix(m)

To retrieve the inverse matrix type the following:

-   im1 <- cacheSolve(m1)

### Example: Caching inverse of a Matrix
Here we show typical R console output from the matrix creation to getting 
cached data from cacheSolve function.

> m <- matrix(sample.int(15, size = 9*9, replace = TRUE), nrow = 9, ncol = 9)

> m1 <- makeCacheMatrix(m)

> im1 <- cacheSolve(m1)

> im2 <- cacheSolve(m1)

"getting cached data""

As you can see to get the message "getting cached data" you need to call at 
least twice cacheSolve() function on the same matrix variable. The first time 
the inverse matrix is created the second and following times the cacheSolve
function returned the cache inverse matrix without recomputing it.

### Description of the code

The code is made of 2 functions.

1. makeCacheMatrix
2. cacheSolve

The first function, `makeCacheMatrix` creates a variable which contains a set
of fucntions to manipulate its content.

1.  set the value of a matrix
2.  get the value of a matrix
3.  set the value of inverse matrix
4.  get the value of inverse matrix
5.  ls, optional function to understand the scoping of the variable. See Notes

<!-- -->


        makeCacheMatrix <- function(x = matrix()) {
                # assigned inverse matrix to NULL
                m <- NULL
                # set function inserve matrix back to NULL
                set <- function(y) {
                        x <<- y
                        m <<- NULL
                }
                # get current matrix passed to the function
                get <- function() x
                # compute and assign inverse matrix to m
                setinverse <- function(solve) m <<- solve
                # return inverse matrix
                getinverse <- function() m
                # assign ls in the current variable environment
                ls <- function() ls(environment()) 
                # list all function reassigned for this object
                list(set = set, 
                     get = get,
                     setinverse = setinverse,
                     getinverse = getinverse,
                     ls = ls)
        }

The second function `cacheSolve` calculates the inverse of a matrix. The cacluation
happens only once per variable. The only first time it has to be computed.
Following calls to cacheSolve() function will return the stored inverse matrix,
by then saving computing power on the same matrix.

        cacheSolve <- function(x, ...) {
                ## Return a matrix that is the inverse of 'x'
                m <- x$getinverse()
                # If inverse matrix is already computed 
                if (!is.null(m)) {
                        # show a message that we use the cache
                        message("getting cached data")
                        # return already computed inverse matrix
                        return (m)
                }
                # Inverse never computed so far. Get the matrix to inverse
                data <- x$get()
                # Inverse the matrix using the solve function
                m <- solve(data, ...)
                # set the result of inverse matrix for later use
                x$setinverse(m)
                # return the inverse matrix to the caller
                m
        }

### Notes
To understand better the scoping in R `ls` function has been added into 
`makeCacheMatrix` function.
You can list  variables in the global environment by typing `ls()`. If you 
source the code and execute few calls mentionned before a typical output of 
ls() would be:

> ls()
[1] "cacheSolve"    "im1"       "im2"     "m"     "m1"        "makeCacheMatrix"

Now we can list the environment part of the m1 varialbe by typing `ls(m1)`. It would look like this

> ls(m1)
[1] "get"     "getinverse" "ls"    "set"    "setinverse"

Where you can see all functions within the scope of m1 environment.

### Conclusion

Caching can be made on any type of variable operation, when the operation is
costly. The computation happens only once. As long as the variable is kept 
in the environment, calling the caching function will return the stored 
data starting from the second call.
