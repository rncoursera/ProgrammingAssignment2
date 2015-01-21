## How to use this interface.
## First you have to create a matrix that is inversible
##
## Here is how to create a 9x9 square matrix filled with random numbers.
## m <- matrix(sample.int(15, size = 9*9, replace = TRUE), nrow = 9, ncol = 9)
## To guaranty it is inversable test it locally using solve(m)
##
## Next you have to create the inverse matrix and store it
## Each matrix created will contains their own functions set to access the data
## To make a cachable matrix type the following:
## m1 <- makeCacheMatrix(m)
## m1 object is created in the global environment you can verify that
## using ls(). See below
## [1] "m"     "m1"   "makeCacheMatrix"     "cacheSolve"
##
## In the function we assign m to the inverse matrix and a set of functions
## get, set, setinverse, getinverse and ls
## To note that at this point the inverse matrix doesn't exist yet.
## ls is just for debugging and understanding and it not necessary to cache
## inverse matrix. But now you have m1 cachable object call ls(m1) you will 
## see the environment from the object itself. See below
## [1] "get"      "getinverse"    "set"      "setinverse"
## 
## To see the benefit of having a cachable object you have to call cacheSolve 
## function at least twice. The first time the inverse matrix is created.
## the second time and later on, the stored inverse matrix is returned.

## makeCacheMatrix create an environment with functions attached to the object
## to manipulate it. It doesn't create the inverse matrix by itself.
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

## Each matrix will have their own lexical scoping
## So if you create 2 inverse matrices m1 and m2 from the same object m
## you can verify that the inverse matrix is stored inside the inverse matrix
## itself.
## You will have to call twice on the same matrix to start getting the cache
## insverse matrix.
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

