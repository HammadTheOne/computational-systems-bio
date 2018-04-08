# Attempt to emulate BWT Algorithm

# Going to start by working through a test case to understand the mechanics.

# Workflow - Take in a string, perform all possible rotations with a trimmer symbol
# "smaller" than all other characters in the string.

# ATGCAT$
# $ATGCAT
# T$ATGCA
# AT$ATGC
# CAT$ATG
# GCAT$AT
# TGCAT$A

# ATGCAT$ <- Back to the initial point.

# Next, lexicographically sort the rows:

# $ATGCAT
# AT$ATGC
# ATGCAT$
# CAT$ATG 
# GCAT$AT
# T$ATGCA
# TGCAT$A

# Take the last column as BWT -> TC$GTAA

#first create a function to perform rotations.

rotate_character <- function(x){
  paste(substring(x, 2), substring(x, 1, 1), sep ='')
}


bwt <- function(x) {
  x <- paste(x, '$', sep='')
  final_product <- ''
  for (i in 1:length(x)) {
    temp <- rotate_character(x)
    print(temp)
    paste(final_product, temp[length(i)], sep='')
  }
  return(final_product)
  
}

test_string <- 'ATGCAT$'


bwt(test_string)
