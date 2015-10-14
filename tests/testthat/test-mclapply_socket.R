
context('mclapply_socket tests')

context(' + Simple example')
test_that("Simple Example",{

  require(Matrix)
  a.global.variable <- Matrix::Diagonal(3)
  wait.then.square <- function(xx){
    # Wait for one second
    Sys.sleep(1);
    # Square the argument
    xx^2 }

  serial.output <- lapply( 1:4,
                           function(xx) {
                             return( wait.then.square(xx) + a.global.variable )
                           })


  par.output <- mclapply( 1:4,
                          function(xx) {
                            return( wait.then.square(xx) + a.global.variable )
                          })

  expect_that(serial.output, equals(par.output))

#   ## Scope test, should fail
#   f.break <- function() {
#
#     wait.then.square <- function(xx){
#       # Wait for two seconds
#       Sys.sleep(2);
#       # Square the argument
#       xx^2+2 }
#
#     mclapply( 1:4,
#                    function(xx) {
#                      return( wait.then.square(xx) + a.global.variable )
#                    })
#
#   }
#
#   f.work <- function() {
#
#     wait.then.square <- function(xx){
#       # Wait for two seconds
#       Sys.sleep(2);
#       # Square the argument
#       xx^2 }
#
#     mclapply( 1:4,
#               function(xx) {
#                 return( wait.then.square(xx) + a.global.variable )
#               })
#
#   }
#
#   all.equal( f.break(), serial.output )
#   all.equal( f.work() , serial.output )
#
#   all.equal( serial.output,  par.output)
#
#
})
#
# x <- 20
# f <- function() {
#   x <- 10
#   function(y) x + y
# }
#
#
#
# # help(seq_along)
# # seq_along(x) is safer version of 1:length(x)
