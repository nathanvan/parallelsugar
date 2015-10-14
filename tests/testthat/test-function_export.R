context('function export')

test_that("scoping is correct",{

  x <- 20
  f <- function() {
     x <- 10
     function(y) x + y
  }

  cl <- parallel::makeCluster( 2 )
  clusterExport_function(cl, f)
  par.out <- parLapply(cl, 1:length(cl), function(ii) {
    f()(1)
  })
  parallel::stopCluster(cl)

  expect_true( all( unlist(par.out) == f()(1) ) )

})
