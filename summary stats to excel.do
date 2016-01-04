*export summary stats to excel

set more off

sysuse auto, clear

local file_name "file_name"
foreach x of local file_name{
  global vars "price mpg rep78 headroom trunk weight length turn displacement gear_ratio"
  gen var=""
  gen count=.
  gen mean=.
  gen median=.
  gen sd=.
  gen min=.
  gen p25=.
  gen p75=.
  gen max=.

  local n: word count $vars
  forvalues i=1/`n' {

    local a: word `i' of $vars

    sum `a', detail
    replace var = "`a'" if _n==`i'
    replace count = r(N) if _n==`i'
    replace mean = r(mean) if _n==`i'
    replace median = r(p50) if _n==`i'
    replace sd = r(sd) if _n==`i'
    replace min = r(min) if _n==`i'
    replace max = r(max) if _n==`i'
    replace p25 = r(p25) if _n==`i'
    replace p75 = r(p75) if _n==`i'
    }

  preserve 
  drop if var==""
  keep var mean median sd count min max p25 p75
  export excel using `x', firstrow(var) replace
  restore

  drop var mean median sd count min max p25 p75
}
