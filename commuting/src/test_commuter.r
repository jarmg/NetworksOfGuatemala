library(testthat)
source("commuterCategorize.r")

# Init vals for testing
v <- c(1,2,2,1,3,2)
cells <- c("MIXCO", "JOYABAJ", "MIXCO", "GUATEMALA")
places <- c("Home", "Work", "Home", "Home")
label <- "Home"

context("Testing get_mode")
test_that("get_mode returns mode of int and char vecs", {
	      expect_equal(get_mode(v), 2)
	      expect_equal(as.character(get_mode(places)), "Home")
})

context("Testing get_home_or_work_loc_by_label")
test_that("get_home_or_work_loc_by_label returns mode", {
	      expect_equal(as.character(get_home_or_work_loc_by_label(cells, places, label)), "MIXCO")
})

