# parallelsugar

An R package to provide mclapply() syntax for Windows machines. Has no effect on other platforms.

Note, this is an update of the script formerly found at

> http://www.stat.cmu.edu/~nmv/setup/mclapply.hack.R. 

If you wish to continue using that version (for whatever reason), you can find the script at 

> http://edustatistics.org/nathanvan/setup/mclapply.hack.R

and the accompanying blog post describing its use [here](http://edustatistics.org/nathanvan/2014/07/14/implementing-mclapply-on-windows/).

## Installation 

Step 0: If you do not already have `devtools` installed, install it using the instructions [here](http://www.rstudio.com/products/rpackages/devtools/).

Step 1: Install `parallelsugar` directly from my GitHub repository using `install_github('nathanvan/parallelsugar')`.

```{r}
> library(devtools)
> install_github('nathanvan/parallelsugar')
Downloading github repo nathanvan/parallelsugar@master
Installing parallelsugar
  ... snip ...
* DONE (parallelsugar)
```

## Usage examples


### Basic Usage
On Windows, the following line will take about 40 seconds to run because by default, `mclapply` from the `parallel` package is implemented as a serial function on Windows systems.
```{r}
library(parallel) 

system.time( mclapply(1:4, function(xx){ Sys.sleep(10) }) )
##    user  system elapsed 
##    0.00    0.00   40.06 
```

If we load `parallelsugar`, the default implementation of `parallel::mclapply`, which used fork based clusters, will be overwritten by `parallelsugar::mclapply`, which is implemented with socket clusters. The above line of code will then take closer to 10 seconds. 

```{r}
library(parallelsugar)
## 
## Attaching package: ‘parallelsugar’
## 
## The following object is masked from ‘package:parallel’:
## 
##     mclapply
    
system.time( mclapply(1:4, function(xx){ Sys.sleep(10) }) )
##    user  system elapsed 
##    0.04    0.08   12.98 
```

## Use of global variables and packages

By design, `parallelsugar` approximates a fork based cluster -- every object that is within scope to the master R process is copied over to the processes on the other sockets. This implies that (i) you can quickly run out of memory and (ii) you can waste a lot of time copying over unnecessary objects hanging around in your R session. **Be warned!**

```{r}
## Load a package 
library(Matrix)

## Define a global variable
a.global.variable <- Matrix::Diagonal(3)

## Define a global function 
wait.then.square <- function(xx){
  ## Wait for 5 seconds
  Sys.sleep(5);
  ## Square the argument
  xx^2 
}

## Check that it works with plain lapply
serial.output <- lapply( 1:4, function(xx) {
      return( wait.then.square(xx) + a.global.variable )
    }) 

## Test with the modified mclapply  
par.output <- mclapply( 1:4, function(xx) {
      return( wait.then.square(xx) + a.global.variable )
    })

## Are they equal? 
all.equal( serial.output, par.output )
## [1] TRUE
```

# Request for feedback and help

I put this together because it helped to solve a specific problem that I was having. If it solves your problem, please let me know. If it needs to be modified to solve your problem, please either (i) open an issue on GitHub or (ii) even better, issue a pull request. 
