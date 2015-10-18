*PSID: Panel Study of Income Dynamics, https://psidonline.isr.umich.edu/

use psid_new, clear   

global year "1984 1989 1994 1999 2001 2003 2005 2007 2009 2011"
global id68 "V10400 V16605 ER2002 ER13019 ER17022 ER21009 ER25009 ER36009 ER42009 ER47309"
global sv "S111 S211 S311 S411 S511 S611 S711 S811 ER46954 ER52358"
global sd "S110 S210 S310 S410 S510 S610 S710 S810 ER46952 ER52356"
global cv "S105 S205 S305 S405 S505 S605 S705 S805 ER46942 ER52350"
global cd "S104 S204 S304 S404 S504 S604 S704 S804 ER46940 ER52348"
global w1 "S116 S216 S316 S416 S516 S616 S716 S816 ER46968 ER52392"
global w2 "S117 S217 S317 S417 S517 S617 S717 S817 ER46970 ER52394"
global age "V10419 V16631 ER2007 ER13010 ER17013 ER21017 ER25017 ER36017 ER42017 ER47317"
global mari "V10426 V16637 ER2014 ER13021 ER17024 ER21023 ER25023 ER36023 ER42023 ER47323"
global edu "V11002 V17501 ER3963 ER15952 ER20013 ER23450 ER27417 ER40589 ER46567 ER51928"
global fsize "V10418 V16630 ER2006 ER13009 ER17012 ER21016 ER25016 ER36016 ER42016 ER47316"
global inc "V11022 V17533 ER4153 ER16462 ER20456 ER24099 ER28037 ER41027 ER46935 ER52343"
global state "V12380 V17539 ER4157 ER13005 ER17005 ER21004 ER25004 ER36004 ER42004 ER47304"

keep $id68 $sv $sd $cv $cd $w1 $w2 $age $mari $edu $fsize $inc $state
save data1.0, replace

local varlist "sv sd cv cd w1 w2 age mari edu fsize inc state"
foreach b of local varlist{

  use data1.0, clear

  local n : word count $`b'

  forvalues i = 1/`n'{
    local x: word `i' of $`b'
    local y: word `i' of $id68
    local z: word `i' of $year
    preserve
    keep `x' `y'
    drop if missing(`x')
    drop if missing(`y')
    gen year = "`x'"
    replace year = "`z'"
    rename `x' `b'
    rename `y' id68
    save `x', replace
    restore
  }

  use S111, clear
  drop if _n!=0
  foreach a of global `b'{
    append using `a'
  }
  save `b', replace
  sum `b', detail
}
  
use sv, clear
local varlist "sv sd cv cd w1 w2 dv age mari edu fsize inc state"
foreach a of local varlist{
  merge m:m id68 year using `a'
  drop if _merge != 3
  drop _merge
}

save psid_merged, replace
